import requests

BASE_URL = "http://localhost:8080"
LOGIN_URL = f"{BASE_URL}/api/auth/login"
TRANSACTIONS_URL = f"{BASE_URL}/api/transactions"
STOCK_LEVELS_URL = f"{BASE_URL}/api/inventory/stock-levels"

EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_inventory_insufficient_stock_checkout():
    # Authenticate and get token
    try:
        resp = requests.post(
            LOGIN_URL,
            json={"email": EMAIL, "password": PASSWORD},
            timeout=TIMEOUT,
        )
        resp.raise_for_status()
        token = resp.json().get("token")
        assert token, "No token in login response."
    except requests.RequestException as e:
        assert False, f"Authentication failed: {e}"

    headers = {"Authorization": f"Bearer {token}", "Content-Type": "application/json"}

    # Get current stock levels to pick a valid product and exceed its stock
    try:
        resp = requests.get(STOCK_LEVELS_URL, headers=headers, timeout=TIMEOUT)
        resp.raise_for_status()
        stock_data = resp.json()
        assert isinstance(stock_data, list), "Stock levels response is not a list"
        if not stock_data:
            assert False, "No stock data available to test"
    except requests.RequestException as e:
        assert False, f"Failed to get stock levels: {e}"

    # Find a product with quantity available to test insufficient stock
    product = None
    for item in stock_data:
        # Expect item has 'product_id' and 'quantity' or 'available_stock'
        qty = item.get("quantity") or item.get("available_stock") or item.get("stock") or 0
        prod_id = item.get("product_id") or item.get("id")
        if prod_id and qty is not None and qty >= 0:
            product = {"product_id": prod_id, "quantity": qty}
            break

    if not product:
        assert False, "No suitable product found in stock levels to test"

    # Craft transaction items exceeding available stock by +10 (or at least 1 if qty=0)
    exceed_qty = product["quantity"] + 10 if product["quantity"] > 0 else 1

    transaction_payload = {
        "items": [
            {
                "product_id": product["product_id"],
                "quantity": exceed_qty,
                "price": 0  # price field may or may not be required; if required, use 0 or omit
            }
        ],
        # Adding minimal required fields for transaction (if required), else just items
    }

    # Perform the POST to create transaction with quantity exceeding stock, expect 422 and error
    try:
        resp = requests.post(
            TRANSACTIONS_URL, headers=headers, json=transaction_payload, timeout=TIMEOUT
        )
    except requests.RequestException as e:
        assert False, f"Request to create transaction failed: {e}"

    assert resp.status_code == 422, f"Expected 422 status code for insufficient stock, got {resp.status_code}"

    # Validate error response contains out_of_stock error
    try:
        error_resp = resp.json()
    except Exception:
        assert False, "Response is not JSON"

    error_detail = error_resp.get("error") or error_resp.get("errors") or error_resp
    found_out_of_stock = False

    # Out_of_stock error might be a string or in a list or dict of errors:
    if isinstance(error_detail, str):
        found_out_of_stock = "out_of_stock" in error_detail.lower()
    elif isinstance(error_detail, dict):
        # Check if any value contains out_of_stock
        found_out_of_stock = any(
            "out_of_stock" in str(v).lower() for v in error_detail.values()
        )
    elif isinstance(error_detail, list):
        found_out_of_stock = any(
            "out_of_stock" in str(item).lower() for item in error_detail
        )
    else:
        found_out_of_stock = False

    assert found_out_of_stock, f"Error response does not contain 'out_of_stock' error: {error_resp}"


test_inventory_insufficient_stock_checkout()