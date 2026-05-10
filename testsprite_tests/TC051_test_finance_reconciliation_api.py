import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
RECONCILIATION_ENDPOINT = "/api/finance/reconciliation"
EMAIL = "owner@ostora.sa"
PASSWORD = "correct_password"
TIMEOUT = 30

def test_finance_reconciliation_api():
    # Authenticate and get token
    login_payload = {
        "email": EMAIL,
        "password": PASSWORD
    }
    try:
        login_resp = requests.post(
            BASE_URL + LOGIN_ENDPOINT, json=login_payload, timeout=TIMEOUT
        )
        assert login_resp.status_code == 200, f"Login failed: {login_resp.text}"
        login_data = login_resp.json()
        token = login_data.get("token") or login_data.get("access_token")
        assert token, "Bearer token not found in login response"
    except requests.RequestException as e:
        assert False, f"Login request exception: {str(e)}"

    headers = {
        "Authorization": f"Bearer {token}"
    }

    # Call GET /api/finance/reconciliation
    try:
        resp = requests.get(
            BASE_URL + RECONCILIATION_ENDPOINT, headers=headers, timeout=TIMEOUT
        )
    except requests.RequestException as e:
        assert False, f"Reconciliation request exception: {str(e)}"

    assert resp.status_code == 200, f"Unexpected status code: {resp.status_code}"

    try:
        data = resp.json()
    except ValueError:
        assert False, "Response is not valid JSON"

    assert isinstance(data, list), "Expected a list of reconciliation records"

    # Validate each record has expected_cash and actual_cash fields
    for record in data:
        assert isinstance(record, dict), "Each reconciliation record should be a dict"
        assert "expected_cash" in record, "expected_cash field missing in record"
        assert "actual_cash" in record, "actual_cash field missing in record"

        # Optional: Validate that fields are numeric (int or float)
        expected_cash = record["expected_cash"]
        actual_cash = record["actual_cash"]
        assert isinstance(expected_cash, (int, float)), "expected_cash is not numeric"
        assert isinstance(actual_cash, (int, float)), "actual_cash is not numeric"

test_finance_reconciliation_api()
