import requests
from datetime import datetime, timedelta

BASE_URL = "http://localhost:8080"
LOGIN_URL = f"{BASE_URL}/api/auth/login"
SALES_SUMMARY_URL = f"{BASE_URL}/api/reports/sales-summary"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_reports_sales_summary_api():
    # Authenticate and obtain token
    login_payload = {"email": EMAIL, "password": PASSWORD}
    login_response = requests.post(LOGIN_URL, json=login_payload, timeout=TIMEOUT)
    assert login_response.status_code == 200, f"Login failed: {login_response.text}"
    token = login_response.json().get("token") or login_response.json().get("access_token")
    assert token, "No token found in login response"

    headers = {"Authorization": f"Bearer {token}"}

    # Prepare date range (last 7 days)
    today = datetime.utcnow().date()
    to_date = today.strftime("%Y-%m-%d")
    from_date = (today - timedelta(days=7)).strftime("%Y-%m-%d")

    params = {"from_date": from_date, "to_date": to_date}

    response = requests.get(SALES_SUMMARY_URL, headers=headers, params=params, timeout=TIMEOUT)
    assert response.status_code == 200, f"Failed to get sales summary: {response.text}"

    data = response.json()
    # Validate required keys presence and types
    assert isinstance(data, dict), "Response is not a JSON object"
    for key in ["total_sales", "order_count", "avg_order_value"]:
        assert key in data, f"Key '{key}' missing in response"
        # total_sales and avg_order_value should be numbers (int or float), order_count int
        if key == "order_count":
            assert isinstance(data[key], int), f"Expected integer for {key}, got {type(data[key])}"
        else:
            assert isinstance(data[key], (int, float)), f"Expected number for {key}, got {type(data[key])}"
    
    # Additional sanity checks (optional)
    assert data["total_sales"] >= 0, "total_sales should not be negative"
    assert data["order_count"] >= 0, "order_count should not be negative"
    assert data["avg_order_value"] >= 0, "avg_order_value should not be negative"


test_reports_sales_summary_api()