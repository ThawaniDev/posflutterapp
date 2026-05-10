import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
ACTIVE_CASHIERS_ENDPOINT = "/api/owner-dashboard/active-cashiers"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30

def test_dashboard_active_cashiers_api():
    # Authenticate and get token
    try:
        login_resp = requests.post(
            BASE_URL + LOGIN_ENDPOINT,
            json={"email": EMAIL, "password": PASSWORD},
            timeout=TIMEOUT,
        )
        login_resp.raise_for_status()
    except requests.RequestException as e:
        raise AssertionError(f"Login request failed: {e}")

    login_data = login_resp.json()
    token = login_data.get("token") or login_data.get("access_token")
    assert token, "Authentication token not found in login response"

    headers = {
        "Authorization": f"Bearer {token}"
    }

    # Request active cashiers list
    try:
        resp = requests.get(BASE_URL + ACTIVE_CASHIERS_ENDPOINT, headers=headers, timeout=TIMEOUT)
        resp.raise_for_status()
    except requests.RequestException as e:
        raise AssertionError(f"GET {ACTIVE_CASHIERS_ENDPOINT} failed: {e}")

    data = resp.json()
    assert isinstance(data, list), "Response should be a list of active cashier sessions"

    # Assert each item has expected keys common for a cashier session (example keys)
    # Since schema not provided, check presence of typical keys like sessionId, cashierId, startTime, etc.
    for session in data:
        assert isinstance(session, dict), "Each active cashier session should be a dict"
        assert "id" in session or "sessionId" in session, "Session should have 'id' or 'sessionId'"
        # Optional keys checks
        # e.g., cashier info, start time, status could be present
        # but we won't be strict without explicit schema

    # Test passed if no assertion error raised


test_dashboard_active_cashiers_api()