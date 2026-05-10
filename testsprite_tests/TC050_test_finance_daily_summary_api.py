import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
DAILY_SUMMARY_ENDPOINT = "/api/finance/daily-summary"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_finance_daily_summary_api():
    # Authenticate and get token
    login_url = BASE_URL + LOGIN_ENDPOINT
    login_payload = {"email": EMAIL, "password": PASSWORD}
    try:
        login_resp = requests.post(login_url, json=login_payload, timeout=TIMEOUT)
        login_resp.raise_for_status()
    except requests.RequestException as e:
        assert False, f"Login request failed: {e}"

    token = None
    try:
        token = login_resp.json().get("token")
    except Exception:
        assert False, "Failed to parse login response JSON or token missing"

    assert token and isinstance(token, str), "Authentication token is missing or invalid"

    headers = {"Authorization": f"Bearer {token}"}
    daily_summary_url = BASE_URL + DAILY_SUMMARY_ENDPOINT

    try:
        response = requests.get(daily_summary_url, headers=headers, timeout=TIMEOUT)
        response.raise_for_status()
    except requests.HTTPError as e:
        assert False, f"GET {DAILY_SUMMARY_ENDPOINT} returned HTTP error: {e}"
    except requests.RequestException as e:
        assert False, f"GET {DAILY_SUMMARY_ENDPOINT} request failed: {e}"

    try:
        data = response.json()
    except Exception:
        assert False, "Response is not valid JSON"

    # Assert required fields exist and are numbers (int or float)
    for field in ["total_sales", "total_expenses", "net_profit"]:
        assert field in data, f"Response JSON missing '{field}' field"
        value = data[field]
        assert isinstance(value, (int, float)), f"Field '{field}' is not numeric (got {type(value)})"

    print("test_finance_daily_summary_api passed.")


test_finance_daily_summary_api()