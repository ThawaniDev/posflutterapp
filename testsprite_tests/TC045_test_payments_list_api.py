import requests

BASE_URL = "http://localhost:8080"
LOGIN_URL = f"{BASE_URL}/api/auth/login"
PAYMENTS_URL = f"{BASE_URL}/api/payments"

EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_payments_list_api():
    # Authenticate and get bearer token
    auth_payload = {"email": EMAIL, "password": PASSWORD}
    try:
        login_resp = requests.post(LOGIN_URL, json=auth_payload, timeout=TIMEOUT)
        login_resp.raise_for_status()
    except requests.RequestException as e:
        assert False, f"Authentication failed: {e}"

    token = login_resp.json().get("token") or login_resp.json().get("access_token")
    assert token, "No token found in login response"

    headers = {"Authorization": f"Bearer {token}"}

    # Call GET /api/payments
    try:
        resp = requests.get(PAYMENTS_URL, headers=headers, timeout=TIMEOUT)
        resp.raise_for_status()
    except requests.RequestException as e:
        assert False, f"GET /api/payments request failed: {e}"

    data = resp.json()

    # Basic structure: expecting pagination info (like page, per_page, total) and list of payments
    assert isinstance(data, dict), "Response is not a JSON object"

    payments = data.get("data") or data.get("payments") or data.get("results") or data.get("items")
    # Try to find the payments list in common paginated response keys
    if payments is None:
        # If no key matches, maybe response is a list directly
        if isinstance(data, list):
            payments = data
        else:
            assert False, "Payments list not found in response"

    assert isinstance(payments, list), "Payments field is not a list"

    # Check pagination keys if present
    for key in ["total", "page", "per_page", "total_pages"]:
        if key in data:
            assert isinstance(data[key], int), f"Pagination key {key} is not an integer"

    # Validate each payment entry for required fields: amount, method, transaction ID
    for payment in payments:
        assert isinstance(payment, dict), "Payment entry is not a dictionary"
        assert "amount" in payment, "Payment missing 'amount'"
        assert isinstance(payment["amount"], (int, float)), "'amount' should be numeric"
        assert "method" in payment, "Payment missing 'method'"
        assert isinstance(payment["method"], str), "'method' should be a string"
        # Transaction ID keys might be named transaction_id or txn_id or id
        transaction_id = (
            payment.get("transaction_id")
            or payment.get("txn_id")
            or payment.get("id")
        )
        assert transaction_id is not None, "Payment missing transaction ID"


test_payments_list_api()