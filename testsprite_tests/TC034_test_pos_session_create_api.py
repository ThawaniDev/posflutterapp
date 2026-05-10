import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
POS_SESSIONS_ENDPOINT = "/api/pos/sessions"
TIMEOUT = 30

EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"

def authenticate():
    auth_url = BASE_URL + LOGIN_ENDPOINT
    payload = {"email": EMAIL, "password": PASSWORD}
    try:
        resp = requests.post(auth_url, json=payload, timeout=TIMEOUT)
        resp.raise_for_status()
        token = resp.json().get("access_token")
        assert token, "No access_token in login response"
        return token
    except requests.RequestException as e:
        raise RuntimeError(f"Authentication failed: {e}")

def test_pos_session_create_api():
    token = authenticate()
    headers = {"Authorization": f"Bearer {token}", "Content-Type": "application/json"}

    # Step 1: Get available terminals from /api/pos/terminals (required to get terminal_id)
    # As terminal_id is required but not provided in test data, we must query for a terminal.
    terminals_url = BASE_URL + "/api/pos/terminals"
    try:
        resp = requests.get(terminals_url, headers=headers, timeout=TIMEOUT)
        resp.raise_for_status()
        terminals = resp.json()
        assert isinstance(terminals, list) and len(terminals) > 0, "No POS terminals available"
        terminal_id = terminals[0].get("id")
        assert terminal_id, "Terminal id not found"
    except requests.RequestException as e:
        raise RuntimeError(f"Failed to get POS terminals: {e}")

    created_session_id = None

    try:
        # Positive test: create session with valid opening_cash and terminal_id
        valid_payload = {"opening_cash": 100.0, "terminal_id": terminal_id}
        resp = requests.post(
            BASE_URL + POS_SESSIONS_ENDPOINT, 
            headers=headers, 
            json=valid_payload, 
            timeout=TIMEOUT
        )
        assert resp.status_code == 201, f"Unexpected status code {resp.status_code} for valid session creation"
        data = resp.json()
        created_session_id = data.get("id")
        assert created_session_id, "Created session ID missing"
        assert float(data.get("opening_cash", 0)) == valid_payload["opening_cash"], "Opening cash mismatch"
        assert data.get("terminal_id") == terminal_id, "Terminal ID mismatch"
        assert data.get("status") in ["open", "active"], "Unexpected session status"

        # Negative test: create session with negative opening_cash (expect 422)
        invalid_payload = {"opening_cash": -50.0, "terminal_id": terminal_id}
        resp_neg = requests.post(
            BASE_URL + POS_SESSIONS_ENDPOINT,
            headers=headers,
            json=invalid_payload,
            timeout=TIMEOUT
        )
        assert resp_neg.status_code == 422, f"Expected 422 for negative opening_cash, got {resp_neg.status_code}"
    finally:
        if created_session_id:
            # Cleanup: delete the created session
            delete_url = f"{BASE_URL}/api/pos/sessions/{created_session_id}"
            try:
                resp_del = requests.delete(delete_url, headers=headers, timeout=TIMEOUT)
                # Accept 200 or 204 as successful delete response
                assert resp_del.status_code in (200, 204), f"Failed to delete session ID {created_session_id}"
            except requests.RequestException as ex:
                print(f"Warning: Exception during cleanup delete: {ex}")

test_pos_session_create_api()