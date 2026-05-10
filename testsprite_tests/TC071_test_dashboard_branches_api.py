import requests
from datetime import datetime

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
BRANCHES_ENDPOINT = "/api/owner-dashboard/branches"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_dashboard_branches_api():
    # Authenticate to get bearer token
    login_url = BASE_URL + LOGIN_ENDPOINT
    login_payload = {"email": EMAIL, "password": PASSWORD}
    try:
        login_response = requests.post(login_url, json=login_payload, timeout=TIMEOUT)
        login_response.raise_for_status()
    except requests.RequestException as e:
        assert False, f"Login request failed: {e}"

    token = None
    try:
        token = login_response.json().get("token") or login_response.json().get("access_token")
    except Exception as e:
        assert False, f"Failed to parse login response JSON: {e}"
    assert token, "Authentication token not found in login response"

    headers = {"Authorization": f"Bearer {token}"}
    branches_url = BASE_URL + BRANCHES_ENDPOINT

    try:
        response = requests.get(branches_url, headers=headers, timeout=TIMEOUT)
        response.raise_for_status()
    except requests.RequestException as e:
        assert False, f"GET {BRANCHES_ENDPOINT} request failed: {e}"

    try:
        data = response.json()
    except Exception as e:
        assert False, f"Failed to parse branches response JSON: {e}"

    assert isinstance(data, list), "Response JSON is not a list"

    today_str = datetime.utcnow().date().isoformat()

    for branch in data:
        # Each branch should be a dict with keys including today's sales and orders counts
        assert isinstance(branch, dict), "Branch entry is not a dictionary"
        # Check for keys that likely represent sales and orders count
        # Assumptions based on the description:
        # Fields could be 'sales_today', 'orders_today', 'total_sales', 'order_count', or similar
        keys_lower = [k.lower() for k in branch.keys()]
        has_sales = any('sale' in k for k in keys_lower)
        has_orders = any('order' in k for k in keys_lower)
        assert has_sales, f"Branch entry missing sales data: {branch}"
        assert has_orders, f"Branch entry missing order count data: {branch}"

        # Optionally, sales and order count values should be numbers (int or float)
        # Find sales keys and validate values
        sales_keys = [k for k in branch if 'sale' in k.lower()]
        for key in sales_keys:
            val = branch.get(key)
            assert isinstance(val, (int, float)), f"Sales value for key '{key}' is not numeric: {val}"

        orders_keys = [k for k in branch if 'order' in k.lower()]
        for key in orders_keys:
            val = branch.get(key)
            assert isinstance(val, int), f"Order count value for key '{key}' is not int: {val}"

    # If no branches returned, warn but not necessarily fail
    assert len(data) > 0, "Branches list is empty"

test_dashboard_branches_api()