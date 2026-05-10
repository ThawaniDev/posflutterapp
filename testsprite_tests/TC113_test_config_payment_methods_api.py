import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
PAYMENT_METHODS_ENDPOINT = "/api/config/payment-methods"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30

def test_config_payment_methods_api():
    # Login to obtain auth token
    login_url = BASE_URL + LOGIN_ENDPOINT
    login_payload = {"email": EMAIL, "password": PASSWORD}
    try:
        login_response = requests.post(login_url, json=login_payload, timeout=TIMEOUT)
        login_response.raise_for_status()
    except requests.RequestException as e:
        assert False, f"Login request failed: {e}"
    json_login = login_response.json()
    assert "token" in json_login and isinstance(json_login["token"], str) and json_login["token"], "Auth token missing in login response"
    token = json_login["token"]

    # GET /api/config/payment-methods with Authorization header
    url = BASE_URL + PAYMENT_METHODS_ENDPOINT
    headers = {"Authorization": f"Bearer {token}"}

    try:
        response = requests.get(url, headers=headers, timeout=TIMEOUT)
        response.raise_for_status()
    except requests.RequestException as e:
        assert False, f"GET {PAYMENT_METHODS_ENDPOINT} request failed: {e}"

    data = response.json()
    assert isinstance(data, list), f"Expected payment methods list, got {type(data)}"
    assert len(data) > 0, "Payment methods list is empty"

    # Check that some common enabled payment methods exist: cash, card (case-insensitive)
    lower_methods = [str(method).lower() for method in data]
    assert any(pm in lower_methods for pm in ["cash", "card"]), "Expected 'cash' or 'card' payment methods not found in response"

test_config_payment_methods_api()