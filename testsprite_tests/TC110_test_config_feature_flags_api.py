import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
FEATURE_FLAGS_ENDPOINT = "/api/config/feature-flags"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_config_feature_flags_api():
    # Step 1: Authenticate to get token
    login_url = f"{BASE_URL}{LOGIN_ENDPOINT}"
    login_payload = {"email": EMAIL, "password": PASSWORD}
    try:
        login_resp = requests.post(login_url, json=login_payload, timeout=TIMEOUT)
        assert login_resp.status_code == 200, f"Login failed, status code: {login_resp.status_code}"
        login_data = login_resp.json()
        assert "token" in login_data or "access_token" in login_data, "Token missing in login response"
        token = login_data.get("token") or login_data.get("access_token")
        assert isinstance(token, str) and token != "", "Invalid token value"
    except (requests.RequestException, AssertionError) as e:
        raise AssertionError(f"Authentication failed: {e}")

    headers_auth = {
        "Authorization": f"Bearer {token}"
    }

    # Step 2: GET /api/config/feature-flags with valid token
    feature_flags_url = f"{BASE_URL}{FEATURE_FLAGS_ENDPOINT}"
    try:
        resp = requests.get(feature_flags_url, headers=headers_auth, timeout=TIMEOUT)
        assert resp.status_code == 200, f"Expected 200 OK with auth, got {resp.status_code}"
        resp_json = resp.json()
        assert isinstance(resp_json, dict), "Response is not a JSON object"
        # Optionally: Check that keys and values represent flag map - keys are strings and values are bool or compatible
        for key, value in resp_json.items():
            assert isinstance(key, str), "Feature flag key is not a string"
        # Values can be bool or other types, so no strict assertion here
    except (requests.RequestException, AssertionError) as e:
        raise AssertionError(f"Authenticated request to feature flags failed: {e}")

    # Step 3: GET /api/config/feature-flags without token should return 401
    try:
        resp_unauth = requests.get(feature_flags_url, timeout=TIMEOUT)
        assert resp_unauth.status_code == 401, f"Expected 401 Unauthorized without auth, got {resp_unauth.status_code}"
    except (requests.RequestException, AssertionError) as e:
        raise AssertionError(f"Unauthorized access test failed: {e}")


test_config_feature_flags_api()