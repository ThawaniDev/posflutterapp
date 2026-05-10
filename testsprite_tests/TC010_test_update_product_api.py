import requests
import uuid

BASE_URL = "http://localhost:8080"

LOGIN_EMAIL = "owner@ostora.sa"
LOGIN_PASSWORD = "owner@ostora.sa"

TIMEOUT = 30


def authenticate():
    url = f"{BASE_URL}/api/auth/login"
    payload = {"email": LOGIN_EMAIL, "password": LOGIN_PASSWORD}
    response = requests.post(url, json=payload, timeout=TIMEOUT)
    response.raise_for_status()
    token = response.json().get("token")
    assert token, "Authentication token not found in response"
    return token


def create_product(token):
    url = f"{BASE_URL}/api/products"
    headers = {"Authorization": f"Bearer {token}"}
    unique_suffix = str(uuid.uuid4())[:8]
    payload = {
        "name": {"en": f"Test Product EN {unique_suffix}", "ar": f"اختبار المنتج AR {unique_suffix}"},
        "sku": f"SKU-{unique_suffix}",
        "barcode": f"BARCODE-{unique_suffix}",
        "price": 19.99,
        "category_id": None,  # Assuming category is optional; else modify after fetching categories
        "is_active": True,
        "variants": [],
        "modifier_groups": []
    }
    resp = requests.post(url, json=payload, headers=headers, timeout=TIMEOUT)
    resp.raise_for_status()
    product = resp.json()
    product_id = product.get("id") or product.get("_id")
    assert product_id, "Created product ID not found"
    return product_id


def get_product(token, product_id):
    url = f"{BASE_URL}/api/products/{product_id}"
    headers = {"Authorization": f"Bearer {token}"}
    response = requests.get(url, headers=headers, timeout=TIMEOUT)
    response.raise_for_status()
    return response.json()


def update_product(token, product_id, update_payload):
    url = f"{BASE_URL}/api/products/{product_id}"
    headers = {"Authorization": f"Bearer {token}"}
    response = requests.put(url, json=update_payload, headers=headers, timeout=TIMEOUT)
    return response


def delete_product(token, product_id):
    url = f"{BASE_URL}/api/products/{product_id}"
    headers = {"Authorization": f"Bearer {token}"}
    response = requests.delete(url, headers=headers, timeout=TIMEOUT)
    return response


def test_update_product_api():
    token = authenticate()
    product_id = None
    try:
        # Create a new product to update
        product_id = create_product(token)

        # Prepare update payload with changes to product details
        update_payload = {
            "name": {"en": "Updated Product Name EN", "ar": "المنتج المحدث AR"},
            "sku": "UPDATED-SKU-12345",
            "barcode": "UPDATED-BARCODE-12345",
            "price": 29.99,
            "is_active": False,
            "variants": [],
            "modifier_groups": []
        }

        # Update the product
        update_response = update_product(token, product_id, update_payload)
        assert update_response.status_code == 200, f"Expected 200 OK, got {update_response.status_code}"
        updated_product = update_response.json()
        for key in update_payload:
            assert updated_product.get(key) == update_payload[key], f"Field {key} not updated correctly"

        # Retrieve the product to verify changes persisted
        fetched_product = get_product(token, product_id)
        for key in update_payload:
            assert fetched_product.get(key) == update_payload[key], f"Field {key} mismatch after update"

    finally:
        # Cleanup: delete the created product
        if product_id:
            del_response = delete_product(token, product_id)
            # Allow 200 or 204 for successful deletion
            assert del_response.status_code in (200, 204), f"Failed to delete product with status {del_response.status_code}"


test_update_product_api()