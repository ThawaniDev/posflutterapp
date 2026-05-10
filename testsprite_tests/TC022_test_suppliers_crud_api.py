import requests

BASE_URL = "http://localhost:8080"
LOGIN_URL = f"{BASE_URL}/api/auth/login"
SUPPLIERS_URL = f"{BASE_URL}/api/suppliers"
TIMEOUT = 30

EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"

def test_suppliers_crud_api():
    # Login to get token
    login_payload = {"email": EMAIL, "password": PASSWORD}
    try:
        login_resp = requests.post(LOGIN_URL, json=login_payload, timeout=TIMEOUT)
        login_resp.raise_for_status()
        token = login_resp.json().get("access_token") or login_resp.json().get("token") or login_resp.json().get("accessToken")
        assert token and isinstance(token, str), "No token received on login"
    except Exception as e:
        assert False, f"Login failed: {e}"
    headers = {"Authorization": f"Bearer {token}"}

    # List suppliers - expect 200 and JSON list
    resp = requests.get(SUPPLIERS_URL, headers=headers, timeout=TIMEOUT)
    assert resp.status_code == 200, f"Expected 200 on list suppliers, got {resp.status_code}"
    suppliers_list = resp.json()
    assert isinstance(suppliers_list, list), "Suppliers list response is not a list"

    new_supplier_id = None
    # Create a new supplier (success case) - expect 201
    create_payload = {"name": "Test Supplier for CRUD"}
    resp = requests.post(SUPPLIERS_URL, headers=headers, json=create_payload, timeout=TIMEOUT)
    assert resp.status_code == 201, f"Expected 201 on create supplier, got {resp.status_code}"
    created_supplier = resp.json()
    new_supplier_id = created_supplier.get("id") or created_supplier.get("supplier_id")
    assert new_supplier_id is not None, "Created supplier ID missing"
    assert created_supplier.get("name") == "Test Supplier for CRUD"

    try:
        # Get the created supplier by ID - expect 200 and matching data
        get_url = f"{SUPPLIERS_URL}/{new_supplier_id}"
        resp = requests.get(get_url, headers=headers, timeout=TIMEOUT)
        assert resp.status_code == 200, f"Expected 200 on get supplier, got {resp.status_code}"
        supplier_data = resp.json()
        assert supplier_data.get("id") == new_supplier_id or supplier_data.get("supplier_id") == new_supplier_id
        assert supplier_data.get("name") == "Test Supplier for CRUD"

        # Update the supplier - expect 200 and updated name
        update_payload = {"name": "Updated Test Supplier"}
        resp = requests.put(get_url, headers=headers, json=update_payload, timeout=TIMEOUT)
        assert resp.status_code == 200, f"Expected 200 on update supplier, got {resp.status_code}"
        updated_supplier = resp.json()
        assert updated_supplier.get("name") == "Updated Test Supplier"

        # Test create supplier with missing name to get 422
        invalid_payload = {}
        resp = requests.post(SUPPLIERS_URL, headers=headers, json=invalid_payload, timeout=TIMEOUT)
        assert resp.status_code == 422, f"Expected 422 for missing name, got {resp.status_code}"

    finally:
        # Cleanup: Delete the created supplier
        if new_supplier_id:
            delete_url = f"{SUPPLIERS_URL}/{new_supplier_id}"
            try:
                del_resp = requests.delete(delete_url, headers=headers, timeout=TIMEOUT)
                # Accept 200 or 204 as deletion success
                assert del_resp.status_code in (200, 204), f"Expected 200/204 on delete supplier, got {del_resp.status_code}"
            except Exception:
                # Do not raise error during cleanup
                pass


test_suppliers_crud_api()
