import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
CHECKLIST_ENDPOINT = "/api/core/onboarding/checklist"
LOGIN_EMAIL = "owner@ostora.sa"
LOGIN_PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_onboarding_checklist_api():
    # Authenticate and get token
    try:
        login_resp = requests.post(
            BASE_URL + LOGIN_ENDPOINT,
            json={"email": LOGIN_EMAIL, "password": LOGIN_PASSWORD},
            timeout=TIMEOUT,
        )
        assert login_resp.status_code == 200, f"Login failed: {login_resp.text}"
        login_data = login_resp.json()
        token = login_data.get("token") or login_data.get("access_token")
        assert token, "No token found in login response"
    except (requests.RequestException, AssertionError) as e:
        raise AssertionError(f"Login request or verification failed: {e}")

    headers = {"Authorization": f"Bearer {token}"}

    # Call onboarding checklist endpoint
    try:
        resp = requests.get(BASE_URL + CHECKLIST_ENDPOINT, headers=headers, timeout=TIMEOUT)
        assert resp.status_code == 200, f"Unexpected status code: {resp.status_code}"
        data = resp.json()
        # The checklist should contain an items list and a completion percentage (e.g., completion or percent_completed)
        assert isinstance(data, dict), "Response JSON is not an object"

        # Check for checklist items presence
        items = data.get("items") or data.get("checklist_items")
        completion = data.get("completion") or data.get("completion_percentage") or data.get("percent_completed")

        assert items is not None, "Checklist items not found in response"
        assert isinstance(items, list), "Checklist items is not a list"
        assert len(items) > 0, "Checklist items list is empty"

        # Validate that at least one item has expected keys
        first_item = items[0]
        assert isinstance(first_item, dict), "Checklist item is not an object"
        assert "name" in first_item or "title" in first_item, "Checklist item missing name/title"
        assert "is_completed" in first_item or "completed" in first_item, "Checklist item missing completed flag"

        # Validate completion percentage is a number between 0 and 100
        assert completion is not None, "Completion percentage not found"
        assert isinstance(completion, (int, float)), "Completion percentage is not a number"
        assert 0 <= completion <= 100, "Completion percentage is out of expected range (0-100)"
    except (requests.RequestException, AssertionError, ValueError) as e:
        raise AssertionError(f"Checklist request or validation failed: {e}")


test_onboarding_checklist_api()