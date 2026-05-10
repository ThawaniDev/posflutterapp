import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
ORDERS_ENDPOINT = "/api/orders"
TIMEOUT = 30

EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"


def test_orders_status_update_api():
    # Authenticate and get token
    login_payload = {"email": EMAIL, "password": PASSWORD}
    login_resp = requests.post(
        BASE_URL + LOGIN_ENDPOINT, json=login_payload, timeout=TIMEOUT
    )
    assert login_resp.status_code == 200, "Login failed"
    token = login_resp.json().get("access_token") or login_resp.json().get("token")
    assert token, "No token received"

    headers = {"Authorization": f"Bearer {token}"}

    # Helper to create a new order for testing
    def create_order():
        # Minimal order creation: Assume POST /api/orders supported with basic required payload
        # No explicit schema was given for creating orders, so we use a minimal valid payload
        # If creation fails, the test will fail.
        order_payload = {
            "items": [
                {
                    "product_id": 1,
                    "quantity": 1
                }
            ],
            "customer_id": None,
            "notes": "Test order for status update"
        }
        # Try POST /api/orders to create a new order
        create_resp = requests.post(
            BASE_URL + ORDERS_ENDPOINT,
            headers=headers,
            json=order_payload,
            timeout=TIMEOUT,
        )
        assert create_resp.status_code == 201, f"Order creation failed: {create_resp.text}"
        return create_resp.json().get("id")

    # Create a new order to update status
    order_id = None
    try:
        order_id = create_order()
        assert order_id, "Failed to get new order ID"

        valid_statuses = ["accepted", "preparing", "ready", "completed"]
        for status in valid_statuses:
            patch_resp = requests.patch(
                f"{BASE_URL}/api/orders/{order_id}",
                headers={**headers, "Content-Type": "application/json"},
                json={"status": status},
                timeout=TIMEOUT,
            )
            assert patch_resp.status_code == 200, f"Failed to update status to '{status}': {patch_resp.text}"
            json_resp = patch_resp.json()
            assert json_resp.get("status") == status, f"Response status mismatch for status '{status}'"

        # Test invalid status value returns 422
        invalid_status = "invalid_status_value_xyz"
        patch_resp_invalid = requests.patch(
            f"{BASE_URL}/api/orders/{order_id}",
            headers={**headers, "Content-Type": "application/json"},
            json={"status": invalid_status},
            timeout=TIMEOUT,
        )
        assert patch_resp_invalid.status_code == 422, f"Invalid status did not return 422: {patch_resp_invalid.status_code} {patch_resp_invalid.text}"

    finally:
        # Cleanup: delete the created order if possible
        if order_id:
            try:
                del_resp = requests.delete(
                    f"{BASE_URL}/api/orders/{order_id}",
                    headers=headers,
                    timeout=TIMEOUT,
                )
                # Accept 200 or 204 as success
                assert del_resp.status_code in (200, 204, 202), f"Failed to delete order: {del_resp.status_code} {del_resp.text}"
            except Exception:
                # Ignore errors in cleanup
                pass


test_orders_status_update_api()