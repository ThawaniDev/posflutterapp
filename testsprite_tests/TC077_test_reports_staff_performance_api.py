import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
REPORTS_ENDPOINT = "/api/reports/staff-performance"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_reports_staff_performance_api():
    session = requests.Session()
    try:
        # Authenticate and get token
        login_payload = {"email": EMAIL, "password": PASSWORD}
        login_resp = session.post(
            BASE_URL + LOGIN_ENDPOINT, json=login_payload, timeout=TIMEOUT
        )
        assert login_resp.status_code == 200, f"Login failed: {login_resp.text}"
        login_data = login_resp.json()
        assert "token" in login_data, "No token in login response"
        token = login_data["token"]

        headers = {"Authorization": f"Bearer {token}"}

        # Call GET /api/reports/staff-performance
        resp = session.get(BASE_URL + REPORTS_ENDPOINT, headers=headers, timeout=TIMEOUT)
        assert resp.status_code == 200, f"Unexpected status code: {resp.status_code}"
        data = resp.json()
        assert isinstance(data, list) or isinstance(data, dict), "Response is not JSON object or list"

        # Validate that each item (if list) or the dict contains expected keys
        # According to description: per-staff sales count, revenue, and avg transaction value.
        # Since schema not given explicitly, validate keys presence

        items = data if isinstance(data, list) else [data]

        assert len(items) > 0, "No staff performance data found"

        for entry in items:
            assert isinstance(entry, dict), "Entry is not a dict"
            # Check keys related to staff performance report
            # Common keys might be: staff_id/staff_name, sales_count, revenue, avg_transaction_value
            # We'll assert at least sales_count, revenue and avg_transaction_value keys exist
            assert "sales_count" in entry or "salesCount" in entry, "Missing sales_count in entry"
            assert "revenue" in entry or "total_revenue" in entry or "revenue_total" in entry, "Missing revenue in entry"
            assert (
                "avg_transaction_value" in entry
                or "average_transaction_value" in entry
                or "avgTransactionValue" in entry
            ), "Missing avg_transaction_value in entry"

    except requests.RequestException as e:
        assert False, f"Request failed: {e}"


test_reports_staff_performance_api()