import requests
from datetime import datetime, timedelta

BASE_URL = "http://localhost:8080"
LOGIN_URL = f"{BASE_URL}/api/auth/login"
SHIFTS_URL = f"{BASE_URL}/api/staff/shifts"

EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_staff_shifts_api():
    # Authenticate and get token
    login_payload = {"email": EMAIL, "password": PASSWORD}
    login_resp = requests.post(LOGIN_URL, json=login_payload, timeout=TIMEOUT)
    assert login_resp.status_code == 200, f"Login failed: {login_resp.text}"
    token = login_resp.json().get("token")
    assert token, "Token not found in login response"

    headers = {"Authorization": f"Bearer {token}", "Content-Type": "application/json"}

    # 1) Verify GET /api/staff/shifts returns shift schedule (list)
    get_resp = requests.get(SHIFTS_URL, headers=headers, timeout=TIMEOUT)
    assert get_resp.status_code == 200, f"GET shifts failed: {get_resp.text}"
    shifts = get_resp.json()
    assert isinstance(shifts, list), "Expected shift schedule as a list"

    # Need a valid staff_id to create a shift - try to get from existing shifts or get user staff ID
    # If no shifts exist or no staff_id in shifts, attempt to retrieve staff members and pick one
    staff_id = None
    for shift in shifts:
        if shift.get("staff_id"):
            staff_id = shift.get("staff_id")
            break

    if not staff_id:
        # Fallback: retrieve staff members to get a staff_id (since staff API requires auth)
        staff_url = f"{BASE_URL}/api/staff/members"
        staff_resp = requests.get(staff_url, headers=headers, timeout=TIMEOUT)
        assert staff_resp.status_code == 200, f"GET staff members failed: {staff_resp.text}"
        staff_list = staff_resp.json()
        if isinstance(staff_list, list) and len(staff_list) > 0:
            staff_id = staff_list[0].get("id")
        assert staff_id, "No staff_id available for creating shift"

    # Prepare valid start and end times for shift creation
    start_time = datetime.utcnow() + timedelta(minutes=1)
    end_time = start_time + timedelta(hours=8)

    created_shift_id = None

    try:
        # 2) POST creates shift with staff_id, start_time, end_time (valid data)
        post_payload = {
            "staff_id": staff_id,
            "start_time": start_time.isoformat() + "Z",
            "end_time": end_time.isoformat() + "Z",
        }
        post_resp = requests.post(SHIFTS_URL, headers=headers, json=post_payload, timeout=TIMEOUT)
        assert post_resp.status_code == 201, f"Shift creation failed: {post_resp.text}"
        created_shift = post_resp.json()
        created_shift_id = created_shift.get("id")
        assert created_shift_id, "Created shift id missing"
        assert created_shift.get("staff_id") == staff_id, "Staff ID mismatch in created shift"
        assert created_shift.get("start_time"), "start_time missing in created shift"
        assert created_shift.get("end_time"), "end_time missing in created shift"

        # 3) Test 422 error for end before start
        invalid_payload = {
            "staff_id": staff_id,
            "start_time": end_time.isoformat() + "Z",
            "end_time": start_time.isoformat() + "Z",
        }
        invalid_resp = requests.post(SHIFTS_URL, headers=headers, json=invalid_payload, timeout=TIMEOUT)
        assert invalid_resp.status_code == 422, f"Expected 422 for end before start, got {invalid_resp.status_code}"

    finally:
        # Cleanup: delete the created shift if exists
        if created_shift_id:
            delete_url = f"{SHIFTS_URL}/{created_shift_id}"
            # Assuming DELETE /api/staff/shifts/:id is supported for cleanup
            delete_resp = requests.delete(delete_url, headers=headers, timeout=TIMEOUT)
            # 200 or 204 OK expected; ignore failure since it's cleanup
            if delete_resp.status_code not in (200, 204):
                print(f"Warning: Failed to delete shift {created_shift_id}: {delete_resp.text}")


test_staff_shifts_api()