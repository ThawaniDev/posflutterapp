import requests

BASE_URL = "http://localhost:8080"
AUTH_LOGIN_URL = f"{BASE_URL}/api/auth/login"
TRANSACTIONS_URL = f"{BASE_URL}/api/transactions"

EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_void_transaction_api():
    # Authenticate and get token
    try:
        auth_response = requests.post(
            AUTH_LOGIN_URL,
            json={"email": EMAIL, "password": PASSWORD},
            timeout=TIMEOUT,
        )
        assert auth_response.status_code == 200, "Login failed"
        token = auth_response.json().get("token")
        assert token, "No token received in login response"
    except Exception as e:
        raise Exception(f"Authentication failed: {e}")

    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json",
    }

    # Create a new transaction to void
    transaction_id = None
    try:
        # Minimal transaction creation payload (example)
        # The PRD does not specify exact fields; let's add one item with quantity and payment for a valid transaction.
        transaction_payload = {
            "items": [
                {
                    "product_id": 1,  # Assumed existing product_id=1; alternative is to fetch products if needed.
                    "quantity": 1,
                    "price": 1.00,
                    "total": 1.00,
                }
            ],
            "payment": {
                "method": "cash",
                "amount": 1.00,
            }
        }
        create_resp = requests.post(
            TRANSACTIONS_URL, json=transaction_payload, headers=headers, timeout=TIMEOUT
        )
        assert create_resp.status_code == 201, f"Failed to create transaction: {create_resp.text}"
        transaction_data = create_resp.json()
        transaction_id = transaction_data.get("id")
        assert transaction_id, "No transaction ID returned after creation"

        # Void the transaction
        void_url = f"{TRANSACTIONS_URL}/{transaction_id}/void"
        void_resp = requests.post(void_url, headers=headers, timeout=TIMEOUT)
        assert void_resp.status_code == 200, f"Void transaction failed: {void_resp.text}"
        void_data = void_resp.json()

        # Validate the transaction is marked as voided in the response
        # Assuming the status field changes to 'voided' or has an is_void flag
        voided_status = void_data.get("status")
        assert voided_status == "voided" or void_data.get("is_void") is True, "Transaction not marked voided"

    finally:
        # Cleanup: delete the created transaction if it exists (assuming DELETE endpoint exists)
        if transaction_id:
            try:
                del_resp = requests.delete(
                    f"{TRANSACTIONS_URL}/{transaction_id}",
                    headers=headers,
                    timeout=TIMEOUT,
                )
                # Deletion might return 204 No Content or 200 OK
                assert del_resp.status_code in [200, 204], "Failed to delete transaction in cleanup"
            except Exception:
                # Safe to ignore cleanup failure for test
                pass


test_void_transaction_api()