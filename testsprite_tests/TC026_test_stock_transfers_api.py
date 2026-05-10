import requests

BASE_URL = "http://localhost:8080"
LOGIN_URL = f"{BASE_URL}/api/auth/login"
STOCK_TRANSFERS_URL = f"{BASE_URL}/api/inventory/stock-transfers"
STOCK_LEVELS_URL = f"{BASE_URL}/api/inventory/stock-levels"
TIMEOUT = 30

EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"

def login() -> str:
    resp = requests.post(
        LOGIN_URL,
        json={"email": EMAIL, "password": PASSWORD},
        timeout=TIMEOUT
    )
    assert resp.status_code == 200, f"Login failed with status {resp.status_code}"
    token = resp.json().get("token")
    assert token, "No token in login response"
    return token

def get_branches(token: str):
    headers = {"Authorization": f"Bearer {token}"}
    resp = requests.get(STOCK_LEVELS_URL, headers=headers, timeout=TIMEOUT)
    assert resp.status_code == 200, f"Failed to get stock levels with status {resp.status_code}"
    data = resp.json()
    branches = set()
    if isinstance(data, list):
        for entry in data:
            branch_id = entry.get("store_id") or entry.get("branch_id")
            if branch_id:
                branches.add(branch_id)
    elif isinstance(data, dict) and "data" in data:
        for entry in data["data"]:
            branch_id = entry.get("store_id") or entry.get("branch_id")
            if branch_id:
                branches.add(branch_id)
    assert branches, "No branches found in stock levels response"
    return list(branches)

def create_stock_transfer_payload(source_branch, dest_branch, include_items=True):
    items = []
    if include_items:
        items.append({"product_id": 1, "quantity": 5})
    return {
        "source_branch_id": source_branch,
        "destination_branch_id": dest_branch,
        "items": items
    }

def test_stock_transfers_api():
    token = login()
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }

    branches = get_branches(token)
    assert len(branches) >= 2, "Need at least two branches to test stock transfer"

    source_branch = branches[0]
    dest_branch = branches[1]

    # 1. Test successful stock transfer creation between different branches
    payload = create_stock_transfer_payload(source_branch, dest_branch, include_items=True)
    resp = requests.post(STOCK_TRANSFERS_URL, headers=headers, json=payload, timeout=TIMEOUT)
    assert resp.status_code in (200, 201), f"Expected 201 or 200 but got {resp.status_code}"
    data = resp.json()
    assert "id" in data or "transfer_id" in data, "Response missing transfer id"

    # 2. Test 422 error for same source and destination branches
    payload_same_branch = create_stock_transfer_payload(source_branch, source_branch, include_items=True)
    resp2 = requests.post(STOCK_TRANSFERS_URL, headers=headers, json=payload_same_branch, timeout=TIMEOUT)
    assert resp2.status_code == 422, f"Expected 422 for same source/destination branch but got {resp2.status_code}"

    # 3. Test 422 error for empty items list
    payload_empty_items = create_stock_transfer_payload(source_branch, dest_branch, include_items=False)
    resp3 = requests.post(STOCK_TRANSFERS_URL, headers=headers, json=payload_empty_items, timeout=TIMEOUT)
    assert resp3.status_code == 422, f"Expected 422 for empty items but got {resp3.status_code}"


# Call test function
if __name__ == "__main__":
    test_stock_transfers_api()
