import requests


def test_dashboard_recent_orders_api():
    base_url = "http://localhost:8080"
    login_url = f"{base_url}/api/auth/login"
    recent_orders_url = f"{base_url}/api/owner-dashboard/recent-orders"
    auth_payload = {
        "email": "owner@ostora.sa",
        "password": "owner@ostora.sa"
    }
    try:
        # Authenticate and obtain Bearer token
        login_resp = requests.post(login_url, json=auth_payload, timeout=30)
        assert login_resp.status_code == 200, f"Login failed with status {login_resp.status_code}"
        login_json = login_resp.json()
        assert "token" in login_json or "access_token" in login_json, "Auth token missing in login response"
        token = login_json.get("token") or login_json.get("access_token")
        headers = {"Authorization": f"Bearer {token}"}

        # Request recent orders
        recent_orders_resp = requests.get(recent_orders_url, headers=headers, timeout=30)
        assert recent_orders_resp.status_code == 200, f"Recent orders endpoint failed with HTTP {recent_orders_resp.status_code}"
        orders = recent_orders_resp.json()
        assert isinstance(orders, list), "Response should be a list of orders"
        assert len(orders) <= 10, "Response contains more than 10 orders"

        # Validate each order has required fields: status and total
        for order in orders:
            assert "status" in order, "Order missing 'status' field"
            assert isinstance(order["status"], (str, type(None))), "'status' field should be string or null"
            assert "total" in order, "Order missing 'total' field"
            # total could be float or int, valid non-negative number
            assert isinstance(order["total"], (int, float)), "'total' field should be a number"
            assert order["total"] >= 0, "'total' field should be non-negative"

    except requests.RequestException as e:
        assert False, f"Request failed with exception: {e}"


test_dashboard_recent_orders_api()