import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
PROTECTED_ENDPOINT = "/api/reports/sales-summary"  # Changed to a valid protected endpoint

def test_auth_security_invalid_token():
    invalid_token = "invalidtoken123"
    url = f"{BASE_URL}{PROTECTED_ENDPOINT}"
    headers = {
        "Authorization": f"Bearer {invalid_token}",
        "Accept": "application/json"
    }
    try:
        response = requests.get(url, headers=headers, timeout=30)
        # The test expects 401 Unauthorized and NOT 500 Internal Server Error
        assert response.status_code == 401, f"Expected status code 401, got {response.status_code}"
    except requests.RequestException as e:
        assert False, f"Request failed: {e}"

test_auth_security_invalid_token()