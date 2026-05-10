import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
STOCK_LEVELS_ENDPOINT = "/api/inventory/stock-levels"

EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_stock_levels_api():
    # Authenticate and get bearer token
    login_payload = {"email": EMAIL, "password": PASSWORD}
    try:
        login_response = requests.post(f"{BASE_URL}{LOGIN_ENDPOINT}", json=login_payload, timeout=TIMEOUT)
        login_response.raise_for_status()
    except requests.RequestException as e:
        assert False, f"Login request failed: {e}"

    login_data = login_response.json()
    token = login_data.get("token") or login_data.get("access_token")
    assert token, "Bearer token not found in login response"

    headers = {"Authorization": f"Bearer {token}"}

    # 1. GET stock-levels without filters, should return stock for all products
    try:
        resp_all = requests.get(f"{BASE_URL}{STOCK_LEVELS_ENDPOINT}", headers=headers, timeout=TIMEOUT)
        resp_all.raise_for_status()
    except requests.RequestException as e:
        assert False, f"GET stock levels (all) failed: {e}"

    all_data = resp_all.json()
    assert isinstance(all_data, list), "Expected list response for stock levels (all)"
    assert len(all_data) > 0, "Stock levels (all) returned empty list"

    # Each item expected to have product info and stock details (check keys)
    sample_item = all_data[0]
    assert isinstance(sample_item, dict), "Stock level item should be a dict"
    assert "product_id" in sample_item or "product" in sample_item, "Missing product info in stock level item"
    assert "stock" in sample_item or "quantity" in sample_item, "Missing stock quantity in item"

    # 2. If any store_id present in the list, test filtering by store_id
    # Extract distinct store_ids from all_data for filtering test
    store_ids = set()
    for item in all_data:
        # stock level might include store/branch or store_id field
        sid = None
        if "store_id" in item:
            sid = item["store_id"]
        elif "branch_id" in item:
            sid = item["branch_id"]
        elif "store" in item and isinstance(item["store"], dict) and "id" in item["store"]:
            sid = item["store"]["id"]
        if sid:
            store_ids.add(sid)
    if store_ids:
        store_id = next(iter(store_ids))
        params = {"store_id": store_id}
        try:
            resp_store = requests.get(f"{BASE_URL}{STOCK_LEVELS_ENDPOINT}", headers=headers, params=params, timeout=TIMEOUT)
            resp_store.raise_for_status()
        except requests.RequestException as e:
            assert False, f"GET stock levels filtered by store_id failed: {e}"

        data_store = resp_store.json()
        assert isinstance(data_store, list), "Expected list response for stock levels filtered by store_id"
        # The returned data items should correspond to the requested store_id (if info available)
        for entry in data_store:
            sid_entry = None
            if "store_id" in entry:
                sid_entry = entry["store_id"]
            elif "branch_id" in entry:
                sid_entry = entry["branch_id"]
            elif "store" in entry and isinstance(entry["store"], dict) and "id" in entry["store"]:
                sid_entry = entry["store"]["id"]
            assert sid_entry == store_id, f"Item store_id {sid_entry} does not match filter {store_id}"

    # 3. Test filter low_stock_only=true returns only low stock items
    params_low_stock = {"low_stock_only": "true"}
    try:
        resp_low = requests.get(f"{BASE_URL}{STOCK_LEVELS_ENDPOINT}", headers=headers, params=params_low_stock, timeout=TIMEOUT)
        resp_low.raise_for_status()
    except requests.RequestException as e:
        assert False, f"GET stock levels filtered by low_stock_only=true failed: {e}"

    data_low = resp_low.json()
    assert isinstance(data_low, list), "Expected list response for stock levels filtered by low_stock_only"

    # Validate each item in data_low has low stock (stock quantity <= low stock threshold if present)
    # Since API schema not explicitly provided for low stock threshold, check that quantity is low or marked low_stock
    for item in data_low:
        # Try these keys: quantity, stock, low_stock (boolean), current_stock
        quantity = item.get("quantity") or item.get("stock") or item.get("current_stock")
        low_stock_flag = item.get("low_stock")
        if low_stock_flag is not None:
            assert low_stock_flag is True, "Item in low_stock_only=true response missing low_stock flag True"
        if quantity is not None:
            assert isinstance(quantity, (int, float)), "Quantity should be numeric"
            # We expect quantity to be low; typically zero or less than some threshold.
            # Cannot assert exact threshold; just assert quantity is numeric and <= some reasonable value (e.g. 10)
            assert quantity <= 10, f"Item quantity {quantity} unexpectedly high in low_stock_only response"


test_stock_levels_api()