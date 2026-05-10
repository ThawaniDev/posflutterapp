import requests

BASE_URL = "http://localhost:8080"
LOGIN_URL = f"{BASE_URL}/api/auth/login"
PRODUCTS_URL = f"{BASE_URL}/api/products"
AUTH_CREDENTIALS = {"email": "owner@ostora.sa", "password": "owner@ostora.sa"}
TIMEOUT = 30


def test_products_delete_api():
    # Authenticate and get token
    resp_login = requests.post(LOGIN_URL, json=AUTH_CREDENTIALS, timeout=TIMEOUT)
    assert resp_login.status_code == 200
    token = resp_login.json().get("token")
    assert token, "Authentication token not found in login response"
    headers = {"Authorization": f"Bearer {token}"}

    product_id = None
    try:
        # Attempt to get first category to assign category_id (required)
        cat_resp = requests.get(f"{BASE_URL}/api/categories", headers=headers, timeout=TIMEOUT)
        assert cat_resp.status_code == 200, "Failed to fetch categories"
        categories = cat_resp.json()
        assert isinstance(categories, list) and len(categories) > 0, "No categories found for product creation"
        category_id = categories[0].get("id")
        assert category_id, "Category ID not found in fetched categories"

        # Create a new product to delete
        product_payload = {
            "name": {"en": "Test Product Delete TC019", "ar": "منتج اختبار حذف"},
            "sku": "TC019-SKU-001",
            "barcode": "000000000019",
            "price": 9.99,
            "category_id": category_id
        }

        # Create product
        resp_create = requests.post(PRODUCTS_URL, json=product_payload, headers=headers, timeout=TIMEOUT)
        assert resp_create.status_code in (200, 201)
        product = resp_create.json()
        product_id = product.get("id")
        assert product_id, "Created product ID not found"

        # DELETE the product
        delete_resp = requests.delete(f"{PRODUCTS_URL}/{product_id}", headers=headers, timeout=TIMEOUT)
        assert delete_resp.status_code in (200, 204)

        # DELETE again - should return 404
        delete_again_resp = requests.delete(f"{PRODUCTS_URL}/{product_id}", headers=headers, timeout=TIMEOUT)
        assert delete_again_resp.status_code == 404

    finally:
        # Cleanup: ensure product is deleted if somehow left
        if product_id is not None:
            try:
                _ = requests.delete(f"{PRODUCTS_URL}/{product_id}", headers=headers, timeout=TIMEOUT)
            except Exception:
                pass


test_products_delete_api()
