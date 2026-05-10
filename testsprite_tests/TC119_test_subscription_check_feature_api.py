import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = f"{BASE_URL}/api/auth/login"
CHECK_FEATURE_ENDPOINT = f"{BASE_URL}/api/subscription/check-feature"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30

def test_subscription_check_feature_api():
    # Step 1: Authenticate and get token
    login_payload = {
        "email": EMAIL,
        "password": PASSWORD
    }
    try:
        login_response = requests.post(LOGIN_ENDPOINT, json=login_payload, timeout=TIMEOUT)
        assert login_response.status_code == 200, f"Login failed: {login_response.text}"
        token = login_response.json().get("token")
        assert token and token.startswith("Bearer "), "Token not found or malformed"
        # Remove 'Bearer ' prefix from token if it exists
        token_value = token.split(" ")[1] if " " in token else token

        headers = {
            "Authorization": f"Bearer {token_value}"
        }

        # Step 2: Identify a set of features to test
        # Since no specific features are given, we try some common feature names
        feature_names = [
            "cashiers",           # arbitrary example feature
            "branches",
            "products",
            "nonexistent_feature" # test also a feature that should likely be disallowed
        ]

        for feature_name in feature_names:
            params = {"feature": feature_name}
            resp = requests.get(CHECK_FEATURE_ENDPOINT, headers=headers, params=params, timeout=TIMEOUT)
            assert resp.status_code == 200, f"Failed for feature '{feature_name}': {resp.text}"
            json_resp = resp.json()
            # Validate response contains 'allowed' key with boolean value
            assert "allowed" in json_resp, f"'allowed' key missing in response for feature '{feature_name}'"
            assert isinstance(json_resp["allowed"], bool), f"'allowed' key is not bool for feature '{feature_name}'"

    except (requests.RequestException, AssertionError) as e:
        raise AssertionError(f"Test failed: {e}")

test_subscription_check_feature_api()