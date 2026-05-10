import requests
import uuid

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
CUSTOMERS_ENDPOINT = "/api/customers"
TIMEOUT = 30

OWNER_EMAIL = "owner@ostora.sa"
OWNER_PASSWORD = "owner@ostora.sa"

def authenticate(email, password):
    resp = requests.post(
        f"{BASE_URL}{LOGIN_ENDPOINT}",
        json={"email": email, "password": password},
        timeout=TIMEOUT,
    )
    resp.raise_for_status()
    token = resp.json().get("token")
    assert token, "No token received on login"
    return token

def create_customer(token, name, phone, email):
    headers = {"Authorization": f"Bearer {token}"}
    payload = {"name": name, "phone": phone, "email": email}
    resp = requests.post(
        f"{BASE_URL}{CUSTOMERS_ENDPOINT}", json=payload, headers=headers, timeout=TIMEOUT
    )
    resp.raise_for_status()
    customer = resp.json()
    assert "id" in customer, "Created customer response lacks id"
    return customer

def delete_customer(token, customer_id):
    headers = {"Authorization": f"Bearer {token}"}
    resp = requests.delete(
        f"{BASE_URL}{CUSTOMERS_ENDPOINT}/{customer_id}", headers=headers, timeout=TIMEOUT
    )
    # Deletion might return 200 or 204 typically
    if resp.status_code not in (200, 204, 404):
        resp.raise_for_status()

def test_customers_update_api():
    token = authenticate(OWNER_EMAIL, OWNER_PASSWORD)
    headers = {"Authorization": f"Bearer {token}"}

    # Create a customer to test update on
    unique_suffix = uuid.uuid4().hex[:8]
    original_name = f"Test Customer {unique_suffix}"
    original_phone = f"050{unique_suffix[:7]}"
    original_email = f"test{unique_suffix}@example.com"
    customer = create_customer(token, original_name, original_phone, original_email)
    customer_id = customer["id"]

    # Create another customer to test duplicate phone error (422)
    dup_phone_suffix = uuid.uuid4().hex[:8]
    dup_phone = f"055{dup_phone_suffix[:7]}"
    dup_customer = create_customer(token, f"Dup Customer {dup_phone_suffix}", dup_phone, f"dup{dup_phone_suffix}@example.com")
    dup_customer_id = dup_customer["id"]

    try:
        # 1. Verify PUT /api/customers/{id} updates name, phone, and email.
        updated_name = f"{original_name} Updated"
        updated_phone = f"056{uuid.uuid4().hex[:7]}"
        updated_email = f"updated{uuid.uuid4().hex[:8]}@example.com"
        update_payload = {
            "name": updated_name,
            "phone": updated_phone,
            "email": updated_email
        }
        update_resp = requests.put(
            f"{BASE_URL}{CUSTOMERS_ENDPOINT}/{customer_id}",
            json=update_payload,
            headers=headers,
            timeout=TIMEOUT,
        )
        assert update_resp.status_code == 200, f"Expected 200 OK on update, got {update_resp.status_code}"
        updated_customer = update_resp.json()
        assert updated_customer.get("name") == updated_name
        assert updated_customer.get("phone") == updated_phone
        assert updated_customer.get("email") == updated_email

        # 2. Test 404 for unknown ID on update
        unknown_id = "00000000-0000-0000-0000-000000000000"
        not_found_resp = requests.put(
            f"{BASE_URL}{CUSTOMERS_ENDPOINT}/{unknown_id}",
            json=update_payload,
            headers=headers,
            timeout=TIMEOUT,
        )
        assert not_found_resp.status_code == 404, f"Expected 404 for unknown customer ID, got {not_found_resp.status_code}"

        # 3. Test 422 for duplicate phone on update
        dup_phone_payload = {
            "name": "Some Other Name",
            "phone": dup_phone,
            "email": "diffemail@example.com"
        }
        duplicate_phone_resp = requests.put(
            f"{BASE_URL}{CUSTOMERS_ENDPOINT}/{customer_id}",
            json=dup_phone_payload,
            headers=headers,
            timeout=TIMEOUT,
        )
        assert duplicate_phone_resp.status_code == 422, f"Expected 422 for duplicate phone, got {duplicate_phone_resp.status_code}"

    finally:
        # Cleanup created customers
        delete_customer(token, customer_id)
        delete_customer(token, dup_customer_id)

test_customers_update_api()