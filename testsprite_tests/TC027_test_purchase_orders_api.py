import requests
import uuid

BASE_URL = "http://localhost:8080"
LOGIN_URL = f"{BASE_URL}/api/auth/login"
PO_BASE_URL = f"{BASE_URL}/api/inventory/purchase-orders"
SUPPLIERS_URL = f"{BASE_URL}/api/catalog/suppliers"

EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30

def test_purchase_orders_api():
    session = requests.Session()
    # Authenticate and get token
    resp = session.post(LOGIN_URL, json={"email": EMAIL, "password": PASSWORD}, timeout=TIMEOUT)
    assert resp.status_code == 200, "Login failed"
    token = resp.json().get("access_token") or resp.json().get("token")
    assert token, "No access token in login response"

    headers = {"Authorization": f"Bearer {token}", "Content-Type": "application/json"}

    supplier_id = None
    po_id = None

    try:
        # First, get or create a supplier to use in PO creation
        resp_suppliers = session.get(SUPPLIERS_URL, headers=headers, timeout=TIMEOUT)
        assert resp_suppliers.status_code == 200, "Failed to get suppliers"
        suppliers_list = resp_suppliers.json()
        if suppliers_list and isinstance(suppliers_list, list):
            supplier_id = suppliers_list[0].get("id")
        # If no supplier exists, create one
        if not supplier_id:
            supplier_data = {
                "name": f"Test Supplier {str(uuid.uuid4())[:8]}"
            }
            resp_create_supplier = session.post(SUPPLIERS_URL, headers=headers, json=supplier_data, timeout=TIMEOUT)
            assert resp_create_supplier.status_code == 201, "Supplier creation failed"
            supplier_id = resp_create_supplier.json().get("id")
            assert supplier_id, "No supplier ID returned on creation"

        # 1. Create Purchase Order (POST)
        po_payload = {
            "supplier_id": supplier_id,
            "order_number": f"PO-{str(uuid.uuid4())[:8]}",
            "items": [
                # Assuming minimal item info needed; actual schema not fully defined, so minimal example
                {"product_id": None, "quantity": 5, "price": 100}
            ]
        }
        # Since product_id is not specified and we only test PO creation, try with items empty or product_id null (if allowed)
        # To be safe, remove product_id from item (depends on API, so we keep it None and hope API handles)
        # But if it errors, drop product_id key.
        po_payload["items"][0].pop("product_id")

        resp_create_po = session.post(PO_BASE_URL, headers=headers, json=po_payload, timeout=TIMEOUT)
        assert resp_create_po.status_code == 201, "Purchase order creation failed"
        po = resp_create_po.json()
        po_id = po.get("id")
        assert po_id, "No purchase order ID returned on creation"
        assert po.get("supplier_id") == supplier_id, "Supplier ID mismatch in created PO"

        # 2. List Purchase Orders (GET)
        resp_list_po = session.get(PO_BASE_URL, headers=headers, timeout=TIMEOUT)
        assert resp_list_po.status_code == 200, "Failed to list purchase orders"
        po_list = resp_list_po.json()
        assert any(p.get("id") == po_id for p in po_list), "Created PO not in list"

        # 3. Get Single Purchase Order (GET)
        resp_get_po = session.get(f"{PO_BASE_URL}/{po_id}", headers=headers, timeout=TIMEOUT)
        assert resp_get_po.status_code == 200, "Failed to get single purchase order"
        po_single = resp_get_po.json()
        assert po_single.get("id") == po_id, "Purchase order ID mismatch on get single"
        assert po_single.get("supplier_id") == supplier_id, "Supplier ID mismatch on get single"

        # 4. Test 422 for missing supplier_id (POST)
        invalid_po_payload = {
            # "supplier_id" omitted intentionally to provoke 422
            "order_number": f"PO-{str(uuid.uuid4())[:8]}",
            "items": [
                {"quantity": 3, "price": 50}
            ]
        }
        resp_invalid_po = session.post(PO_BASE_URL, headers=headers, json=invalid_po_payload, timeout=TIMEOUT)
        assert resp_invalid_po.status_code == 422, f"Expected 422 for missing supplier_id but got {resp_invalid_po.status_code}"

    finally:
        # Cleanup: delete created purchase order
        if po_id:
            resp_delete_po = session.delete(f"{PO_BASE_URL}/{po_id}", headers=headers, timeout=TIMEOUT)
            # 200 or 204 expected for successful delete; if not, ignore but print warning
            if resp_delete_po.status_code not in (200, 204):
                print(f"Warning: Failed to delete purchase order {po_id}, status: {resp_delete_po.status_code}")

        # Cleanup: delete created supplier if we created one and no suppliers existed initially
        # Only delete if supplier created by this test
        # We check if supplier_id was first gotten or created
        # If supplier created in this test, delete it
        if supplier_id and (suppliers_list == [] or suppliers_list is None):
            resp_delete_supplier = session.delete(f"{SUPPLIERS_URL}/{supplier_id}", headers=headers, timeout=TIMEOUT)
            if resp_delete_supplier.status_code not in (200, 204):
                print(f"Warning: Failed to delete supplier {supplier_id}, status: {resp_delete_supplier.status_code}")

test_purchase_orders_api()