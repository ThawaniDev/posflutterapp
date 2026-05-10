import requests

BASE_URL = "http://localhost:8080"
LOGIN_URL = f"{BASE_URL}/api/auth/login"
SECURITY_POLICIES_URL = f"{BASE_URL}/api/config/security-policies"

EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_config_security_policies_api():
    # Step 1: Authenticate and get Bearer token
    login_payload = {
        "email": EMAIL,
        "password": PASSWORD
    }
    try:
        login_response = requests.post(LOGIN_URL, json=login_payload, timeout=TIMEOUT)
        assert login_response.status_code == 200, f"Login failed: {login_response.text}"
        login_data = login_response.json()
        token = login_data.get("token") or login_data.get("access_token")
        assert token, "No token found in login response"
    except (requests.RequestException, AssertionError) as e:
        raise AssertionError(f"Authentication error: {e}")

    headers = {
        "Authorization": f"Bearer {token}",
        "Accept": "application/json"
    }

    # Step 2: GET /api/config/security-policies with authorization header
    try:
        response = requests.get(SECURITY_POLICIES_URL, headers=headers, timeout=TIMEOUT)
    except requests.RequestException as e:
        raise AssertionError(f"Request to security policies endpoint failed: {e}")

    assert response.status_code == 200, f"Expected HTTP 200 but got {response.status_code}"
    try:
        data = response.json()
    except Exception as e:
        raise AssertionError(f"Response is not valid JSON: {e}")

    # Step 3: Validate required keys exist in the response JSON and not None
    for key in ["pin_required_actions", "session_timeout", "max_failed_attempts"]:
        assert key in data, f"Response JSON missing key: {key}"
        assert data[key] is not None, f"Response key '{key}' is None"

    # Optionally, validate types (e.g., session_timeout and max_failed_attempts as int, pin_required_actions as dict or list)
    assert isinstance(data["pin_required_actions"], (dict, list)), "pin_required_actions should be dict or list"
    assert isinstance(data["session_timeout"], int), "session_timeout should be an integer"
    assert isinstance(data["max_failed_attempts"], int), "max_failed_attempts should be an integer"


test_config_security_policies_api()