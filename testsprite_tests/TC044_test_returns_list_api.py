import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
RETURNS_LIST_ENDPOINT = "/api/orders/returns"
LOGIN_EMAIL = "owner@ostora.sa"
LOGIN_PASSWORD = "owner@ostora.sa"
TIMEOUT = 30

def test_returns_list_api():
    # Step 1: Authenticate and get Bearer token
    login_url = BASE_URL + LOGIN_ENDPOINT
    login_payload = {
        "email": LOGIN_EMAIL,
        "password": LOGIN_PASSWORD
    }
    try:
        login_response = requests.post(login_url, json=login_payload, timeout=TIMEOUT)
        assert login_response.status_code == 200, f"Login failed with status {login_response.status_code}"
        login_data = login_response.json()
        token = login_data.get("token") or login_data.get("accessToken") or login_data.get("access_token")
        assert token, "Auth token not found in login response"
    except Exception as e:
        raise AssertionError(f"Authentication failed: {e}")

    # Step 2: Call GET /api/orders/returns with Authorization header
    returns_url = BASE_URL + RETURNS_LIST_ENDPOINT
    headers = {
        "Authorization": f"Bearer {token}"
    }
    try:
        returns_response = requests.get(returns_url, headers=headers, timeout=TIMEOUT)
    except Exception as e:
        raise AssertionError(f"GET {RETURNS_LIST_ENDPOINT} request failed: {e}")

    # Step 3: Validate response status
    assert returns_response.status_code == 200, f"Expected status 200, got {returns_response.status_code}"
    
    try:
        returns_data = returns_response.json()
    except Exception as e:
        raise AssertionError(f"Response JSON decode error: {e}")

    # Step 4: Validate response is a list
    assert isinstance(returns_data, list), "Response is not a list"

    # Step 5: Validate each return entry contains refund amount and reason
    for idx, ret in enumerate(returns_data):
        assert isinstance(ret, dict), f"Return entry at index {idx} is not an object"
        assert "refund_amount" in ret or "refundAmount" in ret, f"Return at index {idx} missing refund amount"
        assert "reason" in ret or "return_reason" in ret, f"Return at index {idx} missing reason"

    print("test_returns_list_api passed.")

test_returns_list_api()