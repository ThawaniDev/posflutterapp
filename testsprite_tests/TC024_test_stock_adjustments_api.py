import requests

BASE_URL = "http://localhost:8080"
LOGIN_URL = f"{BASE_URL}/api/auth/login"
STOCK_ADJUSTMENTS_URL = f"{BASE_URL}/api/inventory/stock-adjustments"
PRODUCTS_URL = f"{BASE_URL}/api/products"


def test_stock_adjustments_api():
    # Login to get auth token
    login_payload = {"email": "owner@ostora.sa", "password": "owner@ostora.sa"}
    login_resp = requests.post(LOGIN_URL, json=login_payload, timeout=30)
    assert login_resp.status_code == 200, f"Login failed: {login_resp.text}"
    token = login_resp.json().get("token") or login_resp.json().get("access_token")
    assert token, "No token found in login response"

    headers = {"Authorization": f"Bearer {token}"}

    # Prepare: find a valid product_id, create product if none available
    product_id = None
    try:
        # Get list of products to obtain a valid product_id
        products_resp = requests.get(PRODUCTS_URL, headers=headers, timeout=30)
        products_resp.raise_for_status()
        products = products_resp.json()
        if isinstance(products, dict) and 'data' in products:
            # Data might be paginated with 'data' key
            products_list = products['data']
        elif isinstance(products, list):
            products_list = products
        else:
            products_list = []

        if not products_list:
            # No product exists, create one
            new_product_payload = {
                "name": "Test Product for Stock Adjustment",
                "price": 10,
                "sku": "testsku123",
                "barcode": "1234567890123",
                "category_id": None  # Assuming optional or nullable category
            }
            create_resp = requests.post(PRODUCTS_URL, json=new_product_payload, headers=headers, timeout=30)
            create_resp.raise_for_status()
            product_id = create_resp.json().get("id")
            assert product_id, "Failed to create product for test"
            created_product = True
        else:
            product_id = products_list[0].get("id") or products_list[0].get("product_id") or products_list[0].get("id")
            created_product = False

        # Test 1: Valid stock adjustment creation
        valid_payload = {"product_id": product_id, "quantity": 5, "reason": "Inventory correction"}
        adj_resp = requests.post(STOCK_ADJUSTMENTS_URL, json=valid_payload, headers=headers, timeout=30)
        assert adj_resp.status_code == 201 or adj_resp.status_code == 200, f"Valid adjustment failed: {adj_resp.status_code} {adj_resp.text}"
        adj_json = adj_resp.json()
        assert adj_json.get("id") or adj_json.get("adjustment_id"), "No adjustment ID returned"

        # Test 2: Zero quantity returns 422
        zero_qty_payload = {"product_id": product_id, "quantity": 0, "reason": "Inventory correction"}
        zero_qty_resp = requests.post(STOCK_ADJUSTMENTS_URL, json=zero_qty_payload, headers=headers, timeout=30)
        assert zero_qty_resp.status_code == 422, f"Zero quantity did not return 422 but {zero_qty_resp.status_code}"

        # Test 3: Missing product_id returns 422
        missing_product_payload = {"quantity": 3, "reason": "Inventory correction"}
        missing_product_resp = requests.post(STOCK_ADJUSTMENTS_URL, json=missing_product_payload, headers=headers, timeout=30)
        assert missing_product_resp.status_code == 422, f"Missing product_id did not return 422 but {missing_product_resp.status_code}"

    finally:
        # Cleanup created product if any
        if 'created_product' in locals() and created_product and product_id:
            try:
                requests.delete(f"{PRODUCTS_URL}/{product_id}", headers=headers, timeout=30)
            except Exception:
                pass


test_stock_adjustments_api()