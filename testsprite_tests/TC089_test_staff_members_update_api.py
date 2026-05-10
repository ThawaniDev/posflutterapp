import requests

BASE_URL = "http://localhost:8080"
LOGIN_EMAIL = "owner@ostora.sa"
LOGIN_PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def login_and_get_token():
    login_url = f"{BASE_URL}/api/auth/login"
    payload = {"email": LOGIN_EMAIL, "password": LOGIN_PASSWORD}
    resp = requests.post(login_url, json=payload, timeout=TIMEOUT)
    resp.raise_for_status()
    token = resp.json().get("access_token") or resp.json().get("token")
    if not token:
        raise Exception("Authentication token not found in login response")
    return token


def create_staff_member(headers):
    invite_url = f"{BASE_URL}/api/staff/members"
    # Since from PRD the creation is POST /api/staff/members (not clearly specified),
    # but from test cases POST /api/staff/members creates a member.
    # We'll use POST /api/staff/members with minimal required fields.
    # Role assignment requires valid role_id, so obtain valid role_id to use.

    # First, get roles to find at least one valid role_id
    roles_url = f"{BASE_URL}/api/staff/roles"
    roles_resp = requests.get(roles_url, headers=headers, timeout=TIMEOUT)
    roles_resp.raise_for_status()
    roles = roles_resp.json()
    if not roles or not isinstance(roles, list):
        raise Exception("No roles found to assign for staff member creation")
    valid_role_id = roles[0]["id"]

    # Create a unique staff member (randomize name/email/pin)
    import random, string
    random_str = "".join(random.choices(string.ascii_letters + string.digits, k=6))
    staff_payload = {
        "name": f"Test User {random_str}",
        "role_id": valid_role_id,
        "email": f"testuser{random_str}@ostora.sa",
        "pin": f"{random.randint(1000, 9999)}"
    }
    create_resp = requests.post(invite_url, headers=headers, json=staff_payload, timeout=TIMEOUT)
    create_resp.raise_for_status()
    created_member = create_resp.json()
    return created_member


def delete_staff_member(member_id, headers):
    # Assuming DELETE endpoint /api/staff/members/{id} exists to remove/deactivate staff
    delete_url = f"{BASE_URL}/api/staff/members/{member_id}"
    requests.delete(delete_url, headers=headers, timeout=TIMEOUT)


def test_staff_members_update_api():
    token = login_and_get_token()
    headers = {"Authorization": f"Bearer {token}", "Content-Type": "application/json"}

    created_member = None
    try:
        # Create a new staff member to update
        created_member = create_staff_member(headers)
        member_id = created_member["id"]

        # Get a valid role_id different than current member's role_id for update test
        roles_url = f"{BASE_URL}/api/staff/roles"
        roles_resp = requests.get(roles_url, headers=headers, timeout=TIMEOUT)
        roles_resp.raise_for_status()
        roles = roles_resp.json()
        if not roles or not isinstance(roles, list):
            raise Exception("No roles found for update test")

        current_role_id = created_member.get("role_id") or created_member.get("role") or None
        # Find a different role_id for update
        valid_role_id = None
        for role in roles:
            if role["id"] != current_role_id:
                valid_role_id = role["id"]
                break
        # If no different role found, just use the first one anyway
        if valid_role_id is None:
            valid_role_id = roles[0]["id"]

        # 1) Test successful update: update name and role_id
        update_url = f"{BASE_URL}/api/staff/members/{member_id}"
        new_name = created_member["name"] + " Updated"
        update_payload = {"name": new_name, "role_id": valid_role_id}
        update_resp = requests.put(update_url, headers=headers, json=update_payload, timeout=TIMEOUT)
        assert update_resp.status_code == 200, f"Expected 200 OK, got {update_resp.status_code}"
        updated_member = update_resp.json()
        assert updated_member.get("name") == new_name, "Name not updated correctly"
        # Role id in response might be under "role_id" or nested within "role" object
        if "role_id" in updated_member:
            assert updated_member["role_id"] == valid_role_id, "Role ID not updated correctly"
        elif "role" in updated_member and isinstance(updated_member["role"], dict):
            assert updated_member["role"].get("id") == valid_role_id, "Role ID not updated correctly"
        else:
            raise AssertionError("Role ID missing from update response")

        # 2) Test 422 error for invalid role_id
        invalid_role_id = 999999999  # Assume this role_id does not exist
        invalid_payload = {"name": new_name, "role_id": invalid_role_id}
        invalid_resp = requests.put(update_url, headers=headers, json=invalid_payload, timeout=TIMEOUT)
        assert invalid_resp.status_code == 422, f"Expected 422 for invalid role_id, got {invalid_resp.status_code}"

    finally:
        if created_member:
            try:
                delete_staff_member(created_member["id"], headers)
            except Exception:
                pass


test_staff_members_update_api()