import requests
from datetime import datetime, timedelta

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
REPORTS_PRODUCT_SALES_ENDPOINT = "/api/reports/product-sales"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_reports_product_sales_api():
    # Authenticate and get token
    login_payload = {"email": EMAIL, "password": PASSWORD}
    try:
        login_resp = requests.post(
            BASE_URL + LOGIN_ENDPOINT,
            json=login_payload,
            timeout=TIMEOUT
        )
        assert login_resp.status_code == 200, f"Login failed: {login_resp.text}"
        token = login_resp.json().get("token") or login_resp.json().get("access_token") or login_resp.json().get("data", {}).get("token")
        assert token, "Authentication token not found in login response"
    except requests.RequestException as e:
        assert False, f"RequestException during login: {e}"

    headers = {"Authorization": f"Bearer {token}"}

    # Prepare date range: last 7 days
    to_date = datetime.utcnow().date()
    from_date = to_date - timedelta(days=7)

    params = {
        "from_date": from_date.isoformat(),
        "to_date": to_date.isoformat()
    }

    # Call the product sales report endpoint
    try:
        resp = requests.get(
            BASE_URL + REPORTS_PRODUCT_SALES_ENDPOINT,
            headers=headers,
            params=params,
            timeout=TIMEOUT
        )
    except requests.RequestException as e:
        assert False, f"RequestException while fetching product sales report: {e}"

    # Validate response status
    assert resp.status_code == 200, f"Unexpected status code: {resp.status_code} - {resp.text}"

    data = resp.json()
    assert isinstance(data, list), f"Response should be a list, got {type(data)}"

    if data:
        # Validate structure of first item assuming ranked product report structure
        product = data[0]
        assert "product_name" in product or "name" in product, "Reported product missing 'product_name' or 'name'"
        assert "quantity" in product, "Reported product missing 'quantity'"
        assert isinstance(product["quantity"], (int, float)), "'quantity' should be a number"
        assert "revenue" in product, "Reported product missing 'revenue'"
        assert isinstance(product["revenue"], (int, float)), "'revenue' should be a number"

        # Optional: Validate sorting (if ranked by quantity or revenue descending)
        quantities = [item.get("quantity", 0) for item in data if isinstance(item.get("quantity", None), (int, float))]
        assert quantities == sorted(quantities, reverse=True), "Products are not ranked by quantity descending"

    else:
        # If no data returned, ensure valid empty list
        assert data == [], "Expected empty list for date range with no sales"

    print("test_reports_product_sales_api passed.")


test_reports_product_sales_api()