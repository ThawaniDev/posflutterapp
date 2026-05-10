import requests

BASE_URL = "http://localhost:8080"
LOGIN_URL = f"{BASE_URL}/api/auth/login"
PRODUCTS_SEARCH_URL = f"{BASE_URL}/api/products/search"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_products_search_by_barcode():
    # Step 1: Authenticate and get token
    try:
        login_response = requests.post(
            LOGIN_URL,
            json={"email": EMAIL, "password": PASSWORD},
            timeout=TIMEOUT
        )
        assert login_response.status_code == 200, f"Login failed: {login_response.text}"
        token = login_response.json().get("token")
        assert token, "No token found in login response"
        headers = {"Authorization": f"Bearer {token}"}

        # Step 2: Get a known product from product list or create one (to get a known barcode)
        products_list_url = f"{BASE_URL}/api/products"
        list_resp = requests.get(products_list_url, headers=headers, timeout=TIMEOUT)
        assert list_resp.status_code == 200, f"Failed to list products: {list_resp.text}"
        products = list_resp.json()
        assert products and isinstance(products, list), "Products list invalid or empty"

        # Find a product with barcode present
        known_barcode = None
        for p in products:
            if p.get("barcode"):
                known_barcode = p["barcode"]
                known_product_id = p.get("id")
                break
        assert known_barcode is not None, "No product with barcode found to test"

        # Step 3: Test GET /api/products/search?barcode=<known_barcode> returns correct product
        search_resp = requests.get(
            PRODUCTS_SEARCH_URL,
            headers=headers,
            params={"barcode": known_barcode},
            timeout=TIMEOUT
        )
        assert search_resp.status_code == 200, f"Search by known barcode failed: {search_resp.text}"
        search_result = search_resp.json()
        assert isinstance(search_result, list), "Expected search result as list"
        assert len(search_result) >= 1, "Expected at least one product for known barcode"
        product = search_result[0]
        assert product.get("barcode") == known_barcode, "Returned product barcode does not match known barcode"

        # Step 4: Test unknown barcode returns empty array
        unknown_barcode = "00000000000000000000"
        unknown_resp = requests.get(
            PRODUCTS_SEARCH_URL,
            headers=headers,
            params={"barcode": unknown_barcode},
            timeout=TIMEOUT
        )
        assert unknown_resp.status_code == 200, f"Search by unknown barcode failed: {unknown_resp.text}"
        unknown_result = unknown_resp.json()
        assert isinstance(unknown_result, list), "Expected search result as list"
        assert len(unknown_result) == 0, "Expected empty list for unknown barcode"

    except requests.RequestException as e:
        assert False, f"Request failed: {e}"


test_products_search_by_barcode()
