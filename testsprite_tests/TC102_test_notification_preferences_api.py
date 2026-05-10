import requests

BASE_URL = "http://localhost:8080"
LOGIN_URL = f"{BASE_URL}/api/auth/login"
NOTIFICATIONS_PREF_URL = f"{BASE_URL}/api/notifications/preferences"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_notification_preferences_api():
    # Login to get auth token
    try:
        login_resp = requests.post(
            LOGIN_URL,
            json={"email": EMAIL, "password": PASSWORD},
            timeout=TIMEOUT,
        )
        assert login_resp.status_code == 200, f"Login failed: {login_resp.text}"
        token = login_resp.json().get("token") or login_resp.json().get("access_token")
        assert token and isinstance(token, str), "Token not found in login response"
        headers = {"Authorization": f"Bearer {token}"}

        # GET: Retrieve current notification preferences
        get_resp = requests.get(NOTIFICATIONS_PREF_URL, headers=headers, timeout=TIMEOUT)
        assert get_resp.status_code == 200, f"GET preferences failed: {get_resp.text}"
        data = get_resp.json()
        assert "push_enabled" in data and isinstance(data["push_enabled"], bool), "push_enabled missing or invalid"
        assert "email_enabled" in data and isinstance(data["email_enabled"], bool), "email_enabled missing or invalid"

        original_push = data["push_enabled"]
        original_email = data["email_enabled"]

        # PUT: Toggle the preferences to update
        updated_payload = {
            "push_enabled": not original_push,
            "email_enabled": not original_email,
        }
        put_resp = requests.put(
            NOTIFICATIONS_PREF_URL,
            json=updated_payload,
            headers=headers,
            timeout=TIMEOUT,
        )
        assert put_resp.status_code == 200, f"PUT preferences failed: {put_resp.text}"
        updated_data = put_resp.json()
        assert updated_data.get("push_enabled") == updated_payload["push_enabled"], "push_enabled not updated correctly"
        assert updated_data.get("email_enabled") == updated_payload["email_enabled"], "email_enabled not updated correctly"

        # GET again to verify changes persisted
        get_resp2 = requests.get(NOTIFICATIONS_PREF_URL, headers=headers, timeout=TIMEOUT)
        assert get_resp2.status_code == 200, f"GET after PUT failed: {get_resp2.text}"
        data_after = get_resp2.json()
        assert data_after.get("push_enabled") == updated_payload["push_enabled"], "push_enabled did not persist"
        assert data_after.get("email_enabled") == updated_payload["email_enabled"], "email_enabled did not persist"

        # Revert changes to original state to not affect subsequent tests
        revert_resp = requests.put(
            NOTIFICATIONS_PREF_URL,
            json={"push_enabled": original_push, "email_enabled": original_email},
            headers=headers,
            timeout=TIMEOUT,
        )
        assert revert_resp.status_code == 200, f"Revert preferences failed: {revert_resp.text}"
        reverted_data = revert_resp.json()
        assert reverted_data.get("push_enabled") == original_push, "push_enabled revert failed"
        assert reverted_data.get("email_enabled") == original_email, "email_enabled revert failed"

    except requests.RequestException as e:
        assert False, f"Request exception occurred: {str(e)}"


test_notification_preferences_api()