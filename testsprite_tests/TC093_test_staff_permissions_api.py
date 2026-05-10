import requests

BASE_URL = "http://localhost:8080"
LOGIN_URL = f"{BASE_URL}/api/auth/login"
PERMISSIONS_URL = f"{BASE_URL}/api/staff/permissions"
GROUPED_PERMISSIONS_URL = f"{BASE_URL}/api/staff/permissions/grouped"
LOGIN_CREDENTIALS = {
    "email": "owner@ostora.sa",
    "password": "owner@ostora.sa"
}
TIMEOUT = 30


def test_staff_permissions_api():
    # Authenticate and get bearer token
    try:
        login_response = requests.post(LOGIN_URL, json=LOGIN_CREDENTIALS, timeout=TIMEOUT)
        assert login_response.status_code == 200, f"Login failed with status {login_response.status_code}"
        login_json = login_response.json()
        token = login_json.get("token") or login_json.get("access_token") or login_json.get("data", {}).get("token")
        assert token, "Bearer token not found in login response"
    except Exception as e:
        raise AssertionError(f"Authentication request failed: {e}")

    headers = {
        "Authorization": f"Bearer {token}"
    }

    # Test GET /api/staff/permissions returns flat permission list
    try:
        resp = requests.get(PERMISSIONS_URL, headers=headers, timeout=TIMEOUT)
        assert resp.status_code == 200, f"GET {PERMISSIONS_URL} failed with status {resp.status_code}"
        permissions = resp.json()
        assert isinstance(permissions, list), "Permissions response is not a list"
        # Further validate that list contains strings or dicts representing permissions
        # For this test, at least check non-empty list
        assert len(permissions) > 0, "Permission list is empty"
        # Check that elements are strings or dicts (typical permission strings)
        assert all(isinstance(p, (str, dict)) for p in permissions), "Permissions list elements are not strings or dicts"
    except Exception as e:
        raise AssertionError(f"GET {PERMISSIONS_URL} test failed: {e}")

    # Test GET /api/staff/permissions/grouped returns module-grouped permissions
    try:
        resp_grouped = requests.get(GROUPED_PERMISSIONS_URL, headers=headers, timeout=TIMEOUT)
        assert resp_grouped.status_code == 200, f"GET {GROUPED_PERMISSIONS_URL} failed with status {resp_grouped.status_code}"
        grouped_permissions = resp_grouped.json()
        # Expecting a dict/map grouping permissions by module
        assert isinstance(grouped_permissions, dict), "Grouped permissions response is not a dictionary"
        assert len(grouped_permissions) > 0, "Grouped permissions dictionary is empty"

        # Each value should be a list of permissions (strings or dicts)
        for module, perms in grouped_permissions.items():
            assert isinstance(perms, list), f"Permissions under module '{module}' are not a list"
            assert len(perms) > 0, f"Permissions list under module '{module}' is empty"
            assert all(isinstance(p, (str, dict)) for p in perms), f"Permissions list under module '{module}' contains invalid elements"
    except Exception as e:
        raise AssertionError(f"GET {GROUPED_PERMISSIONS_URL} test failed: {e}")


test_staff_permissions_api()