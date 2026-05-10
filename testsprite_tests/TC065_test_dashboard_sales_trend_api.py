import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
SALES_TREND_ENDPOINT = "/api/owner-dashboard/sales-trend"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_dashboard_sales_trend_api():
    # Authenticate and get Bearer token
    auth_payload = {
        "email": EMAIL,
        "password": PASSWORD
    }
    try:
        auth_response = requests.post(
            BASE_URL + LOGIN_ENDPOINT,
            json=auth_payload,
            timeout=TIMEOUT
        )
        auth_response.raise_for_status()
    except requests.RequestException as e:
        raise AssertionError(f"Authentication failed: {e}")
    auth_data = auth_response.json()
    token = auth_data.get("token")
    if not token:
        raise AssertionError("No token found in authentication response")

    headers = {
        "Authorization": f"Bearer {token}"
    }

    # Test period=weekly returns 7-point data array
    try:
        weekly_response = requests.get(
            f"{BASE_URL}{SALES_TREND_ENDPOINT}?period=weekly",
            headers=headers,
            timeout=TIMEOUT
        )
        weekly_response.raise_for_status()
    except requests.RequestException as e:
        raise AssertionError(f"Failed to fetch weekly sales trend: {e}")

    weekly_data = weekly_response.json()
    if not isinstance(weekly_data, list):
        raise AssertionError(f"Expected list for weekly data, got {type(weekly_data)}")
    assert len(weekly_data) == 7, f"Expected 7 data points for weekly period, got {len(weekly_data)}"

    # Test period=monthly returns 30-point data array
    try:
        monthly_response = requests.get(
            f"{BASE_URL}{SALES_TREND_ENDPOINT}?period=monthly",
            headers=headers,
            timeout=TIMEOUT
        )
        monthly_response.raise_for_status()
    except requests.RequestException as e:
        raise AssertionError(f"Failed to fetch monthly sales trend: {e}")

    monthly_data = monthly_response.json()
    if not isinstance(monthly_data, list):
        raise AssertionError(f"Expected list for monthly data, got {type(monthly_data)}")
    assert len(monthly_data) == 30, f"Expected 30 data points for monthly period, got {len(monthly_data)}"


test_dashboard_sales_trend_api()