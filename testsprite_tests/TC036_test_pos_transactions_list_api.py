import requests
from datetime import datetime, timedelta

BASE_URL = "http://localhost:8080"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
LOGIN_ENDPOINT = "/api/auth/login"
TRANSACTIONS_ENDPOINT = "/api/pos/transactions"
TIMEOUT = 30


def test_pos_transactions_list_api():
    # Authenticate and get token
    login_url = BASE_URL + LOGIN_ENDPOINT
    login_payload = {"email": EMAIL, "password": PASSWORD}
    login_headers = {"Content-Type": "application/json"}

    try:
        login_resp = requests.post(login_url, json=login_payload, headers=login_headers, timeout=TIMEOUT)
        assert login_resp.status_code == 200, f"Login failed: {login_resp.text}"
        token = login_resp.json().get("token") or login_resp.json().get("access_token")
        assert token and token.startswith("Bearer "), "Token missing or malformed in login response"
    except Exception as e:
        raise AssertionError(f"Login request failed: {str(e)}")

    # Strip "Bearer " prefix if present, prepare Authorization header
    if token.startswith("Bearer "):
        token = token[len("Bearer "):]
    auth_headers = {"Authorization": f"Bearer {token}"}

    # Prepare date range filter for the last 7 days
    to_date = datetime.utcnow().date()
    from_date = to_date - timedelta(days=7)
    params = {
        "from_date": from_date.isoformat(),
        "to_date": to_date.isoformat(),
        "page": 1,
        "per_page": 20
    }

    # GET /api/pos/transactions with date range filter
    url = BASE_URL + TRANSACTIONS_ENDPOINT
    try:
        resp = requests.get(url, headers=auth_headers, params=params, timeout=TIMEOUT)
    except Exception as e:
        raise AssertionError(f"GET {TRANSACTIONS_ENDPOINT} request failed: {str(e)}")

    # Validate response status code
    assert resp.status_code == 200, f"Expected status 200, got {resp.status_code}: {resp.text}"

    try:
        data = resp.json()
    except Exception as e:
        raise AssertionError(f"Response is not valid JSON: {str(e)}")

    # Validate paginated structure (commonly keys like data/items, pagination metadata)
    # We allow common keys like 'data', 'items', or 'results' for list of transactions
    transactions = None
    if isinstance(data, dict):
        # Try common paginated keys
        if "data" in data and isinstance(data["data"], list):
            transactions = data["data"]
        elif "items" in data and isinstance(data["items"], list):
            transactions = data["items"]
        elif "results" in data and isinstance(data["results"], list):
            transactions = data["results"]
        elif isinstance(data.get("transactions"), list):
            transactions = data.get("transactions")
        else:
            # If the root is a list, treat as transactions list
            if isinstance(data, list):
                transactions = data
    else:
        if isinstance(data, list):
            transactions = data

    assert transactions is not None, "Response does not contain a list of transactions in expected keys"

    # Assert pagination metadata if present (optional)
    # These keys are common: total, page, per_page, total_pages
    # Check if at least 'page' and 'per_page' exist, else ignore
    for key in ["page", "per_page"]:
        if key in data:
            assert isinstance(data[key], int), f"Pagination field {key} is not int"

    # Validate each transaction includes payment_method and total keys with correct types
    for tx in transactions:
        assert isinstance(tx, dict), "Transaction entry is not an object"
        assert "payment_method" in tx, "Transaction missing 'payment_method'"
        assert isinstance(tx["payment_method"], (str, type(None))), "'payment_method' not string or null"
        assert "total" in tx, "Transaction missing 'total'"
        # total should be a number (int or float)
        assert isinstance(tx["total"], (int, float)), f"'total' is not a number: {tx['total']}"

    # Optionally assert pagination count matches transactions length if present
    if "total" in data:
        assert isinstance(data["total"], int), "'total' pagination field is not int"
        assert data["total"] >= len(transactions), "'total' count is less than returned transactions"


test_pos_transactions_list_api()