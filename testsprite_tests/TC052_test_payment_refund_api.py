import requests
import uuid

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
PAYMENTS_ENDPOINT = "/api/payments"
TRANSACTIONS_ENDPOINT = "/api/transactions"

EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30

def authenticate():
    url = BASE_URL + LOGIN_ENDPOINT
    payload = {"email": EMAIL, "password": PASSWORD}
    resp = requests.post(url, json=payload, timeout=TIMEOUT)
    resp.raise_for_status()
    token = resp.json().get("token") or resp.json().get("access_token")
    if not token:
        raise Exception("Authentication token not found in response")
    return token

def create_payment(auth_header):
    # To create a payment, we first create a transaction (sale).
    # POST /api/transactions with minimal valid payload
    url = BASE_URL + TRANSACTIONS_ENDPOINT
    # Construct a minimal cart with one dummy item and payment
    # We attempt to get a product to use for payment amount
    # If product not found, just create dummy payment amount

    # Since no details provided about products, try creating a minimal sale with mocked amounts
    # Let's try to search a product to get price
    product_search_url = BASE_URL + "/api/products"
    products_resp = requests.get(product_search_url, headers=auth_header, timeout=TIMEOUT)
    products_resp.raise_for_status()
    products_data = products_resp.json()
    products_list = []
    if isinstance(products_data, dict) and "data" in products_data:
        products_list = products_data["data"]
    elif isinstance(products_data, list):
        products_list = products_data
    if not products_list:
        raise Exception("No products found to create a payment")
    product = products_list[0]
    product_id = product.get("id") or product.get("product_id") or product.get("_id") or product.get("uuid")
    product_price = product.get("price") or product.get("selling_price") or 10.0

    transaction_payload = {
        "items": [
            {
                "product_id": product_id,
                "quantity": 1
            }
        ],
        "payments": [
            {
                "method": "cash",
                "amount": float(product_price)
            }
        ]
    }
    resp = requests.post(url, json=transaction_payload, headers=auth_header, timeout=TIMEOUT)
    resp.raise_for_status()
    transaction = resp.json()
    payment_id = None
    # Extract payment id from transaction response or from payments list if available
    if isinstance(transaction, dict):
        # Try keys: payments or payment_ids or similar
        if "payments" in transaction and isinstance(transaction["payments"], list) and len(transaction["payments"]) > 0:
            payment_id = transaction["payments"][0].get("id") or transaction["payments"][0].get("payment_id") or transaction["payments"][0].get("_id")
        # If payments top level key absent, maybe transaction id is payment id
        if not payment_id:
            payment_id = transaction.get("id") or transaction.get("payment_id")

    if not payment_id:
        raise Exception("Failed to obtain payment ID after transaction creation")
    return payment_id, float(product_price)

def delete_refund(auth_header, payment_id, refund_id):
    # No explicit DELETE refund endpoint provided, skip if not present
    # Usually refunds aren't deleted but for clean up, ignoring here.
    pass

def test_payment_refund_api():
    token = authenticate()
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }

    # First create a payment via transaction to get a valid payment_id and amount
    payment_id = None
    payment_amount = None
    try:
        payment_id, payment_amount = create_payment(headers)

        refund_url = f"{BASE_URL}{PAYMENTS_ENDPOINT}/{payment_id}/refunds"

        # 1. Test creating a valid refund for part of the payment amount
        valid_refund_amount = round(payment_amount / 2, 2)
        refund_payload = {
            "amount": valid_refund_amount,
            "reason": "Customer returned item"
        }
        resp = requests.post(refund_url, json=refund_payload, headers=headers, timeout=TIMEOUT)
        assert resp.status_code == 201 or resp.status_code == 200, f"Expected 200 or 201 but got {resp.status_code}"
        refund_resp = resp.json()
        assert "id" in refund_resp or "refund_id" in refund_resp, "Refund ID not found in response"
        refunded_amount = refund_resp.get("amount") or refund_resp.get("refund_amount") or valid_refund_amount
        # Validate refunded amount matches requested
        assert abs(refunded_amount - valid_refund_amount) < 0.01, f"Refunded amount mismatch: expected {valid_refund_amount}, got {refunded_amount}"

        refund_id = refund_resp.get("id") or refund_resp.get("refund_id")

        # 2. Test refund exceeding original payment amount results in 422
        excessive_refund_payload = {
            "amount": payment_amount + 1000,
            "reason": "Excessive refund test"
        }
        resp2 = requests.post(refund_url, json=excessive_refund_payload, headers=headers, timeout=TIMEOUT)
        assert resp2.status_code == 422, f"Expected 422 for excessive refund but got {resp2.status_code}"

    finally:
        # No delete refund or payment delete endpoint documented - assume no cleanup needed or possible
        pass

test_payment_refund_api()
