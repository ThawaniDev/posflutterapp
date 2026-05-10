import requests

BASE_URL = "http://localhost:8080"
LOGIN_EMAIL = "owner@ostora.sa"
LOGIN_PASSWORD = "owner@ostora.sa"
TIMEOUT = 30

def test_pos_sessions_list_api():
    # Authenticate and get token
    login_url = f"{BASE_URL}/api/auth/login"
    login_payload = {"email": LOGIN_EMAIL, "password": LOGIN_PASSWORD}
    try:
        login_resp = requests.post(login_url, json=login_payload, timeout=TIMEOUT)
        assert login_resp.status_code == 200, f"Login failed with status {login_resp.status_code}"
        token = login_resp.json().get("token")
        assert token and isinstance(token, str), "Token not found or invalid in login response"
    except requests.RequestException as e:
        assert False, f"Login request failed: {e}"

    headers = {"Authorization": f"Bearer {token}"}
    sessions_url = f"{BASE_URL}/api/pos/sessions"

    try:
        resp = requests.get(sessions_url, headers=headers, timeout=TIMEOUT)
        assert resp.status_code == 200, f"Expected status 200 but got {resp.status_code}"
        sessions = resp.json()
        assert isinstance(sessions, list), "Response is not a list"
        for session in sessions:
            assert "status" in session, "Session missing 'status'"
            assert isinstance(session["status"], str), "'status' is not a string"
            assert "opening_cash" in session, "Session missing 'opening_cash'"
            assert isinstance(session["opening_cash"], (int, float)), "'opening_cash' is not a number"
            assert "terminal" in session, "Session missing 'terminal'"
            # terminal should be an object/dict with info
            terminal = session["terminal"]
            assert isinstance(terminal, dict), "'terminal' is not an object"
            # terminal likely contains 'id' and/or 'name' - check at least one key present
            assert any(k in terminal for k in ("id", "name", "serial", "status")), "Terminal info incomplete"
    except requests.RequestException as e:
        assert False, f"GET /api/pos/sessions request failed: {e}"

test_pos_sessions_list_api()