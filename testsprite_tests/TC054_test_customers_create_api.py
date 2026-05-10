import requests
import uuid

BASE_URL = "http://localhost:8080"
LOGIN_URL = f"{BASE_URL}/api/auth/login"
CUSTOMERS_URL = f"{BASE_URL}/api/customers"
TIMEOUT = 30

def login(email: str, password: str) -> str:
    data = {"email": email, "password": password}
    resp = requests.post(LOGIN_URL, json=data, timeout=TIMEOUT)
    resp.raise_for_status()
    token = resp.json().get("token")
    assert token, "Login response does not contain token"
    return token

def create_customer(headers, payload):
    return requests.post(CUSTOMERS_URL, json=payload, headers=headers, timeout=TIMEOUT)

def delete_customer(headers, customer_id):
    return requests.delete(f"{CUSTOMERS_URL}/{customer_id}", headers=headers, timeout=TIMEOUT)

def test_customers_create_api():
    # Login and get auth token
    token = login("owner@ostora.sa", "owner@ostora.sa")
    headers = {"Authorization": f"Bearer {token}", "Content-Type": "application/json"}

    # Generate unique phone and email for test isolation
    unique_phone = f"050{str(uuid.uuid4().int)[:7]}"
    unique_email = f"user_{uuid.uuid4().hex[:8]}@example.com"

    # Valid customer payload
    valid_customer = {
        "name": "Test Customer",
        "phone": unique_phone,
        "email": unique_email
    }

    # Create a valid customer first for duplicate phone test
    resp = create_customer(headers, valid_customer)
    assert resp.status_code == 201 or resp.status_code == 200, f"Expected 201 or 200, got {resp.status_code}"
    created_customer_id = resp.json().get("id")
    assert created_customer_id, "Created customer response missing ID"

    try:
        # 1) Successful creation (repeat with a different unique email and phone)
        another_phone = f"050{str(uuid.uuid4().int)[:7]}"
        another_email = f"user_{uuid.uuid4().hex[:8]}@example.com"

        resp = create_customer(headers, {
            "name": "Another Customer",
            "phone": another_phone,
            "email": another_email
        })
        assert resp.status_code == 201 or resp.status_code == 200, f"Expected 201 or 200, got {resp.status_code}"
        new_customer_id = resp.json().get("id")
        assert new_customer_id, "Newly created customer response missing ID"

        # Cleanup new customer after test
        if new_customer_id:
            delete_customer(headers, new_customer_id)

        # 2) Duplicate phone number results in 422
        dup_phone_payload = {
            "name": "Dup Phone Customer",
            "phone": unique_phone,  # same phone as first
            "email": f"dup_{uuid.uuid4().hex[:8]}@example.com"
        }
        resp_dup_phone = create_customer(headers, dup_phone_payload)
        assert resp_dup_phone.status_code == 422, f"Expected 422 for duplicate phone, got {resp_dup_phone.status_code}"

        # 3) Missing name results in 422
        missing_name_payload = {
            "phone": f"050{str(uuid.uuid4().int)[:7]}",
            "email": f"noname_{uuid.uuid4().hex[:8]}@example.com"
        }
        resp_missing_name = create_customer(headers, missing_name_payload)
        assert resp_missing_name.status_code == 422, f"Expected 422 for missing name, got {resp_missing_name.status_code}"

        # 4) Invalid email format results in 422
        invalid_email_payload = {
            "name": "Invalid Email",
            "phone": f"050{str(uuid.uuid4().int)[:7]}",
            "email": "invalid-email-format"  # no @ symbol etc.
        }
        resp_invalid_email = create_customer(headers, invalid_email_payload)
        assert resp_invalid_email.status_code == 422, f"Expected 422 for invalid email, got {resp_invalid_email.status_code}"

    finally:
        # Clean up the first created customer
        if created_customer_id:
            delete_customer(headers, created_customer_id)

test_customers_create_api()