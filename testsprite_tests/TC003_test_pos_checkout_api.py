import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
TRANSACTIONS_ENDPOINT = "/api/transactions"
PRODUCTS_SEARCH_ENDPOINT = "/api/products/search"
CASH_SESSIONS_ENDPOINT = "/api/cash-sessions"

EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_pos_checkout_api():
    session = requests.Session()

    try:
        # Step 1: Authenticate and obtain Bearer token
        login_resp = session.post(
            BASE_URL + LOGIN_ENDPOINT,
            json={"email": EMAIL, "password": PASSWORD},
            timeout=TIMEOUT,
        )
        assert login_resp.status_code == 200, f"Login failed: {login_resp.text}"
        token = login_resp.json().get("token") or login_resp.json().get("access_token")
        assert token, "Token not found in login response"
        headers = {
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json",
            "Accept": "application/json",
        }

        # Step 2: Ensure active cash session exists (open one if none)
        # Get current cash sessions
        pos_sessions_resp = session.get(
            BASE_URL + CASH_SESSIONS_ENDPOINT, headers=headers, timeout=TIMEOUT
        )
        assert pos_sessions_resp.status_code == 200, f"Failed to get cash sessions: {pos_sessions_resp.text}"
        active_sessions = [
            s for s in pos_sessions_resp.json() if s.get("status") == "open"
        ]
        if active_sessions:
            cash_session_id = active_sessions[0].get("id")
        else:
            # Open a new cash session with default opening cash
            open_cash_session_resp = session.post(
                BASE_URL + CASH_SESSIONS_ENDPOINT,
                json={"opening_cash": 100.0, "denominations": []},
                headers=headers,
                timeout=TIMEOUT,
            )
            assert open_cash_session_resp.status_code in (200, 201), f"Failed to open cash session: {open_cash_session_resp.text}"
            cash_session_id = open_cash_session_resp.json().get("id")
            assert cash_session_id, "Cash session ID missing after opening"

        # Step 3: Search for products to add to cart
        # We'll try to get some products with a general search or by an empty query assuming API supports that
        search_resp = session.get(
            BASE_URL + PRODUCTS_SEARCH_ENDPOINT,
            headers=headers,
            params={"q": "", "limit": 5},
            timeout=TIMEOUT,
        )
        assert search_resp.status_code == 200, f"Product search failed: {search_resp.text}"
        products = search_resp.json()
        assert isinstance(products, list), "Product search result is not a list"
        assert len(products) > 0, "No products found to add to cart"

        # Prepare items for transaction: add 2 items; if products have price, use price; otherwise default price
        items = []
        for prod in products[:2]:
            product_id = prod.get("id") or prod.get("product_id")
            price = prod.get("price") or 10.0
            # Add quantity 1 for simplicity
            items.append({"product_id": product_id, "quantity": 1, "price": price})

        assert len(items) > 0, "No valid products to add to transaction"

        # Step 4: Prepare discounts and payment methods
        # Apply a fixed discount on the total or on one item - e.g. 10% off with manager PIN
        discount = {
            "type": "percentage",  # or "fixed"
            "value": 10,  # 10%
            "manager_pin": "1234"  # A manager PIN for authorization (example)
        }

        # Payment method: cash with amount tendered
        payment = {
            "method": "cash",
            "amount_tendered": 100.0  # Supposing total price <= 100
        }

        # Step 5: Compose transaction payload
        transaction_payload = {
            "items": items,
            "discount": discount,
            "payment": payment,
            "cash_session_id": cash_session_id
        }

        # Step 6: Post the transaction to /api/transactions
        transaction_resp = session.post(
            BASE_URL + TRANSACTIONS_ENDPOINT,
            headers=headers,
            json=transaction_payload,
            timeout=TIMEOUT,
        )
        assert transaction_resp.status_code in (200, 201), f"Transaction failed: {transaction_resp.text}"
        transaction_data = transaction_resp.json()
        transaction_id = transaction_data.get("id") or transaction_data.get("transaction_id")
        assert transaction_id, "Transaction ID not returned in response"

        # Step 7: Validate response contents
        assert transaction_data.get("status") in ("completed", "success", "paid"), f"Unexpected transaction status: {transaction_data.get('status')}"
        assert "receipt" in transaction_data or "confirmation" in transaction_data, "Receipt or confirmation missing in response"
        assert isinstance(transaction_data.get("items"), list), "Transaction items missing or not a list"
        assert len(transaction_data.get("items")) == len(items), "Transaction items count mismatch"

    finally:
        # Cleanup might not apply here as transaction is a record; 
        # but if possible, void or delete transaction could be done here.
        pass  # No deletion endpoint specified for removing a transaction here


test_pos_checkout_api()
