import requests
import uuid

BASE_URL = "http://localhost:8080"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_orders_get_api():
    session = requests.Session()
    # Authenticate and get token
    try:
        auth_resp = session.post(
            f"{BASE_URL}/api/auth/login",
            json={"email": EMAIL, "password": PASSWORD},
            timeout=TIMEOUT,
        )
        assert auth_resp.status_code == 200, f"Auth failed: {auth_resp.text}"
        token = auth_resp.json().get("token") or auth_resp.json().get("access_token")
        assert token, "No token found in auth response"

        headers = {"Authorization": f"Bearer {token}"}

        order_id = None
        # Create an order for testing GET /api/orders/{id}
        # Since no direct POST /api/orders is documented explicitly in PRD,
        # but since it's POS related, try creating a minimal order via POST /api/orders if possible.
        # If not, we can create a generic order via assumed endpoint.

        # As per PRD, order endpoints show PATCH, POST /api/orders/:id/accept/reject but no direct create order endpoint.
        # To create an order, try POST /api/orders with minimal payload:

        create_order_payload = {
            "source": "test",
            "items": [
                {
                    "product_id": None,  # We'll fetch at least one product id to use here
                    "quantity": 1,
                }
            ],
            "status": "new"
        }

        # Fetch a product to use for order items
        products_resp = session.get(f"{BASE_URL}/api/products", headers=headers, timeout=TIMEOUT)
        assert products_resp.status_code == 200, f"Failed to get products: {products_resp.text}"
        products = products_resp.json()
        assert isinstance(products, list) or "data" in products, "Products response format unknown"

        # Adjust if products are paginated or in 'data' wrapper
        if isinstance(products, dict) and "data" in products:
            products_list = products["data"]
        elif isinstance(products, list):
            products_list = products
        else:
            products_list = []

        assert products_list, "No products found to create order item"

        product_id = None
        for product in products_list:
            if isinstance(product, dict) and product.get("id"):
                product_id = product["id"]
                break

        assert product_id is not None, "No valid product id found for order item"

        create_order_payload["items"][0]["product_id"] = product_id

        # Try POST /api/orders - though not specified in PRD, test if accepted
        create_order_response = session.post(
            f"{BASE_URL}/api/orders",
            json=create_order_payload,
            headers=headers,
            timeout=TIMEOUT,
        )

        if create_order_response.status_code not in (200, 201):
            # If order creation is not supported, skip order creation and try to find an existing order via GET /api/orders
            get_orders_resp = session.get(
                f"{BASE_URL}/api/orders",
                headers=headers,
                timeout=TIMEOUT,
            )
            assert get_orders_resp.status_code == 200, f"Failed to list orders: {get_orders_resp.text}"
            orders_list = get_orders_resp.json()
            if isinstance(orders_list, dict) and "data" in orders_list:
                orders_list = orders_list["data"]
            assert isinstance(orders_list, list), "Orders list not valid"

            if not orders_list:
                raise AssertionError("No existing orders found to test GET /api/orders/{id}")
            order_id = orders_list[0].get("id")
            assert order_id is not None, "Order ID missing in order list"
        else:
            order_data = create_order_response.json()
            order_id = order_data.get("id")
            assert order_id is not None, "Order ID missing on created order"

        # Now test GET /api/orders/{id} returns expected details
        get_order_resp = session.get(
            f"{BASE_URL}/api/orders/{order_id}",
            headers=headers,
            timeout=TIMEOUT,
        )
        assert get_order_resp.status_code == 200, f"Failed to get order {order_id}: {get_order_resp.text}"
        order_detail = get_order_resp.json()
        # Check order_detail has id matching and contains items and status
        assert order_detail.get("id") == order_id, "Order ID in response does not match requested ID"
        assert "items" in order_detail and isinstance(order_detail["items"], list), "Order items missing or invalid"
        assert "status" in order_detail, "Order status missing in response"

        # Test unknown ID returns 404
        unknown_id = str(uuid.uuid4())
        unknown_resp = session.get(
            f"{BASE_URL}/api/orders/{unknown_id}",
            headers=headers,
            timeout=TIMEOUT,
        )
        assert unknown_resp.status_code == 404, f"Expected 404 for unknown order id, got {unknown_resp.status_code}"

    finally:
        # Clean up created order if we created one
        if 'order_id' in locals() and order_id:
            # Attempt DELETE /api/orders/{id} if supported to clean up (not documented, so ignore errors)
            try:
                session.delete(
                    f"{BASE_URL}/api/orders/{order_id}",
                    headers=headers,
                    timeout=TIMEOUT,
                )
            except Exception:
                pass


test_orders_get_api()