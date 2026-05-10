import requests
import random


BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
WASTE_RECORDS_ENDPOINT = "/api/inventory/waste-records"
PRODUCTS_ENDPOINT = "/api/products"


def test_waste_records_api():
    session = requests.Session()
    timeout = 30

    # Step 1: Authenticate and get token
    login_payload = {
        "email": "owner@ostora.sa",
        "password": "owner@ostora.sa"
    }
    login_resp = session.post(
        BASE_URL + LOGIN_ENDPOINT,
        json=login_payload,
        timeout=timeout
    )
    assert login_resp.status_code == 200, f"Login failed: {login_resp.text}"
    token = login_resp.json().get("token") or login_resp.json().get("access_token")
    assert token is not None, "No token in login response"

    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }

    # Helper to create a product required for waste record
    def create_product():
        product_payload = {
            "name": "Waste Test Product",
            "sku": f"SKU-{int(100000 + random.random()*899999)}",
            "barcode": f"BC{int(100000 + random.random()*899999)}",
            "price": 10.0,
            "category_id": None  # Assuming optional, else should query categories
        }
        resp = session.post(
            BASE_URL + PRODUCTS_ENDPOINT,
            headers=headers,
            json=product_payload,
            timeout=timeout
        )
        assert resp.status_code == 201, f"Failed to create product: {resp.text}"
        return resp.json().get("id")

    # Create product for waste record usage
    product_id = None
    waste_record_id = None

    try:
        product_id = create_product()
        assert product_id is not None, "Created product has no ID"

        # Test 1: Create waste record with valid product_id, quantity, and reason
        valid_payload = {
            "product_id": product_id,
            "quantity": 5,
            "reason": "Test waste record creation"
        }
        resp_valid = session.post(
            BASE_URL + WASTE_RECORDS_ENDPOINT,
            headers=headers,
            json=valid_payload,
            timeout=timeout
        )
        assert resp_valid.status_code == 201, f"Valid waste record creation failed: {resp_valid.text}"
        waste_record_id = resp_valid.json().get("id")
        assert waste_record_id is not None, "Waste record creation response missing id"
        assert resp_valid.json().get("product_id") == product_id, "Waste record product_id mismatch"
        assert resp_valid.json().get("quantity") == 5, "Waste record quantity mismatch"
        assert resp_valid.json().get("reason") == "Test waste record creation", "Waste record reason mismatch"

        # Test 2: Create waste record with zero quantity -> expect 422
        zero_qty_payload = {
            "product_id": product_id,
            "quantity": 0,
            "reason": "Zero quantity test"
        }
        resp_zero_qty = session.post(
            BASE_URL + WASTE_RECORDS_ENDPOINT,
            headers=headers,
            json=zero_qty_payload,
            timeout=timeout
        )
        assert resp_zero_qty.status_code == 422, f"Expected 422 for zero quantity, got {resp_zero_qty.status_code}"

    finally:
        # Cleanup waste record if created
        if waste_record_id:
            session.delete(
                f"{BASE_URL}{WASTE_RECORDS_ENDPOINT}/{waste_record_id}",
                headers=headers,
                timeout=timeout
            )
        # Cleanup created product
        if product_id:
            session.delete(
                f"{BASE_URL}{PRODUCTS_ENDPOINT}/{product_id}",
                headers=headers,
                timeout=timeout
            )


test_waste_records_api()
