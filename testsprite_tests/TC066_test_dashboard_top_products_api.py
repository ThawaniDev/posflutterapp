import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
TOP_PRODUCTS_ENDPOINT = "/api/owner-dashboard/top-products"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30

def test_dashboard_top_products_api():
    # Authenticate to get Bearer token
    login_payload = {
        "email": EMAIL,
        "password": PASSWORD
    }
    try:
        login_response = requests.post(f"{BASE_URL}{LOGIN_ENDPOINT}", json=login_payload, timeout=TIMEOUT)
        login_response.raise_for_status()
    except requests.RequestException as e:
        assert False, f"Login request failed: {e}"

    data = login_response.json()
    token = data.get("token")
    assert token, "Authentication token not found in login response"

    headers = {
        "Authorization": f"Bearer {token}"
    }

    # Call the endpoint to get top products
    try:
        response = requests.get(f"{BASE_URL}{TOP_PRODUCTS_ENDPOINT}", headers=headers, timeout=TIMEOUT)
        response.raise_for_status()
    except requests.RequestException as e:
        assert False, f"Request to top-products endpoint failed: {e}"

    response_data = response.json()
    assert isinstance(response_data, list), "Response is not a list"

    # Validate that each item contains product_name, quantity_sold, and revenue, and types are correct
    for idx, product in enumerate(response_data):
        assert isinstance(product, dict), f"Product at index {idx} is not a dictionary"
        assert "product_name" in product, f"product_name missing in product at index {idx}"
        assert "quantity_sold" in product, f"quantity_sold missing in product at index {idx}"
        assert "revenue" in product, f"revenue missing in product at index {idx}"
        
        assert isinstance(product["product_name"], str), f"product_name is not a string at index {idx}"
        # quantity_sold should be integer or float but generally int
        assert isinstance(product["quantity_sold"], (int, float)), f"quantity_sold is not a number at index {idx}"
        # revenue should be integer or float
        assert isinstance(product["revenue"], (int, float)), f"revenue is not a number at index {idx}"

    # Optional: Validate that the list is ordered by quantity_sold or revenue descending (typical for ranked list)
    if len(response_data) > 1:
        quantities = [p["quantity_sold"] for p in response_data]
        revenues = [p["revenue"] for p in response_data]
        assert all(quantities[i] >= quantities[i+1] for i in range(len(quantities)-1)) or \
               all(revenues[i] >= revenues[i+1] for i in range(len(revenues)-1)), "List is not ranked by quantity_sold or revenue descending"

test_dashboard_top_products_api()