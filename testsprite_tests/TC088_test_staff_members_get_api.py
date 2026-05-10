import requests

BASE_URL = "http://localhost:8080"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30

def test_staff_members_get_api():
    session = requests.Session()
    try:
        # Authenticate and get token
        login_resp = session.post(
            f"{BASE_URL}/api/auth/login",
            json={"email": EMAIL, "password": PASSWORD},
            timeout=TIMEOUT
        )
        assert login_resp.status_code == 200, f"Login failed: {login_resp.text}"
        token = login_resp.json().get("token")
        assert token, "No token received on login"

        headers = {"Authorization": f"Bearer {token}"}

        # Create a new staff member to get a valid ID for GET by ID test
        # We need role_id, valid role_id must be fetched from /api/staff/roles
        roles_resp = session.get(f"{BASE_URL}/api/staff/roles", headers=headers, timeout=TIMEOUT)
        assert roles_resp.status_code == 200, "Failed to get staff roles"
        roles_data = roles_resp.json()
        assert isinstance(roles_data, list) and len(roles_data) > 0, "No roles available to assign"
        role_id = roles_data[0].get("id")
        assert role_id, "Role ID missing in staff roles response"

        # Create staff member payload
        new_member_payload = {
            "name": "Test Staff Member API",
            "role_id": role_id,
            "pin": "1234",
            "email": "test.staff.api@example.com"
        }

        create_resp = session.post(
            f"{BASE_URL}/api/staff/members",
            json=new_member_payload,
            headers=headers,
            timeout=TIMEOUT
        )
        assert create_resp.status_code == 201, f"Failed to create staff member: {create_resp.text}"
        member = create_resp.json()
        member_id = member.get("id")
        assert member_id, "Created member ID not returned"

        # Test GET /api/staff/members/{id} returns member details with role and permissions
        get_resp = session.get(
            f"{BASE_URL}/api/staff/members/{member_id}",
            headers=headers,
            timeout=TIMEOUT
        )
        assert get_resp.status_code == 200, f"Failed to get staff member details: {get_resp.text}"
        member_data = get_resp.json()
        # Validate returned data contains expected fields
        assert member_data.get("id") == member_id, "Member ID mismatch"
        assert "name" in member_data and member_data["name"] == new_member_payload["name"], "Name mismatch"
        assert "role" in member_data and isinstance(member_data["role"], dict), "Role info missing or invalid"
        role_data = member_data["role"]
        assert role_data.get("id") == role_id, "Role ID mismatch in member details"
        assert "permissions" in role_data and isinstance(role_data["permissions"], list), "Permissions missing or invalid"

        # Test GET /api/staff/members/{id} with unknown ID returns 404
        unknown_id = "00000000-0000-0000-0000-000000000000"
        unknown_resp = session.get(
            f"{BASE_URL}/api/staff/members/{unknown_id}",
            headers=headers,
            timeout=TIMEOUT
        )
        assert unknown_resp.status_code == 404, f"Expected 404 for unknown ID but got {unknown_resp.status_code}"

    finally:
        # Cleanup - delete the created staff member
        if 'member_id' in locals():
            delete_resp = session.delete(
                f"{BASE_URL}/api/staff/members/{member_id}",
                headers=headers,
                timeout=TIMEOUT
            )
            # Deletion might be soft-deactivate so we do not assert here, just attempt cleanup

test_staff_members_get_api()