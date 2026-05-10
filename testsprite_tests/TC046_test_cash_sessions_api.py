import requests
import uuid

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
CASH_SESSIONS_ENDPOINT = "/api/cash-sessions"
TIMEOUT = 30

EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"


def authenticate():
    url = BASE_URL + LOGIN_ENDPOINT
    body = {"email": EMAIL, "password": PASSWORD}
    try:
        resp = requests.post(url, json=body, timeout=TIMEOUT)
        resp.raise_for_status()
        data = resp.json()
        token = data.get("token") or data.get("access_token")
        if not token:
            raise Exception("Authentication token not found in login response")
        return token
    except Exception as e:
        raise Exception(f"Authentication failed: {e}")


def create_cash_session(token):
    url = BASE_URL + CASH_SESSIONS_ENDPOINT
    headers = {"Authorization": f"Bearer {token}"}
    # Payload with unique opening_cash and denominations
    body = {
        "opening_cash": 100.00,
        "denominations": [
            {"denomination": 50, "count": 1},
            {"denomination": 20, "count": 2},
            {"denomination": 10, "count": 1}
        ]
    }
    try:
        resp = requests.post(url, json=body, headers=headers, timeout=TIMEOUT)
        resp.raise_for_status()
        data = resp.json()
        session_id = data.get("id")
        if not session_id:
            raise Exception("Created cash session missing 'id'")
        return session_id
    except Exception as e:
        raise Exception(f"Failed to create cash session: {e}")


def delete_cash_session(token, session_id):
    # Assuming DELETE endpoint /api/cash-sessions/:id exists to clean up. If not, ignore.
    # PRD does not specify DELETE for cash sessions, so skip delete to not fail
    # Alternatively, do nothing to keep session for the system.
    pass


def test_cash_sessions_api():
    token = authenticate()
    headers = {"Authorization": f"Bearer {token}"}

    # 1. Verify GET /api/cash-sessions returns a list
    url_get_sessions = BASE_URL + CASH_SESSIONS_ENDPOINT
    resp_get = requests.get(url_get_sessions, headers=headers, timeout=TIMEOUT)
    assert resp_get.status_code == 200, f"GET /api/cash-sessions failed with status {resp_get.status_code}"
    sessions_list = resp_get.json()
    assert isinstance(sessions_list, list), "GET /api/cash-sessions response is not a list"

    # 2. Create a new cash session (for testing close)
    session_id = None
    try:
        session_id = create_cash_session(token)

        # 3. Close this session via POST /api/cash-sessions/{id}/close
        url_close = f"{BASE_URL}/api/cash-sessions/{session_id}/close"
        # Provide closing_cash to close session (assumed required)
        close_body = {"closing_cash": 100.00}
        resp_close = requests.patch(url_close, json=close_body, headers=headers, timeout=TIMEOUT)
        assert resp_close.status_code == 200, f"PATCH /api/cash-sessions/{session_id}/close failed with status {resp_close.status_code}"
        close_response = resp_close.json()
        # Validate presence of expected keys in close response eg. z_report or status
        assert "z_report" in close_response or "status" in close_response or "closed" in close_response, \
            "Close session response missing expected keys"

        # 4. Attempt to close the same session again to trigger 422 for already closed
        resp_close_again = requests.patch(url_close, json=close_body, headers=headers, timeout=TIMEOUT)
        assert resp_close_again.status_code == 422, f"Expected 422 for already closed session, got {resp_close_again.status_code}"

    finally:
        if session_id:
            # No DELETE API specified for cash-sessions, so leaving as is.
            # If delete existed, would delete here.
            pass


test_cash_sessions_api()