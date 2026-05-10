import requests

BASE_URL = "http://localhost:8080"
LOGIN_URL = f"{BASE_URL}/api/auth/login"
EXPIRY_ALERTS_URL = f"{BASE_URL}/api/inventory/expiry-alerts"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_expiry_alerts_api():
    # Authenticate and get token
    try:
        login_resp = requests.post(
            LOGIN_URL,
            json={"email": EMAIL, "password": PASSWORD},
            timeout=TIMEOUT,
        )
        login_resp.raise_for_status()
    except requests.RequestException as e:
        assert False, f"Authentication failed: {e}"

    resp_json = login_resp.json()
    token = resp_json.get("token") or resp_json.get("access_token") or resp_json.get("data", {}).get("token")
    assert token, "Authentication token not found in login response"

    headers = {"Authorization": f"Bearer {token}"}

    # Call expiry alerts endpoint
    try:
        resp = requests.get(EXPIRY_ALERTS_URL, headers=headers, timeout=TIMEOUT)
        resp.raise_for_status()
    except requests.RequestException as e:
        assert False, f"GET /api/inventory/expiry-alerts request failed: {e}"

    data = resp.json()
    # Expecting a list or dict containing products with expiry info
    # Validate response is list or contains 'products' key that is list
    if isinstance(data, dict):
        # Try to find the list inside dictionary keys
        if "products" in data and isinstance(data["products"], list):
            products = data["products"]
        elif "data" in data and isinstance(data["data"], list):
            products = data["data"]
        else:
            # fallback if keys not known; check if dict keys are product ids
            products = []
            for key, val in data.items():
                if isinstance(val, dict) and "days_until_expiry" in val:
                    products.append(val)
    elif isinstance(data, list):
        products = data
    else:
        products = []

    assert isinstance(products, list), "Expiry alerts response should contain a list of products"

    # If no products returned, consider this passing (empty is allowed)
    for product in products:
        assert isinstance(product, dict), "Each product item should be a dict"
        assert (
            "days_until_expiry" in product
        ), "Each product must include 'days_until_expiry' field"
        days = product["days_until_expiry"]
        assert isinstance(days, int), "'days_until_expiry' must be integer"
        # days_until_expiry should be non-negative or negative if expired (allow as per requirements)
        # Just assert it's int; no negative check needed unless specified

    print("test_expiry_alerts_api passed.")


test_expiry_alerts_api()