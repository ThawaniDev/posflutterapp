import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
LABELS_TEMPLATES_ENDPOINT = "/api/labels/templates"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_label_templates_api():
    # Authenticate and get token
    login_payload = {"email": EMAIL, "password": PASSWORD}
    try:
        login_response = requests.post(f"{BASE_URL}{LOGIN_ENDPOINT}", json=login_payload, timeout=TIMEOUT)
        login_response.raise_for_status()
        token = login_response.json().get("token")
        assert token, "Authentication token not found in login response"
    except requests.RequestException as e:
        assert False, f"Login request failed: {e}"

    headers = {"Authorization": f"Bearer {token}"}

    try:
        response = requests.get(f"{BASE_URL}{LABELS_TEMPLATES_ENDPOINT}", headers=headers, timeout=TIMEOUT)
        response.raise_for_status()
    except requests.RequestException as e:
        assert False, f"GET {LABELS_TEMPLATES_ENDPOINT} request failed: {e}"

    data = response.json()
    assert isinstance(data, list), "Response is not a list"

    # Additional field assertions cannot be made due to lack of specification, so just check list elements if any
    if len(data) > 0:
        assert isinstance(data[0], dict), "Template item is not a dictionary"


test_label_templates_api()
