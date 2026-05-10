import requests

BASE_URL = "http://localhost:8080"
LOGIN_URL = f"{BASE_URL}/api/auth/login"
RETURNS_URL = f"{BASE_URL}/api/orders/returns"
ORDERS_URL = f"{BASE_URL}/api/orders"
TIMEOUT = 30
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"


def authenticate():
    response = requests.post(
        LOGIN_URL,
        json={"email": EMAIL, "password": PASSWORD},
        timeout=TIMEOUT,
    )
    response.raise_for_status()
    token = response.json().get("token") or response.json().get("access_token")
    if not token:
        raise ValueError("Auth token not found in login response")
    return token


def create_sample_order(auth_header):
    orders_resp = requests.get(ORDERS_URL, headers=auth_header, timeout=TIMEOUT)
    orders_resp.raise_for_status()
    orders = orders_resp.json()
    if isinstance(orders, dict) and "data" in orders:
        orders_list = orders["data"]
    elif isinstance(orders, list):
        orders_list = orders
    else:
        orders_list = []

    if not orders_list:
        raise RuntimeError("No existing orders available to create return")

    return orders_list[0]


def test_returns_create_api():
    token = authenticate()
    auth_header = {"Authorization": f"Bearer {token}"}

    payload_missing_order_id = {
        "items": [{"product_id": 1, "quantity": 1}],
        "reason": "Customer returned item damaged"
    }
    r = requests.post(RETURNS_URL, json=payload_missing_order_id, headers=auth_header, timeout=TIMEOUT)
    assert r.status_code == 422, f"Expected 422 for missing order_id but got {r.status_code}"
    try:
        error_resp = r.json()
        assert isinstance(error_resp, dict)
    except Exception:
        pass

    order = create_sample_order(auth_header)
    order_id = order.get("id")
    order_items = order.get("items") or order.get("order_items") or []
    if not order_items:
        items_for_return = [{"product_id": 1, "quantity": 1}]
    else:
        first = order_items[0]
        product_id = first.get("product_id") or first.get("id") or first.get("productId")
        quantity = first.get("quantity") or first.get("qty") or 1
        return_qty = 1 if quantity >= 1 else quantity
        items_for_return = [{"product_id": product_id, "quantity": return_qty}]

    payload = {
        "order_id": order_id,
        "items": items_for_return,
        "reason": "Customer returned item damaged"
    }

    response = requests.post(RETURNS_URL, json=payload, headers=auth_header, timeout=TIMEOUT)

    assert response.status_code == 201, f"Expected 201 Created but got {response.status_code}"
    try:
        resp_json = response.json()
    except Exception:
        assert False, "Response is not valid JSON"

    assert "refund_amount" in resp_json, "Response JSON does not contain 'refund_amount'"
    refund_amount = resp_json.get("refund_amount")
    assert isinstance(refund_amount, (int, float)) and refund_amount >= 0, "refund_amount must be non-negative number"


test_returns_create_api()