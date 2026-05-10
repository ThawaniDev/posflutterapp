import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
AUTH_ME_ENDPOINT = "/api/auth/me"
LOGIN_EMAIL = "owner@ostora.sa"
LOGIN_PASSWORD = "owner@ostora.sa"
TIMEOUT = 30

def test_auth_me_endpoint():
    # Step 1: Login to get valid token
    login_url = BASE_URL + LOGIN_ENDPOINT
    login_payload = {
        "email": LOGIN_EMAIL,
        "password": LOGIN_PASSWORD
    }
    try:
        login_response = requests.post(login_url, json=login_payload, timeout=TIMEOUT)
        assert login_response.status_code == 200, f"Login failed with status {login_response.status_code}"
        login_data = login_response.json()
        token = login_data.get("access_token") or login_data.get("token") or login_data.get("data", {}).get("token")
        # If token is inside nested data field or named differently try to find it
        if token is None:
            # Try common keys if not found
            if isinstance(login_data, dict):
                for key in ['access_token', 'token', 'jwt', 'auth_token']:
                    if key in login_data:
                        token = login_data[key]
                        break
                    if "data" in login_data and key in login_data["data"]:
                        token = login_data["data"][key]
                        break
        assert token is not None, "Token not found in login response"
    except Exception as e:
        raise AssertionError(f"Login request or token extraction failed: {e}")

    auth_me_url = BASE_URL + AUTH_ME_ENDPOINT
    headers = {"Authorization": f"Bearer {token}"}
    
    # Step 2: Verify GET /api/auth/me with valid token returns user profile
    try:
        auth_me_resp = requests.get(auth_me_url, headers=headers, timeout=TIMEOUT)
        assert auth_me_resp.status_code == 200, f"GET /api/auth/me with valid token returned {auth_me_resp.status_code}"
        user_profile = auth_me_resp.json()
        assert isinstance(user_profile, dict), "User profile is not a JSON object"
        # Basic check for user identifying fields (adjust if API returns specific fields)
        user_id_fields = ["id", "user_id", "email", "name", "username"]
        assert any(field in user_profile for field in user_id_fields), "User profile missing expected identification fields"
        # Also optionally check that the email matches login email
        email_found = False
        for key in ['email', 'user_email']:
            if key in user_profile and user_profile[key].lower() == LOGIN_EMAIL.lower():
                email_found = True
                break
        assert email_found, "User profile email does not match login email"
    except Exception as e:
        raise AssertionError(f"GET /api/auth/me with valid token failed: {e}")
    
    # Step 3: Verify GET /api/auth/me with missing Authorization header returns 401
    try:
        no_auth_resp = requests.get(auth_me_url, timeout=TIMEOUT)
        assert no_auth_resp.status_code == 401, f"GET /api/auth/me without token returned {no_auth_resp.status_code} instead of 401"
    except Exception as e:
        raise AssertionError(f"GET /api/auth/me without token request failed: {e}")
    
    # Step 4: Verify GET /api/auth/me with invalid token returns 401
    invalid_headers = {"Authorization": "Bearer invalidtoken123"}
    try:
        invalid_auth_resp = requests.get(auth_me_url, headers=invalid_headers, timeout=TIMEOUT)
        assert invalid_auth_resp.status_code == 401, f"GET /api/auth/me with invalid token returned {invalid_auth_resp.status_code} instead of 401"
    except Exception as e:
        raise AssertionError(f"GET /api/auth/me with invalid token request failed: {e}")

test_auth_me_endpoint()