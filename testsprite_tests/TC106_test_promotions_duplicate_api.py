import requests

BASE_URL = "http://localhost:8080"
LOGIN_URL = f"{BASE_URL}/api/auth/login"
PROMOTIONS_URL = f"{BASE_URL}/api/promotions"

EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_promotions_duplicate_api():
    # Authenticate and get token
    login_payload = {"email": EMAIL, "password": PASSWORD}
    login_resp = requests.post(LOGIN_URL, json=login_payload, timeout=TIMEOUT)
    assert login_resp.status_code == 200, f"Login failed: {login_resp.text}"
    token = login_resp.json().get("access_token") or login_resp.json().get("token") or login_resp.json().get("accessToken")
    assert token, "No access token in login response"

    headers = {"Authorization": f"Bearer {token}"}

    # Create a new promotion to duplicate
    # Assuming minimal required fields for promotion creation from test plan and PRD:
    # name, type, value, starts_at, ends_at
    import datetime
    from datetime import timezone

    now = datetime.datetime.now(timezone.utc)
    starts_at = now.isoformat()
    ends_at = (now + datetime.timedelta(days=1)).isoformat()

    create_payload = {
        "name": "Test Promotion Duplicate API",
        "type": "percentage",  # common promotion type
        "value": 10,
        "starts_at": starts_at,
        "ends_at": ends_at
    }

    promotion_id = None
    duplicated_promotion_id = None
    try:
        create_resp = requests.post(PROMOTIONS_URL, json=create_payload, headers=headers, timeout=TIMEOUT)
        assert create_resp.status_code == 201, f"Failed to create promotion: {create_resp.text}"
        created_promotion = create_resp.json()
        promotion_id = created_promotion.get("id")
        assert promotion_id, "Created promotion has no ID"

        # Duplicate the promotion
        duplicate_url = f"{PROMOTIONS_URL}/{promotion_id}/duplicate"
        duplicate_resp = requests.post(duplicate_url, headers=headers, timeout=TIMEOUT)
        assert duplicate_resp.status_code == 201, f"Failed to duplicate promotion: {duplicate_resp.text}"
        duplicate_data = duplicate_resp.json()
        duplicated_promotion_id = duplicate_data.get("id")
        assert duplicated_promotion_id, "Duplicated promotion response missing new ID"
        assert duplicated_promotion_id != promotion_id, "Duplicated promotion ID should be different from original"

    finally:
        # Cleanup: delete created promotions if possible
        headers_del = headers.copy()
        if duplicated_promotion_id:
            requests.delete(f"{PROMOTIONS_URL}/{duplicated_promotion_id}", headers=headers_del, timeout=TIMEOUT)
        if promotion_id:
            requests.delete(f"{PROMOTIONS_URL}/{promotion_id}", headers=headers_del, timeout=TIMEOUT)


test_promotions_duplicate_api()