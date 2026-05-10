import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
ATTENDANCE_CLOCK_ENDPOINT = "/api/staff/attendance/clock"
TIMEOUT = 30

def test_staff_attendance_clock_api():
    # Login to obtain Bearer token
    login_payload = {
        "email": "owner@ostora.sa",
        "password": "owner@ostora.sa"
    }
    try:
        login_resp = requests.post(
            BASE_URL + LOGIN_ENDPOINT,
            json=login_payload,
            timeout=TIMEOUT
        )
        assert login_resp.status_code == 200, f"Login failed with status {login_resp.status_code}"
        token = login_resp.json().get("token")
        assert token, "No token in login response"
    except Exception as e:
        raise AssertionError(f"Login request failed: {e}")

    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }

    # Test clock_in action returns timestamp
    try:
        clock_in_resp = requests.post(
            BASE_URL + ATTENDANCE_CLOCK_ENDPOINT,
            json={"action": "clock_in"},
            headers=headers,
            timeout=TIMEOUT
        )
        assert clock_in_resp.status_code == 200, f"Clock in failed with status {clock_in_resp.status_code}"
        clock_in_json = clock_in_resp.json()
        assert "timestamp" in clock_in_json, "Clock in response missing 'timestamp'"
        clock_in_timestamp = clock_in_json["timestamp"]
        assert isinstance(clock_in_timestamp, str) and clock_in_timestamp, "Invalid timestamp value for clock in"
    except Exception as e:
        raise AssertionError(f"Clock in request failed: {e}")

    # Test clock_out action returns timestamp
    try:
        clock_out_resp = requests.post(
            BASE_URL + ATTENDANCE_CLOCK_ENDPOINT,
            json={"action": "clock_out"},
            headers=headers,
            timeout=TIMEOUT
        )
        assert clock_out_resp.status_code == 200, f"Clock out failed with status {clock_out_resp.status_code}"
        clock_out_json = clock_out_resp.json()
        assert "timestamp" in clock_out_json, "Clock out response missing 'timestamp'"
        clock_out_timestamp = clock_out_json["timestamp"]
        assert isinstance(clock_out_timestamp, str) and clock_out_timestamp, "Invalid timestamp value for clock out"
    except Exception as e:
        raise AssertionError(f"Clock out request failed: {e}")

    # Test invalid action returns 422
    try:
        invalid_resp = requests.post(
            BASE_URL + ATTENDANCE_CLOCK_ENDPOINT,
            json={"action": "invalid_action"},
            headers=headers,
            timeout=TIMEOUT
        )
        assert invalid_resp.status_code == 422, \
            f"Invalid action did not return 422, got {invalid_resp.status_code}"
    except Exception as e:
        raise AssertionError(f"Invalid action request failed: {e}")

test_staff_attendance_clock_api()