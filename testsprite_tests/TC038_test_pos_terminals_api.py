import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
POS_TERMINALS_ENDPOINT = "/api/pos/terminals"
AUTH_EMAIL = "owner@ostora.sa"
AUTH_PASSWORD = "owner@ostora.sa"
TIMEOUT = 30

def test_pos_terminals_api():
    # Login to get auth token
    login_url = BASE_URL + LOGIN_ENDPOINT
    login_payload = {"email": AUTH_EMAIL, "password": AUTH_PASSWORD}
    try:
        login_response = requests.post(login_url, json=login_payload, timeout=TIMEOUT)
        login_response.raise_for_status()
    except requests.RequestException as e:
        assert False, f"Login request failed: {e}"
    login_data = login_response.json()
    token = login_data.get("token") or login_data.get("access_token")
    assert token, "Login response does not contain a token"

    headers = {"Authorization": f"Bearer {token}"}

    # Request the list of POS terminals
    terminals_url = BASE_URL + POS_TERMINALS_ENDPOINT
    try:
        resp = requests.get(terminals_url, headers=headers, timeout=TIMEOUT)
        resp.raise_for_status()
    except requests.RequestException as e:
        assert False, f"GET {POS_TERMINALS_ENDPOINT} failed: {e}"

    data = resp.json()
    assert isinstance(data, list), "Response is not a list"

    # Verify each terminal has 'name' and 'status'
    for terminal in data:
        assert isinstance(terminal, dict), "Terminal item is not a dict"
        assert "name" in terminal, "Terminal item missing 'name'"
        assert "status" in terminal, "Terminal item missing 'status'"
        assert isinstance(terminal["name"], str) and terminal["name"], "'name' should be a non-empty string"
        assert isinstance(terminal["status"], str) and terminal["status"], "'status' should be a non-empty string"

test_pos_terminals_api()