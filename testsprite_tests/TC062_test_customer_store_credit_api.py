import requests
import uuid

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = f"{BASE_URL}/api/auth/login"
CUSTOMERS_ENDPOINT = f"{BASE_URL}/api/customers"

EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"

TIMEOUT = 30


def test_customer_store_credit_api():
    # Authenticate and get token
    login_payload = {"email": EMAIL, "password": PASSWORD}
    try:
        login_resp = requests.post(LOGIN_ENDPOINT, json=login_payload, timeout=TIMEOUT)
        login_resp.raise_for_status()
    except requests.RequestException as e:
        assert False, f"Authentication request failed: {e}"
    login_data = login_resp.json()
    assert "token" in login_data, "Login response missing token"
    token = login_data["token"]
    headers = {"Authorization": f"Bearer {token}"}

    # Create a new customer for testing
    unique_email = f"teststorecredit_{uuid.uuid4().hex[:8]}@example.com"
    customer_payload = {
        "name": "Test Customer Store Credit",
        "phone": f"055{uuid.uuid4().hex[:7]}",
        "email": unique_email
    }
    created_customer_id = None
    try:
        create_resp = requests.post(CUSTOMERS_ENDPOINT, json=customer_payload, headers=headers, timeout=TIMEOUT)
        create_resp.raise_for_status()
        customer_data = create_resp.json()
        assert "id" in customer_data, "Created customer response missing ID"
        created_customer_id = customer_data["id"]

        top_up_endpoint = f"{CUSTOMERS_ENDPOINT}/{created_customer_id}/store-credit/top-up"

        # Test successful credit top-up with positive amount
        amount_positive = 50.0
        top_up_payload = {"amount": amount_positive}
        try:
            top_up_resp = requests.post(top_up_endpoint, json=top_up_payload, headers=headers, timeout=TIMEOUT)
        except requests.RequestException as e:
            assert False, f"Top-up POST request failed: {e}"
        assert top_up_resp.status_code == 200 or top_up_resp.status_code == 201, \
            f"Expected 200 or 201, got {top_up_resp.status_code}"
        top_up_data = top_up_resp.json()
        assert "new_balance" in top_up_data, "Response missing new_balance after top-up"
        assert isinstance(top_up_data["new_balance"], (int, float)), "new_balance is not a number"
        assert top_up_data["new_balance"] >= amount_positive, "new_balance less than top-up amount"

        # Test top-up with zero amount returns 422
        zero_payload = {"amount": 0}
        try:
            zero_resp = requests.post(top_up_endpoint, json=zero_payload, headers=headers, timeout=TIMEOUT)
        except requests.RequestException as e:
            # We expect a response so if request failed, fail test
            assert False, f"Top-up zero amount request failed: {e}"
        assert zero_resp.status_code == 422, f"Expected 422 for zero amount, got {zero_resp.status_code}"

        # Test top-up with negative amount returns 422
        negative_payload = {"amount": -10}
        try:
            negative_resp = requests.post(top_up_endpoint, json=negative_payload, headers=headers, timeout=TIMEOUT)
        except requests.RequestException as e:
            assert False, f"Top-up negative amount request failed: {e}"
        assert negative_resp.status_code == 422, f"Expected 422 for negative amount, got {negative_resp.status_code}"

    finally:
        # Cleanup: Delete the created customer if possible
        if created_customer_id:
            try:
                del_resp = requests.delete(f"{CUSTOMERS_ENDPOINT}/{created_customer_id}", headers=headers, timeout=TIMEOUT)
                # Accept 200, 204 or 404 (already deleted) as okay for cleanup
                assert del_resp.status_code in (200, 204, 404)
            except Exception:
                pass


test_customer_store_credit_api()