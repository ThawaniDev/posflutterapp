import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
REPORTS_CATEGORY_BREAKDOWN_ENDPOINT = "/api/reports/category-breakdown"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"

def test_reports_category_breakdown_api():
    try:
        # Authenticate and get token
        login_resp = requests.post(
            BASE_URL + LOGIN_ENDPOINT,
            json={"email": EMAIL, "password": PASSWORD},
            timeout=30
        )
        assert login_resp.status_code == 200, f"Login failed with status {login_resp.status_code}"
        login_data = login_resp.json()
        token = login_data.get("token") or login_data.get("access_token") or login_data.get("data", {}).get("token")
        assert token, "Authentication token not found in login response"

        headers = {
            "Authorization": f"Bearer {token}"
        }

        # Call the category breakdown report endpoint
        resp = requests.get(
            BASE_URL + REPORTS_CATEGORY_BREAKDOWN_ENDPOINT,
            headers=headers,
            timeout=30
        )
        assert resp.status_code == 200, f"Expected 200, got {resp.status_code}"
        data = resp.json()

        # Expected structure: array or dict of categories with sales and percentage fields
        # Check that data is a dict or list and contains expected keys
        assert data is not None, "Response JSON is None"

        # Accept either dict with keys or a list of items with keys
        if isinstance(data, dict):
            categories = data.get("categories") or data.get("data") or data.get("category_breakdown")
            if categories is None:
                # Fallback: treat top-level dict containing categories by keys (str)
                categories = data
        elif isinstance(data, list):
            categories = data
        else:
            raise AssertionError("Unexpected response format: not dict or list")

        assert categories, "No categories found in report data"

        total_percent = 0.0
        for cat in categories:
            # Each category should have key sales and percentage_of_total (names may vary)
            assert isinstance(cat, dict), "Category entry is not a dict"
            sales = cat.get("sales") or cat.get("total_sales") or cat.get("amount")
            percent = cat.get("percentage") or cat.get("percent") or cat.get("percentage_of_total") or cat.get("percentageOfTotal")
            assert sales is not None, f"Category missing 'sales' field: {cat}"
            assert percent is not None, f"Category missing 'percentage' field: {cat}"
            # Sales should be numeric
            assert isinstance(sales, (int, float)), f"Sales value not numeric: {sales}"
            # Percentage should be numeric between 0 and 100
            assert isinstance(percent, (int, float)), f"Percentage value not numeric: {percent}"
            assert 0.0 <= percent <= 100.0, f"Percentage out of range: {percent}"
            total_percent += float(percent)

        # The sum of all percentages should be close to 100 (allow small epsilon)
        assert abs(total_percent - 100.0) < 1.0, f"Total percentage does not sum to ~100: {total_percent}"

    except requests.RequestException as e:
        assert False, f"Request failed: {e}"

test_reports_category_breakdown_api()