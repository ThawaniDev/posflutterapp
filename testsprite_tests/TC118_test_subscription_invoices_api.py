import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
SUBSCRIPTION_INVOICES_ENDPOINT = "/api/subscription/invoices"

EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30

def test_subscription_invoices_api():
    # Authenticate and get token
    login_url = BASE_URL + LOGIN_ENDPOINT
    login_payload = {"email": EMAIL, "password": PASSWORD}
    try:
        login_resp = requests.post(login_url, json=login_payload, timeout=TIMEOUT)
        login_resp.raise_for_status()
    except requests.RequestException as e:
        assert False, f"Login request failed: {e}"

    login_json = login_resp.json()
    token = login_json.get("token") or login_json.get("access_token")
    assert token is not None, "Authentication token not found in login response"

    headers = {"Authorization": f"Bearer {token}"}
    invoices_url = BASE_URL + SUBSCRIPTION_INVOICES_ENDPOINT
    try:
        resp = requests.get(invoices_url, headers=headers, timeout=TIMEOUT)
        resp.raise_for_status()
    except requests.RequestException as e:
        assert False, f"GET {SUBSCRIPTION_INVOICES_ENDPOINT} request failed: {e}"

    data = resp.json()
    assert isinstance(data, list), "Response should be a list of invoices"

    for invoice in data:
        assert "invoice_date" in invoice, "Invoice missing 'invoice_date'"
        assert "amount" in invoice, "Invoice missing 'amount'"
        assert "status" in invoice, "Invoice missing 'status'"

        # Additional type checks
        invoice_date = invoice["invoice_date"]
        amount = invoice["amount"]
        status = invoice["status"]

        assert isinstance(invoice_date, str), "'invoice_date' should be a string"
        assert isinstance(amount, (int, float)), "'amount' should be a number"
        assert isinstance(status, str), "'status' should be a string"

test_subscription_invoices_api()