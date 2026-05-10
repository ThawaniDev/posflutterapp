import requests
import uuid

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = f"{BASE_URL}/api/auth/login"
CUSTOMERS_ENDPOINT = f"{BASE_URL}/api/customers"


def test_customer_loyalty_redeem_api():
    timeout = 30

    # Step 1: Authenticate and obtain Bearer token
    auth_payload = {
        "email": "owner@ostora.sa",
        "password": "owner@ostora.sa"
    }
    auth_resp = requests.post(LOGIN_ENDPOINT, json=auth_payload, timeout=timeout)
    assert auth_resp.status_code == 200, f"Login failed: {auth_resp.text}"
    token = auth_resp.json().get("token")
    assert token, "Auth token not found in login response"
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }

    # Helper function to create a customer
    def create_customer():
        unique_suffix = str(uuid.uuid4())[:8]
        new_customer_payload = {
            "name": f"Test Customer {unique_suffix}",
            "phone": f"+9665{unique_suffix[:7].replace('-', '')}0",
            "email": f"test{unique_suffix}@example.com"
        }
        resp = requests.post(CUSTOMERS_ENDPOINT, json=new_customer_payload, headers=headers, timeout=timeout)
        assert resp.status_code == 201, f"Failed to create customer: {resp.text}"
        customer_id = resp.json().get("id")
        assert customer_id, "Customer ID not returned after creation"
        return customer_id

    # Helper function to adjust loyalty points
    def adjust_loyalty(customer_id, points):
        payload = {"points": points}
        res = requests.post(f"{CUSTOMERS_ENDPOINT}/{customer_id}/loyalty/adjust", json=payload, headers=headers, timeout=timeout)
        assert res.status_code == 200, f"Loyalty adjust failed: {res.text}"
        return res.json()

    # Create new customer for testing
    customer_id = create_customer()

    try:
        # Step 2: Adjust loyalty points to a sufficient amount (e.g., 100 points)
        adjust_loyalty(customer_id, 100)

        # Step 3: Redeem loyalty points - success case
        redeem_payload = {"points": 50}
        redeem_resp = requests.post(f"{CUSTOMERS_ENDPOINT}/{customer_id}/loyalty/redeem", json=redeem_payload, headers=headers, timeout=timeout)
        assert redeem_resp.status_code == 200, f"Redeem failed unexpectedly: {redeem_resp.text}"
        redeem_data = redeem_resp.json()
        assert "discount" in redeem_data, "Discount field missing in redeem response"
        assert isinstance(redeem_data["discount"], (int, float)) and redeem_data["discount"] > 0, \
            f"Invalid discount value: {redeem_data.get('discount')}"

        # Step 4: Redeem loyalty points - failure case (insufficient points)
        # Try to redeem more points than remaining (more than 50 points left)
        redeem_payload_insufficient = {"points": 1000}
        redeem_fail_resp = requests.post(f"{CUSTOMERS_ENDPOINT}/{customer_id}/loyalty/redeem", json=redeem_payload_insufficient, headers=headers, timeout=timeout)
        assert redeem_fail_resp.status_code == 422, f"Expected 422 for insufficient points but got {redeem_fail_resp.status_code}"
        error_response = redeem_fail_resp.json()
        assert "error" in error_response or "message" in error_response, "No error message for insufficient points"
    finally:
        # Cleanup: delete created customer
        requests.delete(f"{CUSTOMERS_ENDPOINT}/{customer_id}", headers=headers, timeout=timeout)


test_customer_loyalty_redeem_api()