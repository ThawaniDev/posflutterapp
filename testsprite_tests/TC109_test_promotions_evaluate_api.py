import requests

BASE_URL = "http://localhost:8080"
LOGIN_URL = f"{BASE_URL}/api/auth/login"
PROMOTIONS_EVALUATE_URL = f"{BASE_URL}/api/promotions/evaluate"

EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"


def test_promotions_evaluate_api():
    # Authenticate and get token
    login_payload = {"email": EMAIL, "password": PASSWORD}
    try:
        login_resp = requests.post(LOGIN_URL, json=login_payload, timeout=30)
        login_resp.raise_for_status()
        token = login_resp.json().get("token") or login_resp.json().get("access_token")
        assert token and isinstance(token, str), "Auth token missing or not a string"
    except Exception as e:
        assert False, f"Authentication failed: {e}"

    headers = {"Authorization": f"Bearer {token}", "Content-Type": "application/json"}

    # Prepare a sample cart with items and a customer_id
    # We don't have specific product ids or customer_id from input,
    # so use a placeholder customer_id and cart_items with mock data.
    # Usually, customer_id and product_ids should exist. 
    # Here we assume '1' as customer_id and product_id for test; 
    # if invalid, response will be caught as error.
    customer_id = 1
    cart_items = [
        {"product_id": 1, "quantity": 2, "unit_price": 50.0},
        {"product_id": 2, "quantity": 1, "unit_price": 100.0},
    ]

    payload = {"customer_id": customer_id, "cart_items": cart_items}

    try:
        resp = requests.post(PROMOTIONS_EVALUATE_URL, headers=headers, json=payload, timeout=30)
        resp.raise_for_status()
        data = resp.json()

        assert "applicable_promotions" in data, "Response missing 'applicable_promotions'"
        assert isinstance(data["applicable_promotions"], list), "'applicable_promotions' is not a list"

        assert "total_discount" in data, "Response missing 'total_discount'"
        total_discount = data["total_discount"]

        # total_discount should be numeric (int or float)
        assert isinstance(total_discount, (int, float)), "'total_discount' is not a number"

        # For this non-empty cart, total_discount should be >= 0 (discount may be zero if no promos apply)
        assert total_discount >= 0, "'total_discount' is negative"

    except Exception as e:
        assert False, f"Failed to evaluate promotions with non-empty cart: {e}"

    # Now test empty cart returns zero discount
    empty_payload = {"customer_id": customer_id, "cart_items": []}
    try:
        empty_resp = requests.post(PROMOTIONS_EVALUATE_URL, headers=headers, json=empty_payload, timeout=30)
        empty_resp.raise_for_status()
        empty_data = empty_resp.json()

        assert "applicable_promotions" in empty_data, "Empty cart response missing 'applicable_promotions'"
        assert isinstance(empty_data["applicable_promotions"], list), "Empty cart 'applicable_promotions' not a list"

        assert "total_discount" in empty_data, "Empty cart response missing 'total_discount'"

        empty_total_discount = empty_data["total_discount"]
        assert isinstance(empty_total_discount, (int, float)), "Empty cart 'total_discount' is not a number"
        assert empty_total_discount == 0, "Empty cart 'total_discount' is not zero"

    except Exception as e:
        assert False, f"Failed to evaluate promotions with empty cart: {e}"


test_promotions_evaluate_api()