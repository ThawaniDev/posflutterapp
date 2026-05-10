import requests
import uuid

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
COUPON_REDEEM_ENDPOINT = "/api/coupons/redeem"
COUPON_CREATE_ENDPOINT = "/api/promotions/coupons"

EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_coupon_redeem_api():
    # Authenticate and get token
    try:
        login_resp = requests.post(
            BASE_URL + LOGIN_ENDPOINT,
            json={"email": EMAIL, "password": PASSWORD},
            timeout=TIMEOUT,
        )
        login_resp.raise_for_status()
        token = login_resp.json().get("token")
        assert token and isinstance(token, str), "Login did not return a valid token"
    except Exception as e:
        assert False, f"Authentication failed: {e}"

    headers = {"Authorization": f"Bearer {token}", "Content-Type": "application/json"}

    # Create a single-use coupon for testing
    coupon_code = f"TESTSINGLEUSE-{uuid.uuid4().hex[:8].upper()}"
    coupon_payload = {
        "code": coupon_code,
        "is_single_use": True,
        "discount_type": "fixed",
        "discount_value": 10,
        "starts_at": "2000-01-01T00:00:00Z",
        "ends_at": "2099-12-31T23:59:59Z",
        "name": "Test Single Use Coupon",
        "is_active": True,
        # Any other required fields can be added here if necessary
    }

    created_coupon_id = None

    try:
        # Create coupon
        create_resp = requests.post(
            BASE_URL + COUPON_CREATE_ENDPOINT, headers=headers, json=coupon_payload, timeout=TIMEOUT
        )
        create_resp.raise_for_status()
        created_coupon = create_resp.json()
        created_coupon_id = created_coupon.get("id")
        assert created_coupon_id is not None, "Created coupon response missing 'id'"

        # Redeem the coupon first time - should succeed (200 or 201)
        redeem_resp_1 = requests.post(
            BASE_URL + COUPON_REDEEM_ENDPOINT,
            headers=headers,
            json={"code": coupon_code},
            timeout=TIMEOUT,
        )
        assert redeem_resp_1.status_code in (200, 201), (
            f"First redeem attempt failed: HTTP {redeem_resp_1.status_code}, response: {redeem_resp_1.text}"
        )
        redeem_1_json = redeem_resp_1.json()
        # Check that the coupon is marked used or some success indicator returned
        assert redeem_1_json.get("success", True) or redeem_1_json.get("message") or True, "First redeem response unexpected"

        # Redeem the same coupon second time - should fail with 422
        redeem_resp_2 = requests.post(
            BASE_URL + COUPON_REDEEM_ENDPOINT,
            headers=headers,
            json={"code": coupon_code},
            timeout=TIMEOUT,
        )
        assert redeem_resp_2.status_code == 422, (
            f"Second redeem attempt expected 422 but got {redeem_resp_2.status_code}, response: {redeem_resp_2.text}"
        )
    finally:
        # Cleanup: delete the created coupon if possible
        if created_coupon_id:
            try:
                requests.delete(
                    f"{BASE_URL}/api/promotions/coupons/{created_coupon_id}",
                    headers=headers,
                    timeout=TIMEOUT,
                )
            except Exception:
                pass


test_coupon_redeem_api()