import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
SUBSCRIPTION_USAGE_ENDPOINT = "/api/subscription/usage"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_subscription_usage_api():
    try:
        # Step 1: Authenticate and get token
        login_url = BASE_URL + LOGIN_ENDPOINT
        login_payload = {"email": EMAIL, "password": PASSWORD}
        login_resp = requests.post(login_url, json=login_payload, timeout=TIMEOUT)
        login_resp.raise_for_status()
        token = login_resp.json().get("token") or login_resp.json().get("access_token")
        assert token, "Authentication token not found in login response"

        headers = {"Authorization": f"Bearer {token}"}

        # Step 2: Call the subscription usage endpoint
        usage_url = BASE_URL + SUBSCRIPTION_USAGE_ENDPOINT
        usage_resp = requests.get(usage_url, headers=headers, timeout=TIMEOUT)
        usage_resp.raise_for_status()
        data = usage_resp.json()

        # Step 3: Validate the response structure and values
        assert isinstance(data, dict), "Response JSON is not a dictionary"

        # Expect keys for usage and limits for these categories
        keys = ["products", "staff", "branches", "transactions"]
        for key in keys:
            assert key in data, f"Key '{key}' not found in response"

            usage_info = data[key]
            assert isinstance(usage_info, dict), f"Value for {key} is not a dictionary"

            # Check that 'current' and 'limit' keys exist and are integers >= 0
            for metric in ["current", "limit"]:
                assert metric in usage_info, f"'{metric}' not found under {key}"
                value = usage_info[metric]
                assert isinstance(value, int), f"'{metric}' in {key} is not an integer"
                assert value >= 0, f"'{metric}' in {key} is negative"

    except requests.RequestException as e:
        assert False, f"HTTP request failed: {e}"
    except ValueError as e:
        assert False, f"JSON decoding failed: {e}"


test_subscription_usage_api()