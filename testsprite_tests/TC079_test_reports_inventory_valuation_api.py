import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
REPORT_ENDPOINT = "/api/reports/inventory/valuation"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30

def test_reports_inventory_valuation_api():
    # Authenticate and obtain token
    try:
        login_resp = requests.post(
            BASE_URL + LOGIN_ENDPOINT,
            json={"email": EMAIL, "password": PASSWORD},
            timeout=TIMEOUT,
        )
        login_resp.raise_for_status()
        token = login_resp.json().get("token")
        assert token, "Authentication token not found in login response"
    except Exception as e:
        raise AssertionError(f"Authentication failed: {e}")

    headers = {
        "Authorization": f"Bearer {token}",
        "Accept": "application/json",
    }

    # Request inventory valuation report
    try:
        resp = requests.get(
            BASE_URL + REPORT_ENDPOINT,
            headers=headers,
            timeout=TIMEOUT,
        )
        resp.raise_for_status()
    except Exception as e:
        raise AssertionError(f"Failed to get inventory valuation report: {e}")

    report_data = resp.json()
    # Validate top-level keys
    assert isinstance(report_data, dict), "Response is not a JSON object"
    assert "total_value" in report_data, "Missing total_value in response"
    assert "total_units" in report_data, "Missing total_units in response"
    assert "products" in report_data, "Missing products breakdown in response"
    assert isinstance(report_data["products"], list), "products should be a list"

    # Validate total_value and total_units types
    assert isinstance(report_data["total_value"], (int, float)), "total_value should be number"
    assert isinstance(report_data["total_units"], (int, float)), "total_units should be number"

    # Validate each product has expected fields
    for product in report_data["products"]:
        assert isinstance(product, dict), "Each product entry should be an object"
        assert "product_id" in product or "id" in product, "Product missing product_id or id"
        assert "name" in product, "Product missing name"
        assert "value" in product, "Product missing value"
        assert "units" in product, "Product missing units"
        # Validate types
        assert isinstance(product.get("name"), str), "Product name should be string"
        assert isinstance(product.get("value"), (int, float)), "Product value should be number"
        assert isinstance(product.get("units"), (int, float)), "Product units should be number"

test_reports_inventory_valuation_api()