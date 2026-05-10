import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
CUSTOMERS_ENDPOINT = "/api/customers"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_customers_get_api():
    session = requests.Session()
    # Authenticate and get token
    try:
        login_resp = session.post(
            BASE_URL + LOGIN_ENDPOINT,
            json={"email": EMAIL, "password": PASSWORD},
            timeout=TIMEOUT,
        )
        assert login_resp.status_code == 200, "Login failed"
        token = login_resp.json().get("token") or login_resp.json().get("access_token")
        assert token, "No token in login response"
        headers = {"Authorization": f"Bearer {token}"}

        # Create a new customer to test retrieval
        customer_data = {
            "name": "Test Customer TC055",
            "phone": "05555555555",
            "email": "tc055_customer@example.com"
        }
        create_resp = session.post(
            BASE_URL + CUSTOMERS_ENDPOINT,
            json=customer_data,
            headers=headers,
            timeout=TIMEOUT,
        )
        assert create_resp.status_code == 201, f"Customer creation failed: {create_resp.text}"
        created_customer = create_resp.json()
        customer_id = created_customer.get("id")
        assert customer_id, "Created customer ID not returned"

        try:
            # GET /api/customers/{id} - verify customer data & presence of loyalty_balance & purchase_count
            get_resp = session.get(
                f"{BASE_URL}{CUSTOMERS_ENDPOINT}/{customer_id}",
                headers=headers,
                timeout=TIMEOUT,
            )
            assert get_resp.status_code == 200, f"Failed to get customer {customer_id}"
            data = get_resp.json()
            # Validate essential fields exist
            assert data.get("id") == customer_id, "Returned customer ID mismatch"
            assert data.get("name") == customer_data["name"], "Returned customer name mismatch"
            assert "loyalty_balance" in data, "Missing loyalty_balance in customer data"
            assert "purchase_count" in data, "Missing purchase_count in customer data"
            # Validate loyalty_balance and purchase_count are numbers (could be int or float)
            assert isinstance(data["loyalty_balance"], (int, float)), "loyalty_balance not numeric"
            assert isinstance(data["purchase_count"], (int, float)), "purchase_count not numeric"

            # Test 404 for unknown ID (use a high unlikely ID)
            unknown_id = "00000000-0000-0000-0000-000000000000"
            unknown_resp = session.get(
                f"{BASE_URL}{CUSTOMERS_ENDPOINT}/{unknown_id}",
                headers=headers,
                timeout=TIMEOUT,
            )
            assert unknown_resp.status_code == 404, f"Expected 404 for unknown customer ID, got {unknown_resp.status_code}"

        finally:
            # Clean up: delete the created customer
            del_resp = session.delete(
                f"{BASE_URL}{CUSTOMERS_ENDPOINT}/{customer_id}",
                headers=headers,
                timeout=TIMEOUT,
            )
            # 204 No Content is typical for delete success, else 200 OK
            assert del_resp.status_code in (200, 204), f"Failed to delete customer {customer_id}"
    finally:
        session.close()


test_customers_get_api()