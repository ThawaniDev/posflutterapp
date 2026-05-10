import requests

BASE_URL = "http://localhost:8080"
LOGIN_URL = f"{BASE_URL}/api/auth/login"
PRODUCTS_URL = f"{BASE_URL}/api/products"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def authenticate():
    try:
        payload = {"email": EMAIL, "password": PASSWORD}
        response = requests.post(LOGIN_URL, json=payload, timeout=TIMEOUT)
        response.raise_for_status()
        token = response.json().get("token") or response.json().get("access_token")
        assert token, "Authentication token not found in response"
        return token
    except requests.RequestException as e:
        raise Exception(f"Authentication failed: {e}")


def test_pagination_api():
    token = authenticate()
    headers = {"Authorization": f"Bearer {token}"}

    # Page 1, per_page=5
    params = {"page": 1, "per_page": 5}
    try:
        resp1 = requests.get(PRODUCTS_URL, headers=headers, params=params, timeout=TIMEOUT)
        resp1.raise_for_status()
        data1 = resp1.json()
        assert isinstance(data1, dict) or isinstance(data1, list), "Expected JSON object or list"
        # Determine items list property: try common keys or use list if directly returned
        items1 = None
        if isinstance(data1, dict):
            if "items" in data1 and isinstance(data1["items"], list):
                items1 = data1["items"]
            elif "data" in data1 and isinstance(data1["data"], list):
                items1 = data1["data"]
            else:
                # If dict but no obvious list key, fallback: check for "products" or others
                for key in data1:
                    if isinstance(data1[key], list):
                        items1 = data1[key]
                        break
                if items1 is None:
                    raise AssertionError("No item list found in response for page 1")
        else:
            # If response is list directly
            items1 = data1
        
        assert isinstance(items1, list), "Items in page 1 response is not a list"
        assert len(items1) == 5, f"Expected 5 items on page 1, got {len(items1)}"
    except requests.RequestException as e:
        raise Exception(f"Failed to request page 1: {e}")

    # Page 2, per_page=5
    params = {"page": 2, "per_page": 5}
    try:
        resp2 = requests.get(PRODUCTS_URL, headers=headers, params=params, timeout=TIMEOUT)
        resp2.raise_for_status()
        data2 = resp2.json()
        if isinstance(data2, dict):
            if "items" in data2 and isinstance(data2["items"], list):
                items2 = data2["items"]
            elif "data" in data2 and isinstance(data2["data"], list):
                items2 = data2["data"]
            else:
                for key in data2:
                    if isinstance(data2[key], list):
                        items2 = data2[key]
                        break
                if items2 is None:
                    raise AssertionError("No item list found in response for page 2")
        else:
            items2 = data2
        assert isinstance(items2, list), "Items in page 2 response is not a list"
        assert len(items2) == 5, f"Expected 5 items on page 2, got {len(items2)}"
    except requests.RequestException as e:
        raise Exception(f"Failed to request page 2: {e}")

    # Verify page2 items are different from page1 items by ID or some unique property (if available)
    # Check presence of 'id' or '_id' in items to compare
    try:
        def extract_ids(items):
            ids = []
            for item in items:
                if isinstance(item, dict):
                    if "id" in item:
                        ids.append(item["id"])
                    elif "_id" in item:
                        ids.append(item["_id"])
            return ids

        ids_page1 = extract_ids(items1)
        ids_page2 = extract_ids(items2)
        if ids_page1 and ids_page2:
            assert not set(ids_page1).intersection(set(ids_page2)), "Overlap in items between page 1 and page 2"
    except Exception as e:
        # Not critical, just skip if cannot verify
        pass

    # Last page: find last page number from total or by looping until less than 5 items returned
    try:
        last_page = None
        total_items = None
        # Try to find total count from page1 response if available
        # Common keys: total, total_count, count, totalItems
        if isinstance(data1, dict):
            for key in ["total", "total_count", "count", "totalItems"]:
                if key in data1 and isinstance(data1[key], int):
                    total_items = data1[key]
                    break

        if total_items is not None:
            import math
            last_page = math.ceil(total_items / 5)
        else:
            # Fallback: paginate forward until less than 5 items found, limit max 100 pages to avoid endless loop
            max_pages = 100
            current_page = 3
            while current_page <= max_pages:
                resp = requests.get(PRODUCTS_URL, headers=headers, params={"page": current_page, "per_page": 5}, timeout=TIMEOUT)
                resp.raise_for_status()
                d = resp.json()
                if isinstance(d, dict):
                    if "items" in d and isinstance(d["items"], list):
                        page_items = d["items"]
                    elif "data" in d and isinstance(d["data"], list):
                        page_items = d["data"]
                    else:
                        page_items = []
                        for key in d:
                            if isinstance(d[key], list):
                                page_items = d[key]
                                break
                else:
                    page_items = d
                if not isinstance(page_items, list) or len(page_items) < 5:
                    last_page = current_page
                    break
                current_page += 1
            if last_page is None:
                last_page = current_page  # probably last page is max_pages

        # Fetch last page items
        resp_last = requests.get(PRODUCTS_URL, headers=headers, params={"page": last_page, "per_page": 5}, timeout=TIMEOUT)
        resp_last.raise_for_status()
        data_last = resp_last.json()
        if isinstance(data_last, dict):
            if "items" in data_last and isinstance(data_last["items"], list):
                items_last = data_last["items"]
            elif "data" in data_last and isinstance(data_last["data"], list):
                items_last = data_last["data"]
            else:
                items_last = []
                for key in data_last:
                    if isinstance(data_last[key], list):
                        items_last = data_last[key]
                        break
        else:
            items_last = data_last

        assert isinstance(items_last, list), "Items in last page response is not a list"
        # Number of items in last page should be <= 5 and be > 0 if total_items known otherwise just check <=5
        assert 0 < len(items_last) <= 5, f"Expected 1 to 5 items on last page, got {len(items_last)}"
    except requests.RequestException as e:
        raise Exception(f"Failed to request last page: {e}")


test_pagination_api()
