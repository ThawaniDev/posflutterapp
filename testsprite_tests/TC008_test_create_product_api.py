import requests
import uuid

BASE_URL = "http://localhost:8080"
AUTH_URL = f"{BASE_URL}/api/auth/login"
PRODUCTS_URL = f"{BASE_URL}/api/products"

EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"

TIMEOUT = 30


def test_create_product_api():
    # Authenticate and obtain token
    auth_payload = {"email": EMAIL, "password": PASSWORD}
    try:
        auth_resp = requests.post(AUTH_URL, json=auth_payload, timeout=TIMEOUT)
        assert auth_resp.status_code == 200, f"Login failed with status {auth_resp.status_code}"
        token = auth_resp.json().get("token") or auth_resp.json().get("access_token")
        assert token, "No token found in login response"
    except Exception as e:
        raise AssertionError(f"Authentication error: {str(e)}")

    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json",
    }

    # Construct product data
    unique_suffix = str(uuid.uuid4())[:8]
    product_data = {
        "name": {
            "en": f"Test Product EN {unique_suffix}",
            "ar": f"منتج اختبار {unique_suffix}"
        },
        "sku": f"SKU-{unique_suffix}",
        "barcode": f"1234567890{unique_suffix[-4:]}",  # barcode as string
        "price": 99.99,
        "category": "test-category",  # Assuming category ID or slug must be provided
        "variants": [
            {"name": "Size", "options": ["S", "M", "L"]},
            {"name": "Color", "options": ["Red", "Green", "Blue"]}
        ],
        "modifier_groups": [
            {
                "name": "Extras",
                "modifiers": [
                    {"name": "Cheese", "price": 1.0},
                    {"name": "Bacon", "price": 1.5}
                ]
            }
        ]
    }

    # Create product
    product_id = None
    try:
        create_resp = requests.post(PRODUCTS_URL, json=product_data, headers=headers, timeout=TIMEOUT)
        assert create_resp.status_code == 201, f"Product creation failed: {create_resp.status_code} {create_resp.text}"
        resp_json = create_resp.json()
        product_id = resp_json.get("id")
        assert product_id, "Response missing created product ID"

        # Validate response content
        assert resp_json.get("name") == product_data["name"], "Product name mismatch"
        assert resp_json.get("sku") == product_data["sku"], "SKU mismatch"
        assert resp_json.get("barcode") == product_data["barcode"], "Barcode mismatch"
        assert abs(float(resp_json.get("price", 0)) - product_data["price"]) < 0.01, "Price mismatch"
        # Category can be returned as id or slug, just check presence
        assert "category" in resp_json, "Category missing in response"
        assert isinstance(resp_json.get("variants"), list), "Variants missing or invalid"
        assert isinstance(resp_json.get("modifier_groups"), list), "Modifier groups missing or invalid"

    finally:
        # Cleanup: delete created product if exists
        if product_id:
            try:
                del_resp = requests.delete(f"{PRODUCTS_URL}/{product_id}", headers=headers, timeout=TIMEOUT)
                assert del_resp.status_code in (200, 204), f"Failed to delete product {product_id}"
            except Exception as e:
                print(f"Warning: Failed to delete product {product_id}: {e}")


test_create_product_api()