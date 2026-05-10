import requests
import uuid

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
STOCKTAKES_ENDPOINT = "/api/inventory/stocktakes"
TIMEOUT = 30

EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"


def test_stocktakes_api():
    # Authenticate and get token
    login_payload = {"email": EMAIL, "password": PASSWORD}
    login_resp = requests.post(f"{BASE_URL}{LOGIN_ENDPOINT}", json=login_payload, timeout=TIMEOUT)
    assert login_resp.status_code == 200, f"Login failed: {login_resp.text}"
    token = login_resp.json().get("token")
    assert token and token.startswith("Bearer "), "Invalid token format"
    # Extract raw token string if 'Bearer ' prefix included, else use as is
    if token.startswith("Bearer "):
        token = token[len("Bearer "):]

    headers = {"Authorization": f"Bearer {token}", "Content-Type": "application/json"}

    # Step 1: Verify GET /api/inventory/stocktakes returns a list
    get_resp = requests.get(f"{BASE_URL}{STOCKTAKES_ENDPOINT}", headers=headers, timeout=TIMEOUT)
    assert get_resp.status_code == 200, f"GET stocktakes failed: {get_resp.text}"
    stocktakes = get_resp.json()
    assert isinstance(stocktakes, list), f"Expected list but got {type(stocktakes)}"

    # Step 2: Create a new stocktake with valid store_id
    # Need a valid store_id - try to get from existing stocktakes or create a new stocktake anyway
    # If no existing stocktakes or no store_id available, try to extract store list from stocktakes or skip

    store_id = None
    if stocktakes:
        # Try to find store_id from first stocktake that has it
        for st in stocktakes:
            if isinstance(st, dict) and "store_id" in st and st["store_id"]:
                store_id = st["store_id"]
                break

    # If no store_id found, try to get store_id from the user's stores (if possible)
    if not store_id:
        # Try GET /api/core/stores/mine for user's stores
        stores_resp = requests.get(f"{BASE_URL}/api/core/stores/mine", headers=headers, timeout=TIMEOUT)
        if stores_resp.status_code == 200:
            stores_list = stores_resp.json()
            if isinstance(stores_list, list) and stores_list:
                first_store = stores_list[0]
                store_id = first_store.get("id")

    assert store_id, "No valid store_id found for creating stocktake"

    new_stocktake_payload = {
        "name": f"Test Stocktake {uuid.uuid4().hex[:8]}",
        "store_id": store_id,
        # Additional required fields if any can be added here
    }

    created_stocktake_id = None
    try:
        post_resp = requests.post(f"{BASE_URL}{STOCKTAKES_ENDPOINT}", headers=headers, json=new_stocktake_payload, timeout=TIMEOUT)
        assert post_resp.status_code == 201, f"POST stocktake failed: {post_resp.status_code} {post_resp.text}"
        created_stocktake = post_resp.json()
        assert isinstance(created_stocktake, dict), "Expected dict response for created stocktake"
        created_stocktake_id = created_stocktake.get("id")
        assert created_stocktake_id is not None, "Created stocktake ID missing"
        assert created_stocktake.get("store_id") == store_id, "Created stocktake store_id mismatch"
    finally:
        # Cleanup: Delete the created stocktake if created_stocktake_id available
        if created_stocktake_id:
            requests.delete(f"{BASE_URL}{STOCKTAKES_ENDPOINT}/{created_stocktake_id}", headers=headers, timeout=TIMEOUT)


test_stocktakes_api()