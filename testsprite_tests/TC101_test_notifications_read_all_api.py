import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
NOTIFICATIONS_READ_ALL_ENDPOINT = "/api/notifications/read-all"
NOTIFICATIONS_UNREAD_COUNT_ENDPOINT = "/api/notifications/unread-count"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_notifications_read_all_api():
    session = requests.Session()
    try:
        # Authenticate and get token
        login_resp = session.post(
            BASE_URL + LOGIN_ENDPOINT,
            json={"email": EMAIL, "password": PASSWORD},
            timeout=TIMEOUT,
        )
        assert login_resp.status_code == 200, f"Login failed: {login_resp.text}"
        token = login_resp.json().get("token")
        assert token and token.startswith("Bearer "), "No Bearer token in login response"
        bearer_token = token.split(" ", 1)[1]

        headers = {
            "Authorization": f"Bearer {bearer_token}",
            "Content-Type": "application/json",
        }

        # Call POST /api/notifications/read-all to mark all as read
        read_all_resp = session.post(
            BASE_URL + NOTIFICATIONS_READ_ALL_ENDPOINT,
            headers=headers,
            timeout=TIMEOUT,
        )
        assert read_all_resp.status_code == 200, f"Read-all failed: {read_all_resp.text}"

        # Call GET /api/notifications/unread-count and assert 0
        unread_count_resp = session.get(
            BASE_URL + NOTIFICATIONS_UNREAD_COUNT_ENDPOINT,
            headers=headers,
            timeout=TIMEOUT,
        )
        assert unread_count_resp.status_code == 200, f"Unread count failed: {unread_count_resp.text}"
        unread_count_json = unread_count_resp.json()
        # unread-count returns an integer count directly or with key - handle both
        if isinstance(unread_count_json, dict):
            # Try common keys
            count = (
                unread_count_json.get("count")
                or unread_count_json.get("unread_count")
                or unread_count_json.get("unreadCount")
                or 0
            )
            assert int(count) == 0, f"Expected unread count 0, got {count}"
        else:
            # If response is raw integer
            assert int(unread_count_json) == 0, f"Expected unread count 0, got {unread_count_json}"

    finally:
        session.close()


test_notifications_read_all_api()