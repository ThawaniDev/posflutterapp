import requests

BASE_URL = "http://localhost:8080"

def test_auth_security_no_token():
    url = f"{BASE_URL}/api/products"
    try:
        # Make GET request without Authorization header
        response = requests.get(url, timeout=30)
    except requests.exceptions.RequestException as e:
        assert False, f"Request failed: {e}"

    # Assert that the response status code is 401 Unauthorized
    assert response.status_code == 401, f"Expected 401 Unauthorized, got {response.status_code}"

test_auth_security_no_token()
