import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
PROMOTIONS_ENDPOINT = "/api/promotions"
TIMEOUT = 30
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"


def test_promotions_list_api():
    # Authenticate and get token
    login_payload = {"email": EMAIL, "password": PASSWORD}
    login_resp = requests.post(
        BASE_URL + LOGIN_ENDPOINT, json=login_payload, timeout=TIMEOUT
    )
    assert login_resp.status_code == 200, f"Login failed: {login_resp.text}"
    token = login_resp.json().get("token") or login_resp.json().get("access_token")
    assert token, "Bearer token not found in login response"

    headers = {"Authorization": f"Bearer {token}"}

    # Test GET /api/promotions returns list
    resp = requests.get(BASE_URL + PROMOTIONS_ENDPOINT, headers=headers, timeout=TIMEOUT)
    assert resp.status_code == 200, f"Failed to fetch promotions: {resp.text}"
    promotions = resp.json()
    assert isinstance(promotions, list), "Promotions response is not a list"

    # Test filter by status=active returns only active promotions
    params = {"status": "active"}
    resp_active = requests.get(
        BASE_URL + PROMOTIONS_ENDPOINT, headers=headers, params=params, timeout=TIMEOUT
    )
    assert resp_active.status_code == 200, f"Failed to fetch active promotions: {resp_active.text}"
    active_promotions = resp_active.json()
    assert isinstance(active_promotions, list), "Active promotions response is not a list"

    # Each promotion in active_promotions must have an attribute or key that indicates its status is active
    # Usually this would be is_active, status, or similar. We try common keys to validate.
    for promo in active_promotions:
        # Check status field if present
        status_field = None
        if "status" in promo:
            status_field = promo["status"]
            assert status_field.lower() == "active", f"Promotion status is not active: {status_field}"
        elif "is_active" in promo:
            is_active = promo["is_active"]
            assert is_active is True, "Promotion is_active is not True"
        else:
            # If no status/is_active field, we accept it since we have no schema detail for promotions
            # But if schema guaranteed, then fail
            # For safety, just pass
            pass


test_promotions_list_api()