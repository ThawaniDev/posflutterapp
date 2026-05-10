import requests
import uuid

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
STAFF_MEMBERS_ENDPOINT = "/api/staff/members"

EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30

def test_staff_members_create_api():
    # Authenticate and get token
    try:
        login_resp = requests.post(
            f"{BASE_URL}{LOGIN_ENDPOINT}",
            json={"email": EMAIL, "password": PASSWORD},
            timeout=TIMEOUT
        )
        assert login_resp.status_code == 200, f"Login failed: {login_resp.text}"
        token = login_resp.json().get("token")
        assert token, "No token found in login response"
    except Exception as e:
        assert False, f"Authentication failed: {str(e)}"
    
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }
    
    # Prepare unique pin to avoid collisions
    unique_pin = str(uuid.uuid4().int)[:6]
    member_name = f"Test Member {uuid.uuid4()}"
    role_id = 1  # Using 1 as example role_id, assuming it exists
    
    created_member_id = None
    
    # Create a staff member successfully
    try:
        payload = {
            "name": member_name,
            "role_id": role_id,
            "pin": unique_pin,
            "email": f"{unique_pin}@example.com"
        }
        create_resp = requests.post(
            f"{BASE_URL}{STAFF_MEMBERS_ENDPOINT}",
            json=payload,
            headers=headers,
            timeout=TIMEOUT
        )
        assert create_resp.status_code == 201, f"Expected 201 Created but got {create_resp.status_code}: {create_resp.text}"
        resp_json = create_resp.json()
        created_member_id = resp_json.get("id")
        assert created_member_id is not None, "Created member ID not returned"
        assert resp_json.get("name") == member_name, "Member name mismatch"
        assert resp_json.get("role_id") == role_id, "Member role_id mismatch"
        assert resp_json.get("pin") == unique_pin, "Member pin mismatch"
        assert resp_json.get("email") == f"{unique_pin}@example.com", "Member email mismatch"
        
        # Attempt to create another member with duplicate PIN should return 422
        dup_pin_payload = {
            "name": f"Duplicate Pin User {uuid.uuid4()}",
            "role_id": role_id,
            "pin": unique_pin,  # duplicate pin
            "email": f"dup{unique_pin}@example.com"
        }
        dup_resp = requests.post(
            f"{BASE_URL}{STAFF_MEMBERS_ENDPOINT}",
            json=dup_pin_payload,
            headers=headers,
            timeout=TIMEOUT
        )
        assert dup_resp.status_code == 422, f"Expected 422 for duplicate PIN but got {dup_resp.status_code}"
        
        # Attempt to create member with missing name (empty string) should return 422
        missing_name_payload = {
            "role_id": role_id,
            "pin": str(uuid.uuid4().int)[:6],
            "email": f"noname{uuid.uuid4()}@example.com"
        }
        missing_name_resp = requests.post(
            f"{BASE_URL}{STAFF_MEMBERS_ENDPOINT}",
            json=missing_name_payload,
            headers=headers,
            timeout=TIMEOUT
        )
        assert missing_name_resp.status_code == 422, f"Expected 422 for missing name but got {missing_name_resp.status_code}"
    
    finally:
        # Cleanup: delete the created staff member if created
        if created_member_id:
            try:
                del_resp = requests.delete(
                    f"{BASE_URL}{STAFF_MEMBERS_ENDPOINT}/{created_member_id}",
                    headers=headers,
                    timeout=TIMEOUT
                )
                # Deletion may return 200 or 204, both acceptable
                assert del_resp.status_code in (200, 204), f"Failed to delete staff member ID {created_member_id}, status {del_resp.status_code}"
            except Exception as del_exc:
                # Log deletion failure but don't fail test for cleanup errors
                print(f"Cleanup failed to delete staff member {created_member_id}: {str(del_exc)}")
                
test_staff_members_create_api()