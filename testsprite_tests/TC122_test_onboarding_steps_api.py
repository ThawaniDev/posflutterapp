import requests
import sys

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
ONBOARDING_STEPS_ENDPOINT = "/api/core/onboarding/steps"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_onboarding_steps_api():
    session = requests.Session()

    # Authenticate and get Bearer token
    login_url = BASE_URL + LOGIN_ENDPOINT
    login_payload = {"email": EMAIL, "password": PASSWORD}
    try:
        login_resp = session.post(login_url, json=login_payload, timeout=TIMEOUT)
    except Exception as e:
        sys.exit(f"Login request failed: {e}")

    assert login_resp.status_code == 200, f"Login failed: {login_resp.status_code} {login_resp.text}"
    login_json = login_resp.json()
    token = login_json.get("token") or login_json.get("access_token")
    assert token, f"No token found in login response: {login_json}"

    headers = {
        "Authorization": f"Bearer {token}"
    }

    # Call GET onboarding steps endpoint
    steps_url = BASE_URL + ONBOARDING_STEPS_ENDPOINT
    try:
        steps_resp = session.get(steps_url, headers=headers, timeout=TIMEOUT)
    except Exception as e:
        sys.exit(f"Onboarding steps request failed: {e}")

    assert steps_resp.status_code == 200, f"Failed to get onboarding steps: {steps_resp.status_code} {steps_resp.text}"

    steps_json = steps_resp.json()
    assert isinstance(steps_json, list), f"Expected list response, got {type(steps_json)}"
    assert len(steps_json) > 0, "Onboarding steps list is empty"

    # Verify each step has is_completed flag
    for step in steps_json:
        assert isinstance(step, dict), f"Step item is not a dict: {step}"
        assert "is_completed" in step, f"is_completed flag missing in step: {step}"
        assert isinstance(step["is_completed"], bool), f"is_completed is not bool in step: {step}"
        assert "name" in step or "step" in step, f"Step identifier missing in step: {step}"

    print("test_onboarding_steps_api passed")


test_onboarding_steps_api()