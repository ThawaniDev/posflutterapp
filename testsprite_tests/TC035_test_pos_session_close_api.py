import requests

BASE_URL = "http://localhost:8080"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_pos_session_close_api():
    # Authenticate and get token
    login_url = f"{BASE_URL}/api/auth/login"
    login_payload = {"email": EMAIL, "password": PASSWORD}
    login_resp = requests.post(login_url, json=login_payload, timeout=TIMEOUT)
    assert login_resp.status_code == 200, "Login failed"
    token = login_resp.json().get("token") or login_resp.json().get("access_token")
    assert token, "Bearer token missing in login response"
    headers = {"Authorization": f"Bearer {token}"}

    session_id = None
    try:
        # Step 1: Get list of POS terminals to get a valid terminal_id
        terminals_resp = requests.get(f"{BASE_URL}/api/pos/terminals", headers=headers, timeout=TIMEOUT)
        assert terminals_resp.status_code == 200, "Failed to get POS terminals"
        terminals = terminals_resp.json()
        assert isinstance(terminals, list) and len(terminals) > 0, "No POS terminals available"
        terminal_id = terminals[0].get("id")
        assert terminal_id, "Terminal ID missing"

        # Step 2: Create cash session
        session_payload = {
            "opening_cash": 100.0,
            "terminal_id": terminal_id
        }
        create_session_resp = requests.post(f"{BASE_URL}/api/cash-sessions", json=session_payload, headers=headers, timeout=TIMEOUT)
        assert create_session_resp.status_code == 201, f"Failed to create cash session, got {create_session_resp.status_code}"
        session_data = create_session_resp.json()
        session_id = session_data.get("id")
        assert session_id, "Created session ID missing"

        # Close the open session with closing_cash using PATCH method
        close_payload = {"closing_cash": 150.0}
        close_resp = requests.patch(f"{BASE_URL}/api/cash-sessions/{session_id}/close", json=close_payload, headers=headers, timeout=TIMEOUT)
        assert close_resp.status_code == 200, f"Closing session failed with status {close_resp.status_code}"
        close_data = close_resp.json()

        # Validate that z_report is present in response
        assert "z_report" in close_data and close_data["z_report"], "z_report missing or empty in close session response"

        # Validate session status closed (if such field exists)
        if "status" in close_data:
            assert close_data["status"].lower() == "closed", "Session status is not closed after closing"

        # Test 422 for closing already closed session with same session_id and closing_cash
        resp_422 = requests.patch(f"{BASE_URL}/api/cash-sessions/{session_id}/close", json=close_payload, headers=headers, timeout=TIMEOUT)
        assert resp_422.status_code == 422, f"Expected 422 for closing an already closed session, got {resp_422.status_code}"

    finally:
        # Cleanup: Delete the created cash session if possible
        if session_id:
            try:
                requests.delete(f"{BASE_URL}/api/cash-sessions/{session_id}", headers=headers, timeout=TIMEOUT)
            except Exception:
                pass


test_pos_session_close_api()
