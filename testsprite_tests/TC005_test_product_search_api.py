import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
PRODUCT_SEARCH_ENDPOINT = "/api/products/search"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_product_search_api():
    try:
        # Step 1: Authenticate and get Bearer token
        login_payload = {"email": EMAIL, "password": PASSWORD}
        login_resp = requests.post(
            f"{BASE_URL}{LOGIN_ENDPOINT}",
            json=login_payload,
            timeout=TIMEOUT,
        )
        assert login_resp.status_code == 200, "Login failed"
        login_data = login_resp.json()
        token = login_data.get("token") or login_data.get("access_token")
        assert token, "Token not found in login response"
        headers = {"Authorization": f"Bearer {token}"}

        # Step 2: Make product search queries by barcode, name, and SKU
        queries = [
            {"barcode": "1234567890123"},
            {"q": "Test Product Name"},
            {"sku": "SKU12345"},
        ]

        for query_params in queries:
            resp = requests.get(
                f"{BASE_URL}{PRODUCT_SEARCH_ENDPOINT}",
                headers=headers,
                params=query_params,
                timeout=TIMEOUT,
            )
            assert resp.status_code == 200, f"Search failed for params {query_params}"
            results = resp.json()
            assert isinstance(results, list), "Expected results to be a list"

            # Validate that each result matches the query criteria when possible
            for product in results:
                assert isinstance(product, dict), "Each product should be a dict"

                if "barcode" in query_params:
                    product_barcode = product.get("barcode")
                    assert (
                        product_barcode == query_params["barcode"]
                    ), f"Product barcode mismatch, expected {query_params['barcode']}, got {product_barcode}"

                if "q" in query_params:
                    product_name = product.get("name") or product.get("product_name") or ""
                    assert query_params["q"].lower() in product_name.lower(), (
                        f"Product name does not contain query '{query_params['q']}', got '{product_name}'"
                    )

                if "sku" in query_params:
                    product_sku = product.get("sku")
                    assert (
                        product_sku == query_params["sku"]
                    ), f"Product SKU mismatch, expected {query_params['sku']}, got {product_sku}"

            # If no results found, that's acceptable (empty list)
            assert results is not None

        # Step 3: Test with an invalid barcode (expect empty result)
        invalid_query = {"barcode": "0000000000000"}
        resp = requests.get(
            f"{BASE_URL}{PRODUCT_SEARCH_ENDPOINT}",
            headers=headers,
            params=invalid_query,
            timeout=TIMEOUT,
        )
        assert resp.status_code == 200, "Search request failed for invalid barcode"
        results = resp.json()
        assert isinstance(results, list), "Expected list for invalid barcode search"
        assert len(results) == 0, "Expected no results for unknown barcode"

    except requests.RequestException as e:
        assert False, f"Request exception occurred: {e}"


test_product_search_api()