import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
CASH_SESSIONS_ENDPOINT = "/api/cash-sessions"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30

def test_open_cash_shift_api():
    token = None
    headers = {}
    session_id = None

    try:
        # Step 1: Authenticate and get bearer token
        login_payload = {
            "email": EMAIL,
            "password": PASSWORD
        }
        login_resp = requests.post(
            BASE_URL + LOGIN_ENDPOINT,
            json=login_payload,
            timeout=TIMEOUT
        )
        assert login_resp.status_code == 200, f"Login failed with status {login_resp.status_code}"
        login_json = login_resp.json()
        token = login_json.get("token") or login_json.get("access_token") or login_json.get("data", {}).get("token")
        assert token is not None, "Bearer token not found in login response"
        headers = {
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json"
        }

        # Step 2: Open new cash session (cash shift)
        # Provide opening_cash and denominations as per API schema. 
        # Using example values:
        open_payload = {
            "opening_cash": 500.0,
            "opening_denominations": [
                {"denomination": 100, "quantity": 2},  # 2 x 100 = 200
                {"denomination": 50, "quantity": 6},   # 6 x 50 = 300
            ]
        }

        open_resp = requests.post(
            BASE_URL + CASH_SESSIONS_ENDPOINT,
            headers=headers,
            json=open_payload,
            timeout=TIMEOUT
        )
        assert open_resp.status_code == 201 or open_resp.status_code == 200, f"Opening cash session failed with status {open_resp.status_code}"
        open_json = open_resp.json()
        # Basic validation of response content: session ID and opening cash matches
        session_id = open_json.get("id") or open_json.get("data", {}).get("id")
        assert session_id is not None, "Created cash session ID not found in response"
        response_opening_cash = open_json.get("opening_cash") or open_json.get("data", {}).get("opening_cash")
        assert response_opening_cash == open_payload["opening_cash"], f"Opening cash mismatch: expected {open_payload['opening_cash']}, got {response_opening_cash}"

        response_denominations = open_json.get("opening_denominations") or open_json.get("data", {}).get("opening_denominations")
        assert response_denominations is not None and isinstance(response_denominations, list), "Opening denominations missing or wrong type in response"
        # Check denominations data roughly matches the request (could be partial or reordered)
        denom_set_req = {(d["denomination"], d["quantity"]) for d in open_payload["opening_denominations"]}
        denom_set_resp = {(d.get("denomination"), d.get("quantity")) for d in response_denominations}
        assert denom_set_req.issubset(denom_set_resp), "Response denominations do not include all requested denominations"

    finally:
        # Cleanup: Close or delete the opened cash session if applicable
        if token and session_id:
            # Attempt to close the session gracefully (if API allows)
            close_endpoint = f"{CASH_SESSIONS_ENDPOINT}/{session_id}/close"
            try:
                close_resp = requests.patch(
                    BASE_URL + close_endpoint,
                    headers=headers,
                    json={"closing_cash": open_payload["opening_cash"]},
                    timeout=TIMEOUT
                )
                # If 200/204 or 422 if already closed, accept as cleanup.
                assert close_resp.status_code in (200, 204, 422) or close_resp.status_code == 404
            except Exception:
                # Ignore cleanup exceptions
                pass

test_open_cash_shift_api()