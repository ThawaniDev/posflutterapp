import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
ATTENDANCE_ENDPOINT = "/api/staff/attendance"
TIMEOUT = 30

def test_staff_attendance_list_api():
    # Login to get the authentication token
    login_payload = {
        "email": "owner@ostora.sa",
        "password": "owner@ostora.sa"
    }
    try:
        login_response = requests.post(
            BASE_URL + LOGIN_ENDPOINT,
            json=login_payload,
            timeout=TIMEOUT
        )
        login_response.raise_for_status()
    except requests.RequestException as e:
        raise AssertionError(f"Authentication request failed: {e}")

    login_data = login_response.json()
    token = login_data.get("token")
    if not token:
        raise AssertionError("Login response does not contain authentication token")

    headers = {
        "Authorization": f"Bearer {token}"
    }

    # Get attendance records
    try:
        attendance_response = requests.get(
            BASE_URL + ATTENDANCE_ENDPOINT,
            headers=headers,
            timeout=TIMEOUT
        )
        attendance_response.raise_for_status()
    except requests.RequestException as e:
        raise AssertionError(f"Failed to get attendance records: {e}")

    attendance_data = attendance_response.json()
    if not isinstance(attendance_data, list):
        raise AssertionError("Attendance response is not a list")

    # Validate each attendance record contains required fields with appropriate types
    for record in attendance_data:
        if not isinstance(record, dict):
            raise AssertionError("Attendance record is not a dictionary")
        assert "clock_in" in record, "clock_in missing in attendance record"
        assert "clock_out" in record, "clock_out missing in attendance record"
        assert "hours_worked" in record, "hours_worked missing in attendance record"
        # clock_in and clock_out can be None or string timestamp, hours_worked should be number (int or float)
        clock_in = record["clock_in"]
        clock_out = record["clock_out"]
        hours_worked = record["hours_worked"]

        assert (clock_in is None or isinstance(clock_in, str)), "clock_in should be string or None"
        assert (clock_out is None or isinstance(clock_out, str)), "clock_out should be string or None"
        assert isinstance(hours_worked, (int, float)), "hours_worked should be a number"

test_staff_attendance_list_api()