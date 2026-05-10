import requests

BASE_URL = "http://localhost:8080"
LOGIN_URL = f"{BASE_URL}/api/auth/login"
HOURLY_SALES_URL = f"{BASE_URL}/api/owner-dashboard/hourly-sales"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_dashboard_hourly_sales_api():
    # Authenticate and get token
    try:
        login_resp = requests.post(
            LOGIN_URL,
            json={"email": EMAIL, "password": PASSWORD},
            timeout=TIMEOUT,
        )
        login_resp.raise_for_status()
    except requests.RequestException as e:
        assert False, f"Authentication request failed: {e}"

    login_data = login_resp.json()
    token = login_data.get("token")
    assert token and isinstance(token, str), "No valid token received from login"

    headers = {"Authorization": f"Bearer {token}"}

    try:
        resp = requests.get(HOURLY_SALES_URL, headers=headers, timeout=TIMEOUT)
        resp.raise_for_status()
    except requests.RequestException as e:
        assert False, f"GET hourly sales API request failed: {e}"

    try:
        data = resp.json()
    except ValueError:
        assert False, "Response is not valid JSON"

    # Expecting a 24-element array
    assert isinstance(data, list), f"Expected list in response, got {type(data)}"
    assert len(data) == 24, f"Expected 24-element array, got {len(data)}"

    # Each element should be a number (int or float, not None)
    for i, val in enumerate(data):
        assert isinstance(val, (int, float)), f"Element at index {i} is not a number: {val}"


test_dashboard_hourly_sales_api()