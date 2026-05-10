import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
LABEL_PRESETS_ENDPOINT = "/api/labels/templates/presets"
TIMEOUT = 30

def test_label_presets_api():
    # Step 1: Authenticate and obtain bearer token
    login_payload = {
        "email": "owner@ostora.sa",
        "password": "owner@ostora.sa"
    }
    try:
        login_response = requests.post(
            f"{BASE_URL}{LOGIN_ENDPOINT}",
            json=login_payload,
            timeout=TIMEOUT
        )
        assert login_response.status_code == 200, f"Login failed: {login_response.text}"
        login_data = login_response.json()
        token = login_data.get("token") or login_data.get("access_token")
        assert token is not None, "Token not found in login response"
    except requests.RequestException as e:
        assert False, f"Login request error: {e}"

    headers = {
        "Authorization": f"Bearer {token}"
    }

    # Step 2: Call GET /api/labels/templates/presets
    try:
        response = requests.get(
            f"{BASE_URL}{LABEL_PRESETS_ENDPOINT}",
            headers=headers,
            timeout=TIMEOUT
        )
    except requests.RequestException as e:
        assert False, f"Request to label presets API failed: {e}"

    # Step 3: Validate response status code
    assert response.status_code == 200, f"Expected 200 OK, got {response.status_code}"

    # Step 4: Validate response content
    try:
        presets = response.json()
    except Exception as e:
        assert False, f"Invalid JSON response: {e}"

    # Must be a list
    assert isinstance(presets, list), f"Response is not a list: {presets}"

    # Validate at least one preset exists with required fields
    assert presets, "Presets list is empty"

    required_fields = {"id", "name", "width", "height", "layout"}

    for preset in presets:
        # preset should be a dict
        assert isinstance(preset, dict), f"Preset item not a dict: {preset}"
        # Check required fields presence
        missing_fields = required_fields - preset.keys()
        assert not missing_fields, f"Preset missing fields {missing_fields}: {preset}"
        # Validate dimensions are positive numbers
        assert isinstance(preset["width"], (int, float)) and preset["width"] > 0, f"Invalid width {preset['width']} in preset {preset}"
        assert isinstance(preset["height"], (int, float)) and preset["height"] > 0, f"Invalid height {preset['height']} in preset {preset}"
        # Validate layout is a non-empty string
        assert isinstance(preset["layout"], str) and preset["layout"], f"Invalid layout in preset {preset}"

    print("test_label_presets_api passed")

test_label_presets_api()