import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
ORDERS_ENDPOINT = "/api/orders"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_orders_list_api():
    # Authenticate and get token
    try:
        login_resp = requests.post(
            BASE_URL + LOGIN_ENDPOINT,
            json={"email": EMAIL, "password": PASSWORD},
            timeout=TIMEOUT,
        )
        assert login_resp.status_code == 200, f"Login failed: {login_resp.text}"
        token = login_resp.json().get("token") or login_resp.json().get("access_token")
        assert token, "Auth token not found in login response"
    except Exception as e:
        assert False, f"Exception during login: {e}"

    headers = {"Authorization": f"Bearer {token}"}

    # Test GET /api/orders with status=pending
    try:
        params = {"status": "pending"}
        resp = requests.get(BASE_URL + ORDERS_ENDPOINT, headers=headers, params=params, timeout=TIMEOUT)
        assert resp.status_code == 200, f"Failed to get orders with status=pending: {resp.text}"
        orders = resp.json()
        assert isinstance(orders, list), "Response should be a list"
        for order in orders:
            assert 'status' in order, "Order missing 'status' field"
            assert order['status'].lower() == "pending", f"Order status is not 'pending': {order['status']}"
    except Exception as e:
        assert False, f"Exception testing status=pending filter: {e}"

    # Test GET /api/orders with source=delivery
    try:
        params = {"source": "delivery"}
        resp = requests.get(BASE_URL + ORDERS_ENDPOINT, headers=headers, params=params, timeout=TIMEOUT)
        assert resp.status_code == 200, f"Failed to get orders with source=delivery: {resp.text}"
        orders = resp.json()
        assert isinstance(orders, list), "Response should be a list"
        for order in orders:
            assert 'source' in order, "Order missing 'source' field"
            assert order['source'].lower() == "delivery", f"Order source is not 'delivery': {order['source']}"
    except Exception as e:
        assert False, f"Exception testing source=delivery filter: {e}"


test_orders_list_api()