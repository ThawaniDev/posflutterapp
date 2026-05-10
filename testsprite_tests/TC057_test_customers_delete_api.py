import requests

BASE_URL = "http://localhost:8080"
LOGIN_URL = f"{BASE_URL}/api/auth/login"
CUSTOMERS_URL = f"{BASE_URL}/api/customers"

EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_customers_delete_api():
    session = requests.Session()
    token = None
    customer_id = None
    headers = {}

    # Authenticate and get token
    try:
        resp = session.post(
            LOGIN_URL,
            json={"email": EMAIL, "password": PASSWORD},
            timeout=TIMEOUT
        )
        assert resp.status_code == 200, f"Login failed: {resp.text}"
        data = resp.json()
        token = data.get("token") or data.get("access_token")
        assert token, "Authorization token missing in login response"
        headers = {
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json",
            "Accept": "application/json",
        }

        # Create a new customer to delete
        customer_data = {
            "name": "Test Delete Customer",
            "phone": "5550001234",
            "email": "test.delete.customer@example.com"
        }
        create_resp = session.post(
            CUSTOMERS_URL,
            json=customer_data,
            headers=headers,
            timeout=TIMEOUT
        )
        assert create_resp.status_code == 201, f"Customer creation failed: {create_resp.text}"
        created_customer = create_resp.json()
        customer_id = created_customer.get("id")
        assert customer_id, "Created customer ID missing"

        # Delete the created customer
        delete_resp = session.delete(
            f"{CUSTOMERS_URL}/{customer_id}",
            headers=headers,
            timeout=TIMEOUT
        )
        assert delete_resp.status_code == 204, f"Customer deletion failed: {delete_resp.text}"

        # Verify deleting same customer again returns 404
        delete_again_resp = session.delete(
            f"{CUSTOMERS_URL}/{customer_id}",
            headers=headers,
            timeout=TIMEOUT
        )
        assert delete_again_resp.status_code == 404, f"Expected 404 on deleting unknown customer, got {delete_again_resp.status_code}"

        # Verify deleting unknown random ID returns 404
        unknown_id = "00000000-0000-0000-0000-000000000000"
        delete_unknown_resp = session.delete(
            f"{CUSTOMERS_URL}/{unknown_id}",
            headers=headers,
            timeout=TIMEOUT
        )
        assert delete_unknown_resp.status_code == 404, f"Expected 404 for unknown customer ID, got {delete_unknown_resp.status_code}"

    finally:
        # Cleanup in case customer was created but not deleted
        if customer_id:
            session.delete(
                f"{CUSTOMERS_URL}/{customer_id}",
                headers=headers,
                timeout=TIMEOUT
            )


test_customers_delete_api()