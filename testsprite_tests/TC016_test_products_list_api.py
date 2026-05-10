import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
PRODUCTS_ENDPOINT = "/api/products"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_products_list_api():
    # Authenticate and get token
    login_url = BASE_URL + LOGIN_ENDPOINT
    login_payload = {"email": EMAIL, "password": PASSWORD}
    try:
        login_response = requests.post(login_url, json=login_payload, timeout=TIMEOUT)
        assert login_response.status_code == 200, f"Login failed: {login_response.text}"
        token = login_response.json().get("token")
        assert token, "No token found in login response"
    except Exception as e:
        assert False, f"Authentication request failed: {e}"

    headers = {
        "Authorization": f"Bearer {token}"
    }

    # 1. Verify GET /api/products returns paginated product list (default page)
    try:
        resp = requests.get(BASE_URL + PRODUCTS_ENDPOINT, headers=headers, timeout=TIMEOUT)
        assert resp.status_code == 200, f"Failed to get products list: {resp.text}"
        data = resp.json()
        # Expecting paginated response: likely keys like 'items', 'page', 'per_page', 'total', or similar
        assert isinstance(data, dict), "Response is not a dictionary"
        # Check keys for pagination or items presence
        # Try common keys to validate presence of product list
        product_list = None
        for key in ('items', 'products', 'data', 'results'):
            if key in data and isinstance(data[key], list):
                product_list = data[key]
                break
        # If not found typical keys, check if top-level list
        if product_list is None:
            if isinstance(data, list):
                product_list = data
            else:
                product_list = None

        assert product_list is not None, "Product list not found in response"
        assert isinstance(product_list, list), "Product list is not a list"
        # Check at least one product or empty list allowed
        # For each product check expected minimal fields: id, name, category_id, is_active
        for product in product_list[:5]:
            assert "id" in product, "Product missing id"
            assert "name" in product or "name_en" in product or "name_ar" in product, "Product missing name"
            # category_id may be nullable but should exist as key at least
            assert "category_id" in product or "category" in product, "Product missing category info"
            assert "is_active" in product or "active" in product, "Product missing is_active status"
        # Pagination info check
        pagination_keys = ["page", "per_page", "total", "total_pages"]
        pagination_found = any(key in data for key in pagination_keys)
        assert pagination_found, "Pagination info keys not found in response"

    except Exception as e:
        assert False, f"Error testing product list pagination: {e}"

    # 2. Test filtering by category_id
    # We attempt to fetch category_id from first product and filter by it
    category_id = None
    if product_list and len(product_list) > 0:
        first_product = product_list[0]
        category_id = first_product.get("category_id") or (first_product.get("category") and first_product["category"].get("id"))
    if not category_id:
        # If no category_id found for filtering, skip filtering test for category_id
        pass
    else:
        try:
            params = {"category_id": category_id}
            resp = requests.get(BASE_URL + PRODUCTS_ENDPOINT, headers=headers, params=params, timeout=TIMEOUT)
            assert resp.status_code == 200, f"Filtering by category_id failed: {resp.text}"
            filtered_data = resp.json()
            filtered_products = None
            for key in ('items', 'products', 'data', 'results'):
                if key in filtered_data and isinstance(filtered_data[key], list):
                    filtered_products = filtered_data[key]
                    break
            if filtered_products is None:
                if isinstance(filtered_data, list):
                    filtered_products = filtered_data
                else:
                    filtered_products = None

            assert filtered_products is not None, "Filtered product list not found"
            assert isinstance(filtered_products, list), "Filtered product list is not a list"

            # Check all products belong to the filter category
            for p in filtered_products:
                p_cat_id = p.get("category_id") or (p.get("category") and p["category"].get("id"))
                assert p_cat_id == category_id, f"Product category_id {p_cat_id} does not match filter {category_id}"
        except Exception as e:
            assert False, f"Error testing filtering by category_id: {e}"

    # 3. Test filtering by search query
    # Use name or SKU of first product for search query
    search_term = None
    if product_list and len(product_list) > 0:
        first_product = product_list[0]
        # Use name or SKU; try keys that could contain name or sku
        if "name" in first_product:
            search_term = first_product["name"]
        elif "name_en" in first_product:
            search_term = first_product["name_en"]
        elif "name_ar" in first_product:
            search_term = first_product["name_ar"]
        elif "sku" in first_product:
            search_term = first_product["sku"]
        else:
            # No suitable search field, skip search test
            search_term = None

    if search_term:
        try:
            params = {"search": search_term}
            resp = requests.get(BASE_URL + PRODUCTS_ENDPOINT, headers=headers, params=params, timeout=TIMEOUT)
            assert resp.status_code == 200, f"Filtering by search query failed: {resp.text}"
            search_data = resp.json()
            searched_products = None
            for key in ('items', 'products', 'data', 'results'):
                if key in search_data and isinstance(search_data[key], list):
                    searched_products = search_data[key]
                    break
            if searched_products is None:
                if isinstance(search_data, list):
                    searched_products = search_data
                else:
                    searched_products = None

            assert searched_products is not None, "Search product list not found"
            assert isinstance(searched_products, list), "Search product list is not a list"

            # Check if returned products contain search_term in name or SKU (case-insensitive)
            term_lower = search_term.lower()
            for p in searched_products:
                names = []
                if "name" in p:
                    names.append(p["name"])
                if "name_en" in p:
                    names.append(p["name_en"])
                if "name_ar" in p:
                    names.append(p["name_ar"])
                sku = p.get("sku", "")
                combined_fields = " ".join(names).lower() + " " + str(sku).lower()
                assert term_lower in combined_fields, f"Product does not match search term: {p}"
        except Exception as e:
            assert False, f"Error testing filtering by search query: {e}"

    # 4. Test filtering by is_active
    try:
        params = {"is_active": "true"}
        resp = requests.get(BASE_URL + PRODUCTS_ENDPOINT, headers=headers, params=params, timeout=TIMEOUT)
        assert resp.status_code == 200, f"Filtering by is_active=true failed: {resp.text}"
        active_data = resp.json()
        active_products = None
        for key in ('items', 'products', 'data', 'results'):
            if key in active_data and isinstance(active_data[key], list):
                active_products = active_data[key]
                break
        if active_products is None:
            if isinstance(active_data, list):
                active_products = active_data
            else:
                active_products = None

        assert active_products is not None, "Active product list not found"
        assert isinstance(active_products, list), "Active product list is not a list"

        for p in active_products:
            active_field = p.get("is_active")
            if active_field is None:
                # Sometimes field might be named differently
                active_field = p.get("active")
            assert active_field is True or active_field == "true" or active_field == 1, f"Product is_active filter mismatch: {p}"
    except Exception as e:
        assert False, f"Error testing filtering by is_active: {e}"


test_products_list_api()
