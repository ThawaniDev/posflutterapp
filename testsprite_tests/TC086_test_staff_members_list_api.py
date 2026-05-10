import requests

BASE_URL = "http://localhost:8080"
LOGIN_URL = f"{BASE_URL}/api/auth/login"
STAFF_MEMBERS_URL = f"{BASE_URL}/api/staff"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def get_auth_token():
    try:
        payload = {"email": EMAIL, "password": PASSWORD}
        response = requests.post(LOGIN_URL, json=payload, timeout=TIMEOUT)
        response.raise_for_status()
        data = response.json()
        token = data.get("token") or data.get("access_token")
        if not token:
            raise ValueError("Token not found in login response")
        return token
    except Exception as e:
        raise RuntimeError(f"Failed to authenticate: {e}")


def test_staff_members_list_api():
    # Test 401 Unauthorized without auth
    try:
        response = requests.get(STAFF_MEMBERS_URL, timeout=TIMEOUT)
        assert response.status_code == 401, f"Expected 401 Unauthorized without auth but got {response.status_code}"
    except requests.exceptions.RequestException as e:
        raise RuntimeError(f"Request failed: {e}")

    # Login and get token
    token = get_auth_token()
    headers = {"Authorization": f"Bearer {token}"}

    try:
        # Send GET request with auth
        response = requests.get(STAFF_MEMBERS_URL, headers=headers, timeout=TIMEOUT)
        response.raise_for_status()
        data = response.json()
        assert isinstance(data, list), "Response is not a list"

        for member in data:
            assert isinstance(member, dict), "Staff member item is not a dictionary"
            assert "name" in member, "Missing 'name' in staff member"
            assert isinstance(member["name"], str), "'name' is not a string"
            assert "role" in member, "Missing 'role' in staff member"
            assert isinstance(member["role"], (str, dict, type(None))), "'role' is not string/dict/None"
            assert "status" in member, "Missing 'status' in staff member"
            assert isinstance(member["status"], str), "'status' is not a string"
    except requests.exceptions.RequestException as e:
        raise RuntimeError(f"Request failed: {e}")


test_staff_members_list_api()
