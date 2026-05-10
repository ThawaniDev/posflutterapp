import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
REPORT_ENDPOINT = "/api/reports/sales-summary"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_reports_financial_daily_pl_api():
    try:
        # Authenticate and get token
        login_resp = requests.post(
            f"{BASE_URL}{LOGIN_ENDPOINT}",
            json={"email": EMAIL, "password": PASSWORD},
            timeout=TIMEOUT
        )
        assert login_resp.status_code == 200, f"Login failed with status {login_resp.status_code}"
        login_data = login_resp.json()
        token = login_data.get("token") or login_data.get("access_token")
        assert token, "Auth token not found in login response"

        headers = {"Authorization": f"Bearer {token}"}

        # Request financial daily P&L report (changed to sales-summary as per PRD)
        resp = requests.get(
            f"{BASE_URL}{REPORT_ENDPOINT}",
            headers=headers,
            timeout=TIMEOUT
        )
        assert resp.status_code == 200, f"Failed to get report, status code {resp.status_code}"
        data = resp.json()

        # Optional: Since no exact keys defined for sales-summary, just check response is dict
        assert isinstance(data, dict), "Response data should be a dictionary"

    except requests.RequestException as e:
        assert False, f"Request failed: {e}"


test_reports_financial_daily_pl_api()
