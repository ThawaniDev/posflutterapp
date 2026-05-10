import requests

BASE_URL = "http://localhost:8080"
LOGIN_URL = f"{BASE_URL}/api/auth/login"
CASH_SESSIONS_URL = f"{BASE_URL}/api/cash-sessions"
POS_TERMINALS_URL = f"{BASE_URL}/api/pos/terminals"
TIMEOUT = 30

EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"

def test_concurrent_pos_sessions():
    # Authenticate and get bearer token
    login_data = {"email": EMAIL, "password": PASSWORD}
    login_resp = requests.post(LOGIN_URL, json=login_data, timeout=TIMEOUT)
    assert login_resp.status_code == 200, f"Login failed: {login_resp.text}"
    token = login_resp.json().get("token")
    assert token, "No token returned from login"
    headers = {"Authorization": f"Bearer {token}"}

    # Get POS terminals
    terminals_resp = requests.get(POS_TERMINALS_URL, headers=headers, timeout=TIMEOUT)
    assert terminals_resp.status_code == 200, f"Failed to fetch terminals: {terminals_resp.text}"
    terminals = terminals_resp.json()
    assert terminals and isinstance(terminals, list), "Terminals list empty or invalid"
    terminal = None
    for t in terminals:
        if t.get("status", "").lower() == "active":
            terminal = t
            break
    if not terminal:
        terminal = terminals[0]  # fallback
    terminal_id = terminal.get("id")
    assert terminal_id, "Terminal ID not found"

    # Function to create a cash session (open shift)
    def create_cash_session():
        open_session_data = {
            "terminal_id": terminal_id,
            "opening_cash": 100.0
        }
        return requests.post(CASH_SESSIONS_URL, headers=headers, json=open_session_data, timeout=TIMEOUT)

    # Create first session
    resp1 = create_cash_session()
    assert resp1.status_code == 201, f"First cash session creation failed: {resp1.text}"
    session1 = resp1.json()
    session1_id = session1.get("id")
    assert session1_id, "First cash session ID missing"

    try:
        # Attempt second session creation on same terminal
        resp2 = create_cash_session()
        assert resp2.status_code == 422, f"Second cash session creation expected 422 but got {resp2.status_code}"

        resp2_json = resp2.json()
        error_msg = resp2_json.get("message") or resp2_json.get("error") or ""
        assert error_msg, "Expected error message in 422 response"

        valid_error = any(kw in error_msg.lower() for kw in ["already", "open", "session", "concurrent", "conflict"])
        assert valid_error, f"422 error message does not indicate concurrent session issue: {error_msg}"

    finally:
        # Close the first session (patch)
        close_url = f"{CASH_SESSIONS_URL}/{session1_id}/close"
        close_resp = requests.patch(close_url, headers=headers, timeout=TIMEOUT)
        if close_resp.status_code not in (200, 422):
            # Try delete if supported
            delete_url = f"{CASH_SESSIONS_URL}/{session1_id}"
            requests.delete(delete_url, headers=headers, timeout=TIMEOUT)


test_concurrent_pos_sessions()
