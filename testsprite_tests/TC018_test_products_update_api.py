import requests

BASE_URL = "http://localhost:8080"
LOGIN_URL = f"{BASE_URL}/api/auth/login"
PRODUCTS_URL = f"{BASE_URL}/api/products"

EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"

TIMEOUT = 30

def test_products_update_api():
    # Authenticate and get token
    login_payload = {
        "email": EMAIL,
        "password": PASSWORD
    }
    login_resp = requests.post(LOGIN_URL, json=login_payload, timeout=TIMEOUT)
    assert login_resp.status_code == 200, f"Login failed: {login_resp.text}"
    token = login_resp.json().get("token") or login_resp.json().get("access_token")
    assert token, "No token received on login"

    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }

    # Create a new product to update
    product_create_payload = {
        "name": "Test Product TC018",
        "price": 10.0,
        "sku": "TC018SKU",
        "barcode": "1234567890123",
        "category_id": None  # Assuming optional; if mandatory, then should create category first or omit for test
    }
    create_resp = requests.post(PRODUCTS_URL, json=product_create_payload, headers=headers, timeout=TIMEOUT)
    assert create_resp.status_code == 201, f"Product creation failed: {create_resp.text}"
    product = create_resp.json()
    product_id = product.get("id")
    assert product_id, "Created product has no id"

    try:
        # 1. Verify successful update of name and price
        update_payload = {
            "name": "Updated Product Name TC018",
            "price": 20.5
        }
        update_resp = requests.put(f"{PRODUCTS_URL}/{product_id}", json=update_payload, headers=headers, timeout=TIMEOUT)
        assert update_resp.status_code == 200, f"Updating product failed: {update_resp.text}"
        updated_product = update_resp.json()
        assert updated_product.get("name") == update_payload["name"], "Product name was not updated correctly"
        # Price may be float or string depending on API; convert to float for comparison
        updated_price = updated_product.get("price")
        assert updated_price is not None, "Updated product missing price"
        assert abs(float(updated_price) - update_payload["price"]) < 0.001, "Product price was not updated correctly"

        # 2. Verify 404 for unknown product ID on update
        unknown_id = "00000000-0000-0000-0000-000000000000"
        resp_404 = requests.put(f"{PRODUCTS_URL}/{unknown_id}", json=update_payload, headers=headers, timeout=TIMEOUT)
        assert resp_404.status_code == 404, f"Expected 404 for unknown product update, got {resp_404.status_code}"

        # 3. Verify 422 for invalid price (e.g., negative or string)
        invalid_price_payload = {
            "name": "Invalid Price Test",
            "price": -10  # Negative price invalid
        }
        resp_422_neg = requests.put(f"{PRODUCTS_URL}/{product_id}", json=invalid_price_payload, headers=headers, timeout=TIMEOUT)
        assert resp_422_neg.status_code == 422, f"Expected 422 for negative price, got {resp_422_neg.status_code}"

        # Also try non-numeric price (string)
        invalid_price_payload2 = {
            "name": "Invalid Price Test",
            "price": "not-a-number"
        }
        resp_422_str = requests.put(f"{PRODUCTS_URL}/{product_id}", json=invalid_price_payload2, headers=headers, timeout=TIMEOUT)
        assert resp_422_str.status_code == 422, f"Expected 422 for non-numeric price, got {resp_422_str.status_code}"

    finally:
        # Cleanup: delete created product
        del_resp = requests.delete(f"{PRODUCTS_URL}/{product_id}", headers=headers, timeout=TIMEOUT)
        # Allow 200 or 204 for successful delete
        assert del_resp.status_code in (200, 204), f"Failed to delete product after test: {del_resp.status_code} {del_resp.text}"

test_products_update_api()
