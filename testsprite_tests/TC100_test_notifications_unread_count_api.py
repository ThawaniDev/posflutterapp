import requests


BASE_URL = "http://localhost:8080"
LOGIN_URL = f"{BASE_URL}/api/auth/login"
UNREAD_COUNT_URL = f"{BASE_URL}/api/notifications/unread-count"
READ_ALL_URL = f"{BASE_URL}/api/notifications/read-all"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_notifications_unread_count_api():
    # Authenticate and get token
    try:
        login_resp = requests.post(
            LOGIN_URL,
            json={"email": EMAIL, "password": PASSWORD},
            timeout=TIMEOUT,
        )
        assert login_resp.status_code == 200, f"Login failed: {login_resp.text}"
        token = login_resp.json().get("token") or login_resp.json().get("access_token")
        assert token, "Token not found in login response"
    except Exception as ex:
        raise RuntimeError(f"Authentication error: {ex}")

    headers = {"Authorization": f"Bearer {token}"}

    # Step 1: Get unread count - expect integer >=0
    try:
        unread_resp = requests.get(UNREAD_COUNT_URL, headers=headers, timeout=TIMEOUT)
        assert unread_resp.status_code == 200, f"Unread count request failed: {unread_resp.text}"
        count_val = unread_resp.json()
        # Accept if response is int or dict with count key
        if isinstance(count_val, dict):
            count = count_val.get("count")
            assert isinstance(count, int), f"Count field not int in response: {count_val}"
        else:
            count = count_val
            assert isinstance(count, int), f"Unread count response not integer: {count}"
        initial_count = count
    except Exception as ex:
        raise RuntimeError(f"Error fetching unread count: {ex}")

    # Step 2: Mark all notifications as read
    try:
        read_all_resp = requests.post(READ_ALL_URL, headers=headers, timeout=TIMEOUT)
        assert read_all_resp.status_code == 200, f"Read-all request failed: {read_all_resp.text}"
    except Exception as ex:
        raise RuntimeError(f"Error marking notifications as read: {ex}")

    # Step 3: Validate unread count is zero after read-all
    try:
        unread_after_resp = requests.get(UNREAD_COUNT_URL, headers=headers, timeout=TIMEOUT)
        assert unread_after_resp.status_code == 200, f"Unread count after read-all failed: {unread_after_resp.text}"
        count_val_after = unread_after_resp.json()
        if isinstance(count_val_after, dict):
            count_after = count_val_after.get("count")
            assert isinstance(count_after, int), f"Count field not int after read-all: {count_val_after}"
        else:
            count_after = count_val_after
            assert isinstance(count_after, int), f"Unread count after read-all not integer: {count_after}"
        assert count_after == 0, f"Unread count after read-all is not zero, got {count_after}, initial was {initial_count}"
    except Exception as ex:
        raise RuntimeError(f"Error verifying unread count after read-all: {ex}")


test_notifications_unread_count_api()