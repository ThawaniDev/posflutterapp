import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
LOGOUT_ENDPOINT = "/api/auth/logout"
AUTH_ME_ENDPOINT = "/api/auth/me"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_auth_logout_endpoint():
    # Step 1: Login and get token
    login_payload = {
        "email": EMAIL,
        "password": PASSWORD
    }
    try:
        login_response = requests.post(
            BASE_URL + LOGIN_ENDPOINT,
            json=login_payload,
            timeout=TIMEOUT
        )
        assert login_response.status_code == 200, f"Login failed with status {login_response.status_code}"
        login_json = login_response.json()
        assert "token" in login_json or "access_token" in login_json, "No token found in login response"

        # Extract token with flexibility
        token = login_json.get("token") or login_json.get("access_token")
        assert token and isinstance(token, str), "Token is invalid"

        headers = {
            "Authorization": f"Bearer {token}"
        }

        # Step 2: POST /api/auth/logout to invalidate session token
        logout_response = requests.post(
            BASE_URL + LOGOUT_ENDPOINT,
            headers=headers,
            timeout=TIMEOUT
        )
        assert logout_response.status_code == 200, f"Logout failed with status {logout_response.status_code}"

        # Step 3: Subsequent request with same token should return 401
        auth_me_response = requests.get(
            BASE_URL + AUTH_ME_ENDPOINT,
            headers=headers,
            timeout=TIMEOUT
        )
        assert auth_me_response.status_code == 401, f"Expected 401 after logout but got {auth_me_response.status_code}"

    except requests.RequestException as e:
        assert False, f"Request failed: {e}"


test_auth_logout_endpoint()