import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
SUBSCRIPTION_CURRENT_ENDPOINT = "/api/subscription/current"

EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30

def test_subscription_current_api():
    # Authenticate and get token
    login_url = BASE_URL + LOGIN_ENDPOINT
    login_payload = {
        "email": EMAIL,
        "password": PASSWORD
    }
    try:
        login_resp = requests.post(login_url, json=login_payload, timeout=TIMEOUT)
        login_resp.raise_for_status()
    except requests.RequestException as e:
        assert False, f"Login request failed: {e}"
    login_data = login_resp.json()
    token = login_data.get("token")
    assert token, "Authentication token not found in login response"

    headers = {
        "Authorization": f"Bearer {token}"
    }

    # Call subscription current endpoint
    subscription_url = BASE_URL + SUBSCRIPTION_CURRENT_ENDPOINT
    try:
        resp = requests.get(subscription_url, headers=headers, timeout=TIMEOUT)
        resp.raise_for_status()
    except requests.RequestException as e:
        assert False, f"GET {SUBSCRIPTION_CURRENT_ENDPOINT} request failed: {e}"

    data = resp.json()
    # Check if required fields are present and properly typed
    assert isinstance(data, dict), "Response is not a JSON object"
    assert "plan_name" in data or "name" in data, "Plan name field missing in response"
    # Map plan_name or name keys (common alternatives)
    plan_key = "plan_name" if "plan_name" in data else "name"
    assert isinstance(data.get(plan_key), str) and data.get(plan_key).strip() != "", "Plan name is empty or not a string"
    assert "status" in data, "Status field missing in response"
    assert data.get("status") in ("active", "inactive", "pending", "cancelled") or isinstance(data.get("status"), str), \
        "Status field is invalid or empty"
    assert "renewal_date" in data, "Renewal date field missing in response"
    renewal_date = data.get("renewal_date")
    assert isinstance(renewal_date, str) and len(renewal_date) > 0, "Renewal date is empty or not a string"

test_subscription_current_api()