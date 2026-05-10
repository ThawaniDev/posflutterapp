import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
NOTIFICATIONS_ENDPOINT = "/api/notifications"
TIMEOUT = 30

EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"

def test_notifications_list_api():
    # First, attempt to call /api/notifications without auth and expect 401
    url = BASE_URL + NOTIFICATIONS_ENDPOINT
    try:
        response = requests.get(url, timeout=TIMEOUT)
        assert response.status_code == 401, f"Expected 401 Unauthorized without auth, got {response.status_code}"
    except requests.RequestException as e:
        assert False, f"Request failed without auth: {str(e)}"

    # Authenticate to get token
    login_url = BASE_URL + LOGIN_ENDPOINT
    login_payload = {"email": EMAIL, "password": PASSWORD}
    headers = {"Content-Type": "application/json"}

    try:
        login_resp = requests.post(login_url, json=login_payload, headers=headers, timeout=TIMEOUT)
        assert login_resp.status_code == 200, f"Login failed with status {login_resp.status_code}"
        login_data = login_resp.json()
        token = login_data.get("token") or login_data.get("access_token")
        assert token, "Bearer token not found in login response"
    except requests.RequestException as e:
        assert False, f"Login request failed: {str(e)}"

    # Use token to call notifications endpoint successfully
    auth_headers = {
        "Authorization": f"Bearer {token}"
    }
    try:
        notif_resp = requests.get(url, headers=auth_headers, timeout=TIMEOUT)
        assert notif_resp.status_code == 200, f"Expected 200 OK with auth, got {notif_resp.status_code}"
        notif_data = notif_resp.json()
        assert isinstance(notif_data, dict) or isinstance(notif_data, list), "Response is not a JSON object or list"
        # unread_count should be present as field or nested field
        # The description says "returns list with unread_count"
        if isinstance(notif_data, dict):
            assert "unread_count" in notif_data, "'unread_count' key not found in notifications response"
            assert isinstance(notif_data["unread_count"], int), "'unread_count' is not an integer"
            # also check that list of notifications is present
            notifications = notif_data.get("notifications") or notif_data.get("data") or notif_data.get("items")
            assert notifications is not None, "Notifications list not found in response"
            assert isinstance(notifications, list), "Notifications is not a list"
        else:
            # If response is a list, unread_count may be separate?
            # Then test case would fail, so we assert fail here to warn
            assert False, "Response is a list, but 'unread_count' expected in notification list response"
    except requests.RequestException as e:
        assert False, f"Notifications request with auth failed: {str(e)}"

test_notifications_list_api()