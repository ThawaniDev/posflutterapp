import requests

BASE_URL = "http://localhost:8080"
LOGIN_URL = f"{BASE_URL}/api/auth/login"
REPORT_INVENTORY_TURNOVER_URL = f"{BASE_URL}/api/reports/inventory/turnover"
TIMEOUT = 30


def test_reports_inventory_turnover_api():
    # Login to get auth token
    login_payload = {
        "email": "owner@ostora.sa",
        "password": "owner@ostora.sa"
    }
    try:
        login_resp = requests.post(LOGIN_URL, json=login_payload, timeout=TIMEOUT)
        login_resp.raise_for_status()
        token = login_resp.json().get("token")
        assert token and isinstance(token, str) and token.startswith("Bearer") is False, \
            "Bearer token missing or malformed in login response"
        auth_token = f"Bearer {token}"
    except requests.RequestException as e:
        assert False, f"Login request failed: {e}"

    headers = {
        "Authorization": auth_token
    }

    # Call the inventory turnover report endpoint
    try:
        response = requests.get(REPORT_INVENTORY_TURNOVER_URL, headers=headers, timeout=TIMEOUT)
        response.raise_for_status()
    except requests.RequestException as e:
        assert False, f"GET /api/reports/inventory/turnover request failed: {e}"

    data = response.json()

    # Validate response structure and content
    # Expected: turnover rate per product (list/dict)
    assert isinstance(data, list) or isinstance(data, dict), "Response is not a list or dict"

    # If list, check each item has required keys, if dict, check keys accordingly
    # We'll assume a list of products with turnover_rate and product_id or name
    products = data if isinstance(data, list) else [data]
    assert len(products) > 0, "No products found in inventory turnover report"

    for item in products:
        assert isinstance(item, dict), "Each product item must be a dict"
        assert "product_id" in item or "product_name" in item, "Missing product_id or product_name in item"
        assert "turnover_rate" in item, "Missing turnover_rate in item"
        turnover_rate = item.get("turnover_rate")
        assert isinstance(turnover_rate, (int, float)), "turnover_rate must be a number"
        assert turnover_rate >= 0, "turnover_rate must be non-negative"

    print("test_reports_inventory_turnover_api passed")


test_reports_inventory_turnover_api()