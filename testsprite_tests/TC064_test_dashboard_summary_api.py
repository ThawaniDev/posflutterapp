import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
DASHBOARD_SUMMARY_ENDPOINT = "/api/owner-dashboard/summary"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30

def test_dashboard_summary_api():
    # Attempt GET without auth -> expect 401
    response_no_auth = requests.get(f"{BASE_URL}{DASHBOARD_SUMMARY_ENDPOINT}", timeout=TIMEOUT)
    assert response_no_auth.status_code == 401, f"Expected 401 without auth, got {response_no_auth.status_code}"

    # Login to get token
    auth_payload = {"email": EMAIL, "password": PASSWORD}
    login_resp = requests.post(f"{BASE_URL}{LOGIN_ENDPOINT}", json=auth_payload, timeout=TIMEOUT)
    assert login_resp.status_code == 200, f"Login failed with status {login_resp.status_code}"
    login_data = login_resp.json()
    token = login_data.get("token") or login_data.get("accessToken") or login_data.get("access_token")
    assert token and isinstance(token, str), "Token not found in login response"

    headers = {"Authorization": f"Bearer {token}"}

    # GET /api/owner-dashboard/summary with auth
    dash_resp = requests.get(f"{BASE_URL}{DASHBOARD_SUMMARY_ENDPOINT}", headers=headers, timeout=TIMEOUT)
    assert dash_resp.status_code == 200, f"Dashboard summary API failed with status {dash_resp.status_code}"
    dash_data = dash_resp.json()

    # Validate presence of expected keys with appropriate types (numeric)
    for key in ["total_sales", "order_count", "revenue"]:
        assert key in dash_data, f"Key '{key}' missing in dashboard summary response"
        value = dash_data[key]
        assert isinstance(value, (int, float)), f"Key '{key}' should be numeric, got {type(value)}"

test_dashboard_summary_api()