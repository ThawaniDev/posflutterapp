import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
STAFF_ROLES_ENDPOINT = "/api/staff/roles"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_staff_roles_crud_api():
    # Authenticate and get token
    login_payload = {"email": EMAIL, "password": PASSWORD}
    login_resp = requests.post(BASE_URL + LOGIN_ENDPOINT, json=login_payload, timeout=TIMEOUT)
    assert login_resp.status_code == 200, f"Login failed with status {login_resp.status_code}"
    token = login_resp.json().get("token") or login_resp.json().get("access_token")
    assert token, "Token not found in login response"
    headers = {"Authorization": f"Bearer {token}", "Content-Type": "application/json"}

    # 1. GET /api/staff/roles lists roles
    get_roles_resp = requests.get(BASE_URL + STAFF_ROLES_ENDPOINT, headers=headers, timeout=TIMEOUT)
    assert get_roles_resp.status_code == 200, f"GET roles failed with status {get_roles_resp.status_code}"
    roles_list = get_roles_resp.json()
    assert isinstance(roles_list, list), "GET roles response is not a list"

    # 2. POST /api/staff/roles creates role with name and permissions
    # For permissions, try using permissions from existing roles or create a sample permissions list
    sample_permissions = []
    if roles_list:
        # Collect permissions from first role if available
        if isinstance(roles_list[0], dict):
            sample_permissions = roles_list[0].get("permissions", [])
    if not sample_permissions:
        sample_permissions = ["read_staff", "write_staff"]  # fallback sample permissions

    new_role_payload = {
        "name": "Test Role Automated",
        "permissions": sample_permissions
    }
    post_role_resp = requests.post(BASE_URL + STAFF_ROLES_ENDPOINT, headers=headers, json=new_role_payload, timeout=TIMEOUT)
    assert post_role_resp.status_code in [200, 201], f"POST role failed with status {post_role_resp.status_code}"
    created_role = post_role_resp.json()
    role_id = created_role.get("id") or created_role.get("role_id")
    assert role_id, "Created role ID not found"
    assert created_role.get("name") == new_role_payload["name"], "Created role name mismatch"
    assert set(created_role.get("permissions", [])) == set(sample_permissions), "Created role permissions mismatch"

    try:
        # 3. GET /api/staff/roles/{id} returns single role
        get_single_resp = requests.get(f"{BASE_URL}{STAFF_ROLES_ENDPOINT}/{role_id}", headers=headers, timeout=TIMEOUT)
        assert get_single_resp.status_code == 200, f"GET single role failed with status {get_single_resp.status_code}"
        single_role = get_single_resp.json()
        assert single_role.get("id") == role_id or single_role.get("role_id") == role_id, "Single role ID mismatch"
        assert single_role.get("name") == new_role_payload["name"], "Single role name mismatch"
        assert set(single_role.get("permissions", [])) == set(sample_permissions), "Single role permissions mismatch"

        # 4. GET /api/staff/roles/{unknown_id} returns 404
        unknown_id = "00000000-0000-0000-0000-000000000000"
        get_unknown_resp = requests.get(f"{BASE_URL}{STAFF_ROLES_ENDPOINT}/{unknown_id}", headers=headers, timeout=TIMEOUT)
        assert get_unknown_resp.status_code == 404, f"GET unknown role should return 404 but got {get_unknown_resp.status_code}"

    finally:
        # Cleanup - delete created role if delete endpoint exists
        # Since no DELETE documented for staff roles, attempt delete and ignore if fails
        del_resp = requests.delete(f"{BASE_URL}{STAFF_ROLES_ENDPOINT}/{role_id}", headers=headers, timeout=TIMEOUT)
        if del_resp.status_code not in [200, 204, 404]:
            # If delete returns unexpected status, raise error
            raise AssertionError(f"Failed to delete role {role_id} during cleanup. Status: {del_resp.status_code}")


test_staff_roles_crud_api()