import requests

BASE_URL = "http://localhost:8080"
LOGIN_URL = f"{BASE_URL}/api/auth/login"
PAYMENT_METHODS_URL = f"{BASE_URL}/api/reports/payment-methods"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_reports_payment_methods_api():
    # Authenticate and get token
    login_payload = {
        "email": EMAIL,
        "password": PASSWORD
    }
    try:
        login_resp = requests.post(LOGIN_URL, json=login_payload, timeout=TIMEOUT)
        assert login_resp.status_code == 200, f"Login failed with status {login_resp.status_code}"
        token = login_resp.json().get("token")
        assert token, "Login response missing token"
    except requests.RequestException as e:
        assert False, f"Login request failed: {e}"

    headers = {
        "Authorization": f"Bearer {token}"
    }

    try:
        resp = requests.get(PAYMENT_METHODS_URL, headers=headers, timeout=TIMEOUT)
        assert resp.status_code == 200, f"Expected status 200, got {resp.status_code}"
        data = resp.json()
    except requests.RequestException as e:
        assert False, f"GET request to payment-methods failed: {e}"
    except ValueError:
        assert False, "Response content is not valid JSON"

    # Validate response structure and content
    # Expected keys: cash, card, other, totals (or similar) - as breakdown and totals
    required_keys = {"cash", "card", "other", "total"}
    data_keys = set(data.keys())
    missing_keys = required_keys - data_keys
    assert not missing_keys, f"Response missing keys: {missing_keys}"

    # Validate values are numbers and totals make sense
    for key in required_keys:
        value = data.get(key)
        assert isinstance(value, (int, float)), f"Value for '{key}' is not a number: {value}"

    # Check total is approx sum of payment method breakdowns (allow small float rounding)
    sum_methods = data.get("cash", 0) + data.get("card", 0) + data.get("other", 0)
    total = data.get("total", 0)
    assert abs(sum_methods - total) < 0.01, f"Total {total} does not match sum of methods {sum_methods}"


test_reports_payment_methods_api()