import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = f"{BASE_URL}/api/auth/login"
PIN_LOGIN_ENDPOINT = f"{BASE_URL}/api/auth/login/pin"
AUTH_EMAIL = "owner@ostora.sa"
AUTH_PASSWORD = "owner@ostora.sa"
TIMEOUT = 30

def test_pin_login_api():
    # Step 1: Login with email/password to get Bearer token
    try:
        auth_response = requests.post(
            LOGIN_ENDPOINT,
            json={"email": AUTH_EMAIL, "password": AUTH_PASSWORD},
            timeout=TIMEOUT
        )
        assert auth_response.status_code == 200, f"Auth login failed with status {auth_response.status_code}"
        auth_data = auth_response.json()
        token = auth_data.get("token") or auth_data.get("access_token") or auth_data.get("bearerToken")
        assert token, "Bearer token not found in login response"
    except (requests.RequestException, AssertionError) as e:
        raise AssertionError(f"Failed to authenticate to get bearer token: {e}")

    headers = {"Authorization": f"Bearer {token}", "Content-Type": "application/json"}

    # Test valid PIN login - must succeed
    # The actual valid PIN code is unknown from the PRD.
    # We'll try common PIN format (e.g., "1234") and expect success or failure.
    # Since the test requires verifying valid and invalid, we will try to discover a valid PIN by assuming
    # PIN is linked with authenticated user or we test only with correct PIN format.

    # Because PRD does not specify valid PIN for owner@ostora.sa, we will attempt an invalid PIN and expect error,
    # and then a valid PIN test with a likely common PIN "0000" or "1234" (which likely fails),
    # so we will test the flow with both, expecting one failure and one success (simulate with valid PIN same as password for demo).

    # Here, since no valid PIN is provided, we interpret "valid PIN" as the authenticated user's PIN which ideally matches password or an assumed PIN.
    # To ensure test behavior, test invalid PIN first then test with assumed valid PIN "1234".

    # Test invalid PIN login
    invalid_pin = "9999"
    try:
        invalid_response = requests.post(
            PIN_LOGIN_ENDPOINT,
            json={"pin": invalid_pin},
            timeout=TIMEOUT
        )
        # Expecting failure (HTTP 401 or 400 with error message)
        assert invalid_response.status_code in (400, 401), f"Invalid PIN login unexpectedly succeeded with status {invalid_response.status_code}"
        invalid_json = invalid_response.json()
        # Check there is an error message or field indicating invalid pin
        assert "error" in invalid_json or "message" in invalid_json or invalid_response.status_code == 401, "Expected error message for invalid PIN login"
    except (requests.RequestException, AssertionError) as e:
        raise AssertionError(f"Invalid PIN login test failed: {e}")

    # Test valid PIN login
    valid_pin = "1234"
    try:
        valid_response = requests.post(
            PIN_LOGIN_ENDPOINT,
            json={"pin": valid_pin},
            timeout=TIMEOUT
        )
        # Successful login expected to be 200 with token or user info
        assert valid_response.status_code == 200, f"Valid PIN login failed with status {valid_response.status_code}"
        valid_json = valid_response.json()
        # Expect a token or user data in response
        token_in_pin_login = valid_json.get("token") or valid_json.get("access_token") or valid_json.get("bearerToken")
        user_info = valid_json.get("user") or valid_json.get("profile")
        assert token_in_pin_login or user_info, "Valid PIN login response missing token or user info"
    except (requests.RequestException, AssertionError) as e:
        raise AssertionError(f"Valid PIN login test failed: {e}")

test_pin_login_api()