import requests
from datetime import datetime, timedelta

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
PROMOTIONS_ENDPOINT = "/api/promotions"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_promotions_create_api():
    # Authenticate and get token
    login_payload = {"email": EMAIL, "password": PASSWORD}
    login_resp = requests.post(
        BASE_URL + LOGIN_ENDPOINT, json=login_payload, timeout=TIMEOUT
    )
    assert login_resp.status_code == 200, f"Login failed: {login_resp.text}"
    token = login_resp.json().get("token") or login_resp.json().get("access_token")
    assert token, "Auth token not found in login response"

    headers = {"Authorization": f"Bearer {token}", "Content-Type": "application/json"}

    # Prepare valid promotion data
    starts_at = datetime.utcnow() + timedelta(days=1)
    ends_at = starts_at + timedelta(days=10)
    promotion_data = {
        "name": "Test Percentage Promotion",
        "type": "percentage",
        "value": 15,
        "starts_at": starts_at.isoformat() + "Z",
        "ends_at": ends_at.isoformat() + "Z",
    }

    promotion_id = None
    try:
        # Test creating valid promotion
        create_resp = requests.post(
            BASE_URL + PROMOTIONS_ENDPOINT, json=promotion_data, headers=headers, timeout=TIMEOUT
        )
        assert create_resp.status_code == 201, f"Failed to create promotion: {create_resp.text}"
        resp_json = create_resp.json()
        promotion_id = resp_json.get("id") or resp_json.get("_id")
        assert promotion_id is not None, "Promotion ID missing in creation response"
        assert resp_json.get("name") == promotion_data["name"]
        assert resp_json.get("type") == promotion_data["type"]
        assert resp_json.get("value") == promotion_data["value"]
        assert resp_json.get("starts_at") is not None
        assert resp_json.get("ends_at") is not None

        # Test creating promotion with ends_at before starts_at (should return 422)
        invalid_data = promotion_data.copy()
        invalid_data["starts_at"] = (datetime.utcnow() + timedelta(days=10)).isoformat() + "Z"
        invalid_data["ends_at"] = (datetime.utcnow() + timedelta(days=5)).isoformat() + "Z"
        invalid_resp = requests.post(
            BASE_URL + PROMOTIONS_ENDPOINT, json=invalid_data, headers=headers, timeout=TIMEOUT
        )
        assert invalid_resp.status_code == 422, f"Expected 422 for invalid date range, got {invalid_resp.status_code}"
    finally:
        # Cleanup: delete promotion if created
        if promotion_id:
            del_resp = requests.delete(
                f"{BASE_URL}{PROMOTIONS_ENDPOINT}/{promotion_id}",
                headers=headers,
                timeout=TIMEOUT,
            )
            # Allow 200 or 204 or 404 (already deleted)
            assert del_resp.status_code in (200, 204, 404), f"Failed to delete promotion with id {promotion_id}: {del_resp.text}"


test_promotions_create_api()