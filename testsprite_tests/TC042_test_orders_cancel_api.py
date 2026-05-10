import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
ORDERS_ENDPOINT = "/api/orders"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_orders_cancel_api():
    session = requests.Session()
    try:
        # Authenticate and get token
        login_resp = session.post(
            BASE_URL + LOGIN_ENDPOINT,
            json={"email": EMAIL, "password": PASSWORD},
            timeout=TIMEOUT,
        )
        assert login_resp.status_code == 200, f"Login failed: {login_resp.text}"
        token = login_resp.json().get("token")
        assert token is not None, "Login token not found in response"

        headers = {"Authorization": f"Bearer {token}"}

        # Create a new order for testing cancellation
        # Since no order creation API details provided, assume minimal creation via POST /api/orders if possible
        # If no creation API for orders exposed, try to fetch an existing order with a non-completed status

        # Fetch list of orders with status not completed to find one cancellable
        list_resp = session.get(
            BASE_URL + ORDERS_ENDPOINT + "?status=new",
            headers=headers,
            timeout=TIMEOUT,
        )
        assert list_resp.status_code == 200, f"Failed to list orders: {list_resp.text}"
        orders = list_resp.json()
        order_id_to_cancel = None

        # If no orders in 'new' status, try also 'pending', 'accepted', or create one later if needed
        if isinstance(orders, list) and orders:
            order_id_to_cancel = orders[0].get("id")
        else:
            # As fallback, try status=preparing
            list_resp = session.get(
                BASE_URL + ORDERS_ENDPOINT + "?status=preparing",
                headers=headers,
                timeout=TIMEOUT,
            )
            assert list_resp.status_code == 200, f"Failed to list preparing orders: {list_resp.text}"
            orders = list_resp.json()
            if isinstance(orders, list) and orders:
                order_id_to_cancel = orders[0].get("id")

        if not order_id_to_cancel:
            # No cancellable order found, attempt to create new minimal order if possible
            # Because no order creation details provided, we skip creation and fail test
            raise RuntimeError("No cancellable order found for test")

        # PATCH order status to cancelled
        patch_resp = session.patch(
            f"{BASE_URL}{ORDERS_ENDPOINT}/{order_id_to_cancel}",
            json={"status": "cancelled"},
            headers={**headers, "Content-Type": "application/json"},
            timeout=TIMEOUT,
        )
        assert patch_resp.status_code == 200, f"Failed to cancel order: {patch_resp.text}"
        patch_data = patch_resp.json()
        assert patch_data.get("status") == "cancelled", "Order status was not updated to cancelled"

        # Attempt to cancel an already completed order and expect 422
        # Find a completed order
        completed_resp = session.get(
            BASE_URL + ORDERS_ENDPOINT + "?status=completed",
            headers=headers,
            timeout=TIMEOUT,
        )
        assert completed_resp.status_code == 200, f"Failed to get completed orders: {completed_resp.text}"
        completed_orders = completed_resp.json()
        completed_order_id = None
        if isinstance(completed_orders, list) and completed_orders:
            completed_order_id = completed_orders[0].get("id")
        else:
            # If no completed order found, that test part cannot be done; raise or skip
            raise RuntimeError("No completed order available to test cancelling completed order")

        response_422 = session.patch(
            f"{BASE_URL}{ORDERS_ENDPOINT}/{completed_order_id}",
            json={"status": "cancelled"},
            headers={**headers, "Content-Type": "application/json"},
            timeout=TIMEOUT,
        )
        assert response_422.status_code == 422, (
            f"Expected 422 when cancelling completed order, got {response_422.status_code}: {response_422.text}"
        )

    finally:
        session.close()


test_orders_cancel_api()