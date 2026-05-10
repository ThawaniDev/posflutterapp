import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
PRODUCTS_ENDPOINT = "/api/catalog/products"

EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30

def authenticate():
    url = BASE_URL + LOGIN_ENDPOINT
    payload = {"email": EMAIL, "password": PASSWORD}
    response = requests.post(url, json=payload, timeout=TIMEOUT)
    response.raise_for_status()
    token = response.json().get("token") or response.json().get("access_token")
    assert token, "Authentication token not found in login response"
    return token

def create_product(headers):
    url = BASE_URL + PRODUCTS_ENDPOINT
    # Minimal valid product data, may need adjustment based on actual requirements
    payload = {
        "name": "Test Product TC017",
        "sku": "TC017SKU",
        "barcode": "000000000017",
        "price": 10.0,
        "category_id": None  # We don't know required fields exactly; if category_id required, adjust below
    }
    # Attempt to find a valid category_id first
    categories_url = BASE_URL + "/api/catalog/categories"
    cat_resp = requests.get(categories_url, headers=headers, timeout=TIMEOUT)
    cat_resp.raise_for_status()
    categories = cat_resp.json()
    if isinstance(categories, list) and categories:
        payload["category_id"] = categories[0].get("id")
    else:
        # If no categories found, remove category_id from payload
        payload.pop("category_id", None)

    response = requests.post(url, json=payload, headers=headers, timeout=TIMEOUT)
    response.raise_for_status()
    product = response.json()
    product_id = product.get("id")
    assert product_id is not None, "Created product ID not found"
    return product_id

def delete_product(product_id, headers):
    url = f"{BASE_URL}{PRODUCTS_ENDPOINT}/{product_id}"
    response = requests.delete(url, headers=headers, timeout=TIMEOUT)
    if response.status_code not in [200, 204, 404]:
        # 404 means already deleted, acceptable for cleanup
        response.raise_for_status()

def test_products_get_single_api():
    token = authenticate()
    headers = {"Authorization": f"Bearer {token}"}

    product_id = None
    try:
        # Create product to test GET valid ID
        product_id = create_product(headers)

        # GET product by valid ID
        url_valid = f"{BASE_URL}{PRODUCTS_ENDPOINT}/{product_id}"
        resp_valid = requests.get(url_valid, headers=headers, timeout=TIMEOUT)
        assert resp_valid.status_code == 200, f"Expected 200, got {resp_valid.status_code}"
        product_data = resp_valid.json()
        assert product_data.get("id") == product_id, "Returned product ID mismatch"
        assert "name" in product_data, "Product name missing in response"
        assert "price" in product_data, "Product price missing in response"

        # GET product by invalid ID (very unlikely ID)
        invalid_id = 999999999999
        url_invalid = f"{BASE_URL}{PRODUCTS_ENDPOINT}/{invalid_id}"
        resp_invalid = requests.get(url_invalid, headers=headers, timeout=TIMEOUT)
        assert resp_invalid.status_code == 404, f"Expected 404 for unknown ID, got {resp_invalid.status_code}"

    finally:
        if product_id:
            delete_product(product_id, headers)

test_products_get_single_api()