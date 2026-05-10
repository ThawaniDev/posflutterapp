import requests
import uuid

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
STAFF_MEMBERS_ENDPOINT = "/api/staff/members"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_staff_members_delete_api():
    session = requests.Session()

    # Authenticate and get token
    login_payload = {"email": EMAIL, "password": PASSWORD}
    login_resp = session.post(f"{BASE_URL}{LOGIN_ENDPOINT}", json=login_payload, timeout=TIMEOUT)
    assert login_resp.status_code == 200, f"Login failed: {login_resp.text}"
    token = login_resp.json().get("token")
    assert token, "Bearer token not found in login response"
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }

    # Helper function to create a staff member
    def create_staff_member():
        unique_suffix = str(uuid.uuid4())[:8]
        invite_payload = {
            "name": f"Test Staff {unique_suffix}",
            "role_id": 2,  # Assuming 2 is a valid role_id like Manager or Cashier
            "pin": f"1234{unique_suffix[:2]}",
            "email": f"test.staff.{unique_suffix}@ostora.sa"
        }
        resp = session.post(f"{BASE_URL}{STAFF_MEMBERS_ENDPOINT}/invite", json=invite_payload, headers=headers, timeout=TIMEOUT)
        assert resp.status_code in (200, 201), f"Failed to create staff member: {resp.text}"
        member_id = resp.json().get("id")
        assert member_id, "Created staff member id not found"
        return member_id

    # Create staff member to delete
    member_id = create_staff_member()

    try:
        # DELETE existing member - expect success (204 No Content or 200 OK)
        delete_resp = session.delete(f"{BASE_URL}{STAFF_MEMBERS_ENDPOINT}/{member_id}", headers=headers, timeout=TIMEOUT)
        assert delete_resp.status_code in (200, 204), f"Failed to delete staff member: {delete_resp.status_code} {delete_resp.text}"

        # Verify member no longer accessible (GET 404)
        get_resp = session.get(f"{BASE_URL}{STAFF_MEMBERS_ENDPOINT}/{member_id}", headers=headers, timeout=TIMEOUT)
        assert get_resp.status_code == 404, f"Deleted staff member still accessible: {get_resp.status_code}"

        # DELETE unknown member - use a random UUID (non-existent)
        unknown_id = str(uuid.uuid4())
        delete_unknown_resp = session.delete(f"{BASE_URL}{STAFF_MEMBERS_ENDPOINT}/{unknown_id}", headers=headers, timeout=TIMEOUT)
        assert delete_unknown_resp.status_code == 404, f"Deleting unknown member did not return 404: {delete_unknown_resp.status_code} {delete_unknown_resp.text}"

    finally:
        # Try to cleanup in case delete failed
        session.delete(f"{BASE_URL}{STAFF_MEMBERS_ENDPOINT}/{member_id}", headers=headers, timeout=TIMEOUT)


test_staff_members_delete_api()