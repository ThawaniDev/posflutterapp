import requests
import pytest

BASE_URL = "http://localhost:8080"
LOGIN_EMAIL = "owner@ostora.sa"
LOGIN_PASSWORD = "owner@ostora.sa"
TIMEOUT = 30

def test_staff_member_activity_log_api():
    session = requests.Session()
    try:
        # Step 1: Authenticate and get token
        login_resp = session.post(
            f"{BASE_URL}/api/auth/login",
            json={"email": LOGIN_EMAIL, "password": LOGIN_PASSWORD},
            timeout=TIMEOUT
        )
        assert login_resp.status_code == 200, f"Login failed: {login_resp.text}"
        token = login_resp.json().get("token") or login_resp.json().get("access_token")
        assert token, "Authentication token not found in login response"
        headers = {"Authorization": f"Bearer {token}"}

        # Step 2: Get list of staff members to obtain an ID
        members_resp = session.get(f"{BASE_URL}/api/staff/members", headers=headers, timeout=TIMEOUT)
        assert members_resp.status_code == 200, f"Failed to get staff members: {members_resp.text}"
        members = members_resp.json()
        assert isinstance(members, list), "Staff members response is not a list"
        assert len(members) > 0, "No staff members found for activity log test"
        staff_member_id = str(members[0].get("id") or members[0].get("_id"))
        assert staff_member_id, "Staff member ID is missing"

        # Step 3: Request activity log for staff member
        activity_resp = session.get(
            f"{BASE_URL}/api/staff/members/{staff_member_id}/activity-log",
            headers=headers,
            timeout=TIMEOUT
        )
        assert activity_resp.status_code == 200, f"Failed to get activity log: {activity_resp.text}"
        activity_log = activity_resp.json()
        assert isinstance(activity_log, list), "Activity log response is not a list"

        # Step 4: Validate that each entry contains required fields
        for entry in activity_log:
            assert isinstance(entry, dict), "Activity log entry is not an object"
            # Must have timestamp and some kind of action or description
            assert "timestamp" in entry or "created_at" in entry, "Missing timestamp in activity log entry"
            timestamp_value = entry.get("timestamp") or entry.get("created_at")
            assert timestamp_value, "Timestamp value is empty in activity log entry"
            # There should be a description or action performed by the staff member
            assert any(key in entry for key in ["action", "description", "activity", "event"]), (
                "No action/description/event field in activity log entry"
            )
    finally:
        session.close()

test_staff_member_activity_log_api()