import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
STORES_MINE_ENDPOINT = "/api/core/stores/mine"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_stores_mine_api():
    # Step 1: Authenticate and get Bearer token
    login_url = BASE_URL + LOGIN_ENDPOINT
    login_payload = {"email": EMAIL, "password": PASSWORD}
    headers = {"Content-Type": "application/json"}
    try:
        login_response = requests.post(login_url, json=login_payload, headers=headers, timeout=TIMEOUT)
        login_response.raise_for_status()
    except requests.RequestException as e:
        assert False, f"Authentication request failed: {e}"
    login_data = login_response.json()
    assert "access_token" in login_data, "Login response missing access_token"
    token = login_data["access_token"]

    # Step 2: Call GET /api/core/stores/mine with Authorization header
    stores_url = BASE_URL + STORES_MINE_ENDPOINT
    auth_headers = {
        "Authorization": f"Bearer {token}"
    }
    try:
        stores_response = requests.get(stores_url, headers=auth_headers, timeout=TIMEOUT)
        stores_response.raise_for_status()
    except requests.RequestException as e:
        assert False, f"GET /api/core/stores/mine request failed: {e}"

    # Step 3: Validate response
    try:
        stores = stores_response.json()
    except ValueError:
        assert False, "Response is not valid JSON"

    assert isinstance(stores, list), f"Expected a list of stores, got {type(stores)}"

    # Each store must have id, name, and currency fields
    for store in stores:
        assert isinstance(store, dict), "Each store entry should be a dictionary"
        assert "id" in store, "Store missing 'id' field"
        assert "name" in store, "Store missing 'name' field"
        assert "currency" in store, "Store missing 'currency' field"

        # Additional data type checks (optional)
        assert isinstance(store["id"], (int, str)), "'id' should be int or str"
        assert isinstance(store["name"], str), "'name' should be a string"
        assert isinstance(store["currency"], str), "'currency' should be a string"


test_stores_mine_api()