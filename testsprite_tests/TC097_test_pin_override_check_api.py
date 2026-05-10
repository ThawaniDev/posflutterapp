import requests

BASE_URL = "http://localhost:8080"
LOGIN_URL = f"{BASE_URL}/api/auth/login"
PIN_OVERRIDE_CHECK_URL = f"{BASE_URL}/api/staff/pin-override/check"

EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_pin_override_check_api():
    try:
        # Step 1: Authenticate and get Bearer token
        login_payload = {"email": EMAIL, "password": PASSWORD}
        login_resp = requests.post(LOGIN_URL, json=login_payload, timeout=TIMEOUT)
        login_resp.raise_for_status()
        token = login_resp.json().get("token")
        assert token, "Authentication token not found in login response"

        headers = {
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json",
        }

        # Step 2: Post with valid manager PIN - expect authorized: true
        # We need a valid manager PIN; try "1234" as a typical valid PIN example
        # Since no actual manager PIN provided in PRD, assuming "1234" is valid for test purpose
        valid_pin_payload = {"pin": "1234"}
        valid_resp = requests.post(
            PIN_OVERRIDE_CHECK_URL,
            json=valid_pin_payload,
            headers=headers,
            timeout=TIMEOUT,
        )
        valid_resp.raise_for_status()
        valid_json = valid_resp.json()
        assert isinstance(valid_json, dict), "Response is not a JSON object"
        assert (
            valid_json.get("authorized") is True
        ), f"Expected authorized=true for valid PIN, got {valid_json.get('authorized')}"

        # Step 3: Post with wrong PIN - expect authorized: false, no error
        wrong_pin_payload = {"pin": "0000"}
        wrong_resp = requests.post(
            PIN_OVERRIDE_CHECK_URL,
            json=wrong_pin_payload,
            headers=headers,
            timeout=TIMEOUT,
        )
        wrong_resp.raise_for_status()
        wrong_json = wrong_resp.json()
        assert isinstance(wrong_json, dict), "Response is not a JSON object"
        assert (
            wrong_json.get("authorized") is False
        ), f"Expected authorized=false for wrong PIN, got {wrong_json.get('authorized')}"

    except requests.exceptions.RequestException as e:
        assert False, f"HTTP request failed: {e}"
    except AssertionError as e:
        assert False, f"Assertion failed: {e}"


test_pin_override_check_api()