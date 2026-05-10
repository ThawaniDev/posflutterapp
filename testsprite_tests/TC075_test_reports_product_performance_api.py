import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
REPORT_ENDPOINT = "/api/reports/sales-summary"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30

def test_reports_product_performance_api():
    try:
        # Authenticate to get token
        auth_resp = requests.post(
            f"{BASE_URL}{LOGIN_ENDPOINT}",
            json={"email": EMAIL, "password": PASSWORD},
            timeout=TIMEOUT
        )
        assert auth_resp.status_code == 200, f"Auth failed with status {auth_resp.status_code}"
        auth_json = auth_resp.json()
        token = auth_json.get("token") or auth_json.get("access_token") or auth_json.get("data", {}).get("token")
        assert token, "Authentication token not found in response"

        headers = {
            "Authorization": f"Bearer {token}"
        }

        # Call the reports sales-summary API
        resp = requests.get(f"{BASE_URL}{REPORT_ENDPOINT}", headers=headers, timeout=TIMEOUT)
        assert resp.status_code == 200, f"Report API returned status {resp.status_code}"

        data = resp.json()
        assert isinstance(data, dict), "Response should be a JSON object"

        # Check that some expected keys exist for sales summary report
        expected_keys = ["totalSales", "totalTransactions", "period"]
        found_key = any(key in data for key in expected_keys)
        assert found_key, f"Response does not contain expected keys {expected_keys}"

    except requests.RequestException as e:
        assert False, f"Request failed: {e}"


test_reports_product_performance_api()
