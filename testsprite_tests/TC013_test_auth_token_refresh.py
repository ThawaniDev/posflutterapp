import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
REFRESH_ENDPOINT = "/api/auth/refresh"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_auth_token_refresh():
    # Login to get initial token
    login_url = BASE_URL + LOGIN_ENDPOINT
    login_payload = {"email": EMAIL, "password": PASSWORD}
    try:
        login_response = requests.post(login_url, json=login_payload, timeout=TIMEOUT)
        assert login_response.status_code == 200, f"Login failed with status {login_response.status_code}"
        login_data = login_response.json()
        # Expect token in format { "token": "Bearer xyz" } or { "access_token": "xyz" }
        # Try to extract Bearer token string
        token = None
        if "token" in login_data:
            token_str = login_data["token"]
            if token_str.lower().startswith("bearer "):
                token = token_str[7:].strip()
            else:
                token = token_str.strip()
        elif "access_token" in login_data:
            token = login_data["access_token"].strip()
        else:
            # Try common variant
            token = login_data.get("accessToken") or login_data.get("access_token") or None
        assert token is not None and len(token) > 10, "No valid token found in login response"

        # Use the token to request a refresh
        refresh_url = BASE_URL + REFRESH_ENDPOINT
        headers = {"Authorization": f"Bearer {token}"}
        refresh_response = requests.post(refresh_url, headers=headers, timeout=TIMEOUT)
        assert refresh_response.status_code == 200, f"Token refresh failed with status {refresh_response.status_code}"

        refresh_data = refresh_response.json()
        new_token = None
        if "token" in refresh_data:
            token_str = refresh_data["token"]
            if token_str.lower().startswith("bearer "):
                new_token = token_str[7:].strip()
            else:
                new_token = token_str.strip()
        elif "access_token" in refresh_data:
            new_token = refresh_data["access_token"].strip()
        else:
            new_token = refresh_data.get("accessToken") or refresh_data.get("access_token") or None
        assert new_token is not None and len(new_token) > 10, "No valid token found in refresh response"

        # Check that new token is different from old token (usually)
        assert new_token != token, "Refreshed token should differ from original token"

        # Optionally, test the new token by calling a protected endpoint (like /api/auth/me)
        me_url = BASE_URL + "/api/auth/me"
        me_headers = {"Authorization": f"Bearer {new_token}"}
        me_response = requests.get(me_url, headers=me_headers, timeout=TIMEOUT)
        assert me_response.status_code == 200, "New token is not valid for authenticated endpoint"

    except requests.RequestException as e:
        assert False, f"Request failed: {e}"


test_auth_token_refresh()