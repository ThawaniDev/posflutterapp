import requests

BASE_URL = "http://localhost:8080"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30

def test_customer_orders_api():
    session = requests.Session()
    try:
        # Authenticate and get token
        login_resp = session.post(
            f"{BASE_URL}/api/auth/login",
            json={"email": EMAIL, "password": PASSWORD},
            timeout=TIMEOUT,
        )
        assert login_resp.status_code == 200, f"Login failed: {login_resp.text}"
        login_data = login_resp.json()
        token = login_data.get("token") or login_data.get("access_token")
        assert token, "No token received in login response"

        headers = {"Authorization": f"Bearer {token}"}

        # Step 1: Create a new customer to ensure test isolation
        new_customer_data = {
            "name": "Test Customer for Orders API",
            "phone": "0500000000",
            "email": "test_orders_customer@ostora.sa"
        }
        create_cust_resp = session.post(
            f"{BASE_URL}/api/customers",
            json=new_customer_data,
            headers=headers,
            timeout=TIMEOUT,
        )
        assert create_cust_resp.status_code == 201, f"Failed to create customer: {create_cust_resp.text}"
        customer = create_cust_resp.json()
        customer_id = customer.get("id")
        assert customer_id is not None, "Customer ID not present in creation response"

        # Step 2: The customer has no orders initially. Check orders endpoint returns empty list or array.
        orders_resp_initial = session.get(
            f"{BASE_URL}/api/customers/{customer_id}/orders",
            headers=headers,
            timeout=TIMEOUT,
        )
        assert orders_resp_initial.status_code == 200, f"Failed to get customer orders: {orders_resp_initial.text}"
        orders_data_initial = orders_resp_initial.json()
        assert isinstance(orders_data_initial, list), "Orders response is not a list"
        # Likely empty list for new customer, but okay if non-empty if backend adds defaults

        # There is no given schema to create an order directly for this customer in PRD,
        # so we test only GET. If order creation endpoint were known, we could create orders here.
        # For this test, we proceed with the existing orders response.

        # Validate orders structure if any orders present
        for order in orders_data_initial:
            assert "id" in order, "Order missing 'id'"
            assert "status" in order, "Order missing 'status'"
            assert "total" in order or "amount" in order or "order_total" in order or "total_price" in order or "grand_total" in order or "orderAmount" in order or "total_amount" in order or "sum" in order or "totalCost" in order or "totalPrice" in order or "amount_total" in order, "Order missing total field"
            # We can't be certain which exact field name is used for total, so check some common names
            # Accept if at least one total field is present
            if not ("total" in order or "amount" in order or "order_total" in order or "total_price" in order or "grand_total" in order or "orderAmount" in order or "total_amount" in order or "sum" in order or "totalCost" in order or "totalPrice" in order or "amount_total" in order):
                assert False, f"Order {order.get('id')} missing known total field"

        # Optionally check if orders contain line items array
        if orders_data_initial:
            first_order = orders_data_initial[0]
            assert "items" in first_order or "order_items" in first_order or "products" in first_order, "Order missing items list"

    finally:
        # Cleanup: delete the customer created
        if 'customer_id' in locals():
            delete_resp = session.delete(
                f"{BASE_URL}/api/customers/{customer_id}",
                headers=headers,
                timeout=TIMEOUT,
            )
            # Accept both 200 and 204 as success for delete
            assert delete_resp.status_code in [200, 204], f"Failed to delete customer: {delete_resp.text}"

test_customer_orders_api()