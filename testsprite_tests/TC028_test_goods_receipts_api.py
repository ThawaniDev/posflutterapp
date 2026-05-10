import requests
import uuid

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = f"{BASE_URL}/api/auth/login"
PO_ENDPOINT = f"{BASE_URL}/api/inventory/purchase-orders"
GOODS_RECEIPTS_ENDPOINT = f"{BASE_URL}/api/inventory/goods-receipts"

EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def get_auth_token():
    try:
        resp = requests.post(
            LOGIN_ENDPOINT,
            json={"email": EMAIL, "password": PASSWORD},
            timeout=TIMEOUT,
        )
        resp.raise_for_status()
        return resp.json().get("token") or resp.json().get("access_token")
    except Exception as e:
        raise RuntimeError(f"Failed to get auth token: {e}")


def create_purchase_order(headers):
    # Create minimal purchase order with required fields
    # Using unique supplier_name and some line items (we have no schema details but we'll create a minimal valid PO)
    po_data = {
        "supplier_name": f"Test Supplier {uuid.uuid4()}",
        "order_number": f"PO-{uuid.uuid4()}",
        "status": "open",
        "items": [
            {
                "product_id": None,
                "quantity": 5
            }
        ]
    }
    # Since product_id is required and we don't have one, we must get a valid product_id from catalog
    # We'll try to get a product id to use for the PO line item

    # Get product to use
    prod_resp = requests.get(f"{BASE_URL}/api/products", headers=headers, timeout=TIMEOUT)
    prod_resp.raise_for_status()
    products = prod_resp.json()
    product_id = None

    # Products list endpoint returns list or paginated? Attempt common keys
    # Let's try to support both:
    if isinstance(products, dict) and "data" in products:
        product_list = products["data"]
    elif isinstance(products, list):
        product_list = products
    else:
        product_list = []

    if len(product_list) == 0:
        raise RuntimeError("No products available to create purchase order.")

    product_id = product_list[0].get("id") or product_list[0].get("product_id")
    if not product_id:
        raise RuntimeError("Product id not found in product list.")

    po_data["items"][0]["product_id"] = product_id

    resp = requests.post(PO_ENDPOINT, headers=headers, json=po_data, timeout=TIMEOUT)
    resp.raise_for_status()
    po_created = resp.json()
    po_id = po_created.get("id") or po_created.get("purchase_order_id")
    if not po_id:
        raise RuntimeError("Failed to get purchase order ID after creation.")
    return po_id


def create_goods_receipt(headers, po_id):
    # Create a goods receipt against the existing PO
    # Assuming the goods receipt requires at least purchase_order_id and received items
    # Quantity to receive cannot exceed PO quantities (we'll receive full quantity)
    # Fetch the PO details to get product items and quantities
    resp = requests.get(f"{PO_ENDPOINT}/{po_id}", headers=headers, timeout=TIMEOUT)
    resp.raise_for_status()
    po_details = resp.json()

    items = po_details.get("items", [])
    if not items:
        raise RuntimeError("Purchase order has no items to receive.")

    receipt_items = []
    for item in items:
        product_id = item.get("product_id") or item.get("id")
        quantity = item.get("quantity") or item.get("qty") or 1
        receipt_items.append({"product_id": product_id, "received_quantity": quantity})

    receipt_data = {
        "purchase_order_id": po_id,
        "items": receipt_items,
        "receipt_number": f"GR-{uuid.uuid4()}",
        "notes": "Test goods receipt against PO"
    }

    resp = requests.post(GOODS_RECEIPTS_ENDPOINT, headers=headers, json=receipt_data, timeout=TIMEOUT)
    resp.raise_for_status()
    goods_receipt = resp.json()
    gr_id = goods_receipt.get("id") or goods_receipt.get("goods_receipt_id")
    if not gr_id:
        raise RuntimeError("Failed to get goods receipt ID after creation.")
    return gr_id


def delete_goods_receipt(headers, gr_id):
    # Assuming DELETE is supported to delete goods receipt
    try:
        resp = requests.delete(f"{GOODS_RECEIPTS_ENDPOINT}/{gr_id}", headers=headers, timeout=TIMEOUT)
        if resp.status_code not in (200, 204, 404):
            resp.raise_for_status()
    except Exception:
        pass


def delete_purchase_order(headers, po_id):
    # Assuming DELETE is supported to remove PO for cleanup
    try:
        resp = requests.delete(f"{PO_ENDPOINT}/{po_id}", headers=headers, timeout=TIMEOUT)
        if resp.status_code not in (200, 204, 404):
            resp.raise_for_status()
    except Exception:
        pass


def test_goods_receipts_api():
    token = get_auth_token()
    headers = {"Authorization": f"Bearer {token}"}

    # 1. Verify GET /api/inventory/goods-receipts lists all receipts
    resp = requests.get(GOODS_RECEIPTS_ENDPOINT, headers=headers, timeout=TIMEOUT)
    resp.raise_for_status()
    receipts_list = resp.json()
    assert isinstance(receipts_list, (list, dict)), "Goods receipts response expected list or dict"
    # If dict pagination, expect 'data' key holding list
    if isinstance(receipts_list, dict) and "data" in receipts_list:
        assert isinstance(receipts_list["data"], list), "Goods receipts data field should be a list"

    # 2. Create a PO, create receipt against it, then cleanup
    po_id = None
    gr_id = None
    try:
        po_id = create_purchase_order(headers)
        gr_id = create_goods_receipt(headers, po_id)

        # Verify new receipt was created successfully
        # GET by ID
        resp = requests.get(f"{GOODS_RECEIPTS_ENDPOINT}/{gr_id}", headers=headers, timeout=TIMEOUT)
        resp.raise_for_status()
        receipt = resp.json()
        assert receipt.get("purchase_order_id") == po_id or receipt.get("po_id") == po_id
        assert "items" in receipt and isinstance(receipt["items"], list)
        assert any(item.get("received_quantity", 0) > 0 for item in receipt["items"])

    finally:
        if gr_id:
            delete_goods_receipt(headers, gr_id)
        if po_id:
            delete_purchase_order(headers, po_id)


test_goods_receipts_api()