import requests

BASE_URL = "http://localhost:8080"
LOGIN_URL = f"{BASE_URL}/api/auth/login"
REPORTS_CASH_VARIANCE_URL = f"{BASE_URL}/api/reports/financial/cash-variance"

EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_reports_financial_cash_variance_api():
    # Authenticate and get token
    try:
        login_response = requests.post(
            LOGIN_URL,
            json={"email": EMAIL, "password": PASSWORD},
            timeout=TIMEOUT
        )
        assert login_response.status_code == 200, f"Login failed: {login_response.text}"
        login_json = login_response.json()
        token = login_json.get("token") or login_json.get("access_token") or login_json.get("data", {}).get("token")
        assert token, "Bearer token not found in login response"
    except Exception as e:
        assert False, f"Exception during login: {e}"

    headers = {"Authorization": f"Bearer {token}"}

    try:
        response = requests.get(REPORTS_CASH_VARIANCE_URL, headers=headers, timeout=TIMEOUT)
        assert response.status_code == 200, f"Unexpected status code: {response.status_code} Response: {response.text}"

        data = response.json()
        assert isinstance(data, list), f"Response should be a list but got {type(data)}"

        # Each item should contain keys for expected cash, actual cash, and variance.
        for session in data:
            assert isinstance(session, dict), f"Each session should be a dict, got {type(session)}"
            # We expect fields like expected_cash, actual_cash, variance (field names guessed)
            # Check at least that these keys exist and are numbers
            for key in ["expected_cash", "actual_cash", "variance"]:
                assert key in session, f"Key '{key}' missing in session data"
                val = session[key]
                assert isinstance(val, (int, float)), f"Value for '{key}' should be numeric, got {type(val)}"
    except Exception as e:
        assert False, f"Exception during GET cash variance report: {e}"


test_reports_financial_cash_variance_api()