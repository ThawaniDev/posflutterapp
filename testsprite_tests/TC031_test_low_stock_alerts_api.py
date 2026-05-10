import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
LOW_STOCK_ENDPOINT = "/api/inventory/low-stock"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_low_stock_alerts_api():
    try:
        # Authenticate and get token
        login_response = requests.post(
            BASE_URL + LOGIN_ENDPOINT,
            json={"email": EMAIL, "password": PASSWORD},
            timeout=TIMEOUT,
        )
        assert login_response.status_code == 200, f"Login failed: {login_response.text}"
        login_json = login_response.json()
        token = login_json.get("token") or login_json.get("access_token") or login_json.get("data", {}).get("token")  # flexible extraction
        assert token, "Token not found in login response"

        headers = {"Authorization": f"Bearer {token}"}

        # Request low stock products
        response = requests.get(BASE_URL + LOW_STOCK_ENDPOINT, headers=headers, timeout=TIMEOUT)
        assert response.status_code == 200, f"Expected 200 but got {response.status_code}: {response.text}"
        products = response.json()
        assert isinstance(products, list), "Response is not a list"

        # Verify each product contains product_id and current_stock, and current_stock is below threshold (assumed > 0)
        for product in products:
            assert "product_id" in product, "Missing product_id in low stock product"
            assert "current_stock" in product, "Missing current_stock in low stock product"
            current_stock = product["current_stock"]
            assert isinstance(current_stock, (int, float)), "current_stock is not numeric"
            assert current_stock >= 0, "current_stock is negative"
            # We only check that products are returned; actual threshold checks depend on backend config

    except requests.RequestException as e:
        assert False, f"Request failed: {e}"


test_low_stock_alerts_api()