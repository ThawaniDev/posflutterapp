import requests

BASE_URL = "http://localhost:8080"
LOGIN_URL = f"{BASE_URL}/api/auth/login"
STAFF_MEMBERS_URL = f"{BASE_URL}/api/staff/members"
TIMEOUT = 30

OWNER_EMAIL = "owner@ostora.sa"
OWNER_PASSWORD = "owner@ostora.sa"


def test_staff_pin_update_api():
    # Authenticate and get token
    login_payload = {"email": OWNER_EMAIL, "password": OWNER_PASSWORD}
    login_resp = requests.post(LOGIN_URL, json=login_payload, timeout=TIMEOUT)
    assert login_resp.status_code == 200, f"Login failed: {login_resp.text}"
    token = login_resp.json().get("access_token") or login_resp.json().get("token") or login_resp.json().get("accessToken")
    assert token, "Auth token not found in login response"

    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }

    # Helper to create staff member
    def create_staff_member(pin, email_suffix):
        payload = {
            "name": f"Test Staff {email_suffix}",
            "role_id": 2,  # assuming role Id 2 exists (e.g. Cashier/Manager)
            "pin": pin,
            "email": f"teststaff{email_suffix}@example.com"
        }
        resp = requests.post(STAFF_MEMBERS_URL, json=payload, headers=headers, timeout=TIMEOUT)
        assert resp.status_code == 201, f"Failed to create staff member: {resp.text}"
        return resp.json()["id"]

    # Create two staff members with distinct PINs
    staff1_pin = "1234"
    staff2_pin = "5678"

    staff1_id = None
    staff2_id = None
    try:
        staff1_id = create_staff_member(staff1_pin, "1")
        staff2_id = create_staff_member(staff2_pin, "2")

        # Update staff1 PIN to a new unique PIN - success case
        new_pin = "4321"
        update_resp = requests.put(
            f"{STAFF_MEMBERS_URL}/{staff1_id}/pin",
            json={"pin": new_pin},
            headers=headers,
            timeout=TIMEOUT
        )
        assert update_resp.status_code == 200, f"Expected 200 OK for PIN update, got {update_resp.status_code}: {update_resp.text}"

        # Update staff1 PIN to staff2's PIN - expect 422 error (duplicate PIN)
        dup_pin_resp = requests.put(
            f"{STAFF_MEMBERS_URL}/{staff1_id}/pin",
            json={"pin": staff2_pin},
            headers=headers,
            timeout=TIMEOUT
        )
        assert dup_pin_resp.status_code == 422, f"Expected 422 for duplicate PIN collision, got {dup_pin_resp.status_code}: {dup_pin_resp.text}"

    finally:
        # Clean up created staff members
        if staff1_id:
            requests.delete(f"{STAFF_MEMBERS_URL}/{staff1_id}", headers=headers, timeout=TIMEOUT)
        if staff2_id:
            requests.delete(f"{STAFF_MEMBERS_URL}/{staff2_id}", headers=headers, timeout=TIMEOUT)


test_staff_pin_update_api()