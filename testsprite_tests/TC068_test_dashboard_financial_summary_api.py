import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
FINANCIAL_SUMMARY_ENDPOINT = "/api/finance/daily-summary"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_dashboard_financial_summary_api():
    session = requests.Session()
    try:
        # Authenticate and get bearer token
        login_payload = {
            "email": EMAIL,
            "password": PASSWORD
        }
        login_response = session.post(
            BASE_URL + LOGIN_ENDPOINT,
            json=login_payload,
            timeout=TIMEOUT
        )
        assert login_response.status_code == 200, f"Login failed: {login_response.text}"
        login_data = login_response.json()
        token = login_data.get("token") or login_data.get("access_token")
        assert token, "Token not found in login response"

        headers = {
            "Authorization": f"Bearer {token}"
        }

        # Call financial summary API
        response = session.get(
            BASE_URL + FINANCIAL_SUMMARY_ENDPOINT,
            headers=headers,
            timeout=TIMEOUT
        )
        assert response.status_code == 200, f"Financial summary API failed: {response.text}"
        data = response.json()

        # Check that revenue, expenses, and net_profit fields exist and are of numeric type
        assert "revenue" in data, "'revenue' field missing in response"
        assert "expenses" in data, "'expenses' field missing in response"
        assert "net_profit" in data, "'net_profit' field missing in response"
        assert isinstance(data["revenue"], (int, float)), "'revenue' is not numeric"
        assert isinstance(data["expenses"], (int, float)), "'expenses' is not numeric"
        assert isinstance(data["net_profit"], (int, float)), "'net_profit' is not numeric"

    finally:
        session.close()


test_dashboard_financial_summary_api()
