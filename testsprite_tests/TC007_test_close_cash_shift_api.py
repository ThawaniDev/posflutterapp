import requests
import uuid

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
CASH_SESSIONS_ENDPOINT = "/api/cash-sessions"
TIMEOUT = 30

EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"

def test_close_cash_shift_api():
    session = requests.Session()
    try:
        # Authenticate and get token
        login_resp = session.post(
            BASE_URL + LOGIN_ENDPOINT,
            json={"email": EMAIL, "password": PASSWORD},
            timeout=TIMEOUT,
        )
        assert login_resp.status_code == 200, f"Login failed: {login_resp.text}"
        token = login_resp.json().get("token") or login_resp.json().get("access_token")
        assert token, "Authentication token missing in login response"

        headers = {
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json",
        }

        # Create a new active cash session (open shift) to close later
        # Minimal opening_cash and denominations to simulate open shift
        opening_cash = 100.00
        # Example denominations format (if required), adjust as needed
        opening_denominations = [{"denomination": 50, "count": 1}, {"denomination": 20, "count": 2}, {"denomination": 10, "count": 1}]

        open_shift_payload = {
            "opening_cash": opening_cash,
            "opening_cash_denominations": opening_denominations,
        }
        open_resp = session.post(
            BASE_URL + CASH_SESSIONS_ENDPOINT,
            json=open_shift_payload,
            headers=headers,
            timeout=TIMEOUT,
        )
        assert open_resp.status_code == 201, f"Open shift failed: {open_resp.text}"
        shift = open_resp.json()
        shift_id = shift.get("id")
        assert shift_id, "Opened shift ID missing in response"

        # Now close the active cash shift with a closing cash count
        closing_cash = 120.00
        # Example denominations for closing (must match expected API schema if needed)
        closing_denominations = [{"denomination": 50, "count": 2}, {"denomination": 10, "count": 2}]

        close_payload = {
            "closing_cash": closing_cash,
            "closing_cash_denominations": closing_denominations,
        }
        close_resp = session.patch(
            f"{BASE_URL}{CASH_SESSIONS_ENDPOINT}/{shift_id}/close",
            json=close_payload,
            headers=headers,
            timeout=TIMEOUT,
        )

        assert close_resp.status_code == 200, f"Close shift failed: {close_resp.text}"

        close_data = close_resp.json()
        # Validate the shift is closed (status/closed flag)
        assert close_data.get("status") in ("closed", "CLOSED"), "Shift status not updated to closed"

        # Validate closing cash count is recorded correctly
        assert abs(close_data.get("closing_cash", 0) - closing_cash) < 0.01, "Closing cash amount mismatch"

        # Validate Z-report presence with expected keys: totals, discrepancies
        z_report = close_data.get("z_report")
        assert z_report, "Z-report missing in close response"
        assert "totals" in z_report, "Z-report totals missing"
        assert "discrepancies" in z_report, "Z-report discrepancies missing"

    finally:
        # Cleanup: Delete the cash session if still exists to keep environment clean
        # Some systems may not allow deleting closed sessions, ignore 404/405 errors
        if 'shift_id' in locals():
            try:
                del_resp = session.delete(
                    f"{BASE_URL}{CASH_SESSIONS_ENDPOINT}/{shift_id}",
                    headers=headers,
                    timeout=TIMEOUT,
                )
                # Accept 200, 204, 404, or 405 as valid cleanup responses
                assert del_resp.status_code in (200, 204, 404, 405), f"Cleanup delete failed: {del_resp.text}"
            except Exception:
                pass

test_close_cash_shift_api()