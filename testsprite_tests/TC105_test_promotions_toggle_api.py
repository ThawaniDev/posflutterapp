import requests
import pytest

BASE_URL = "http://localhost:8080"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30

def test_promotions_toggle_api():
    session = requests.Session()
    try:
        # Authenticate and get token
        auth_resp = session.post(
            f"{BASE_URL}/api/auth/login",
            json={"email": EMAIL, "password": PASSWORD},
            timeout=TIMEOUT
        )
        assert auth_resp.status_code == 200, f"Login failed: {auth_resp.text}"
        token = auth_resp.json().get("token")
        assert token, "No token in login response"

        headers = {"Authorization": f"Bearer {token}"}

        # Fetch promotions list to get an existing promotion ID
        promos_resp = session.get(f"{BASE_URL}/api/promotions", headers=headers, timeout=TIMEOUT)
        assert promos_resp.status_code == 200, f"Failed to get promotions list: {promos_resp.text}"
        promotions = promos_resp.json()
        assert isinstance(promotions, list), f"Promotions response not list: {promotions}"
        # Find any promotion, else create one
        promotion_id = None
        original_is_active = None

        if promotions:
            promotion = promotions[0]
            promotion_id = promotion.get("id")
            original_is_active = promotion.get("is_active")
            assert promotion_id is not None, "Promotion has no id"
            assert isinstance(original_is_active, bool), "Promotion is_active not boolean"
        else:
            # Create a new promotion for test
            from datetime import datetime, timedelta
            now = datetime.utcnow()
            starts_at = now.isoformat() + "Z"
            ends_at = (now + timedelta(days=1)).isoformat() + "Z"
            create_body = {
                "name": "Test Toggle Promotion",
                "type": "percentage",
                "value": 10,
                "starts_at": starts_at,
                "ends_at": ends_at,
                "is_active": True
            }
            create_resp = session.post(f"{BASE_URL}/api/promotions", headers=headers, json=create_body, timeout=TIMEOUT)
            assert create_resp.status_code == 201, f"Failed to create promotion: {create_resp.text}"
            created_promo = create_resp.json()
            promotion_id = created_promo.get("id")
            original_is_active = created_promo.get("is_active")
            assert promotion_id is not None, "Created promotion has no id"
            assert isinstance(original_is_active, bool), "Created promotion is_active not boolean"

        toggle_url = f"{BASE_URL}/api/promotions/{promotion_id}/toggle"

        # Call toggle once
        toggle_resp_1 = session.post(toggle_url, headers=headers, timeout=TIMEOUT)
        assert toggle_resp_1.status_code == 200, f"Toggle first call failed: {toggle_resp_1.text}"
        toggled_promo_1 = toggle_resp_1.json()
        assert "is_active" in toggled_promo_1, "is_active missing in first toggle response"
        assert toggled_promo_1["is_active"] == (not original_is_active), "First toggle did not change is_active"

        # Call toggle second time to restore original state
        toggle_resp_2 = session.post(toggle_url, headers=headers, timeout=TIMEOUT)
        assert toggle_resp_2.status_code == 200, f"Toggle second call failed: {toggle_resp_2.text}"
        toggled_promo_2 = toggle_resp_2.json()
        assert "is_active" in toggled_promo_2, "is_active missing in second toggle response"
        assert toggled_promo_2["is_active"] == original_is_active, "Second toggle did not restore original is_active"

    finally:
        # Cleanup: delete the created promotion if we created one
        if promotions == [] and promotion_id is not None:
            # Delete the created promotion
            del_resp = session.delete(f"{BASE_URL}/api/promotions/{promotion_id}", headers=headers, timeout=TIMEOUT)
            assert del_resp.status_code == 200 or del_resp.status_code == 204, f"Failed to delete created promotion: {del_resp.text}"

test_promotions_toggle_api()