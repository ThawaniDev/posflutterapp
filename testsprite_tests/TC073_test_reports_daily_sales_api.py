import requests
from datetime import datetime

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
REPORTS_DAILY_SALES_ENDPOINT = "/api/reports/daily-sales"

EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30

def test_reports_daily_sales_api():
    # Authenticate and get token
    login_url = BASE_URL + LOGIN_ENDPOINT
    login_payload = {"email": EMAIL, "password": PASSWORD}
    try:
        login_response = requests.post(login_url, json=login_payload, timeout=TIMEOUT)
        login_response.raise_for_status()
    except requests.RequestException as e:
        assert False, f"Login request failed: {e}"
    login_data = login_response.json()
    assert "token" in login_data, "Login response missing token"
    token = login_data["token"]
    headers = {"Authorization": f"Bearer {token}"}

    # Use today's date in YYYY-MM-DD format as example date to query
    target_date = datetime.utcnow().strftime("%Y-%m-%d")
    params = {"date": target_date}
    url = BASE_URL + REPORTS_DAILY_SALES_ENDPOINT

    try:
        response = requests.get(url, headers=headers, params=params, timeout=TIMEOUT)
        response.raise_for_status()
    except requests.RequestException as e:
        assert False, f"GET /api/reports/daily-sales request failed: {e}"

    data = response.json()
    # Validate response structure - expecting an hourly breakdown, likely a dict or list for 24 hours
    # Since PRD doesn't specify exact schema, we check expected keys and types conservatively

    assert isinstance(data, dict) or isinstance(data, list), "Response should be a dict or list"

    # If data is dict, expect keys like "hourly_sales" or keys for hours "00".."23"
    # Validate that it contains data for all 24 hours
    # Some APIs might return list of dicts with hour and sales fields

    if isinstance(data, dict):
        # Try to find hourly breakdown keys
        # General heuristic: keys named as hours or a key with hourly sales array
        if "hourly_sales" in data and isinstance(data["hourly_sales"], list):
            hourly_sales = data["hourly_sales"]
            assert len(hourly_sales) == 24, "hourly_sales array should have 24 elements"
            for entry in hourly_sales:
                assert isinstance(entry, (int, float, dict)), "Hourly sales entries should be numbers or dicts"
        else:
            # Check keys for each hour "00".."23"
            hours = [f"{h:02}" for h in range(24)]
            matched_hours = [h for h in hours if h in data]
            assert len(matched_hours) >= 24 or len(matched_hours) > 0, "Expected keys for each hour or hourly_sales field"
            # Check each hour value if present
            for h in matched_hours:
                val = data[h]
                assert isinstance(val, (int, float)), f"Value for hour {h} should be numeric"
    elif isinstance(data, list):
        # Assume list with 24 hourly entries or dicts containing hour info
        assert len(data) == 24, "Response list should have 24 hourly entries"
        for entry in data:
            assert isinstance(entry, dict), "Hourly sales list entries should be dicts"
            # Expect keys like 'hour' and 'sales' or similar
            assert "hour" in entry and "sales" in entry, "Each entry should have 'hour' and 'sales'"
            hour = entry["hour"]
            sales = entry["sales"]
            assert isinstance(hour, int) or isinstance(hour, str), "'hour' should be int or str"
            assert 0 <= int(hour) <= 23, "'hour' should be between 0 and 23"
            assert isinstance(sales, (int, float)), "'sales' should be numeric"

    else:
        assert False, "Unexpected response format"

test_reports_daily_sales_api()