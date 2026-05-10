import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
COUPON_VALIDATE_ENDPOINT = "/api/coupons/validate"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_coupon_validate_api():
    # Authenticate and get token
    login_payload = {"email": EMAIL, "password": PASSWORD}
    login_resp = requests.post(
        BASE_URL + LOGIN_ENDPOINT, json=login_payload, timeout=TIMEOUT
    )
    assert login_resp.status_code == 200, f"Login failed: {login_resp.text}"
    token = login_resp.json().get("token") or login_resp.json().get("access_token")
    assert token, "Auth token missing in login response"
    headers = {"Authorization": f"Bearer {token}"}

    # Test valid coupon code - expect valid=true and discount amount present
    valid_code = "VALID_COUPON_CODE"
    resp_valid = requests.post(
        BASE_URL + COUPON_VALIDATE_ENDPOINT,
        json={"code": valid_code},
        headers=headers,
        timeout=TIMEOUT,
    )
    assert resp_valid.status_code == 200, f"Valid code failed: {resp_valid.text}"
    data_valid = resp_valid.json()
    assert "valid" in data_valid, "Response missing 'valid' field"
    assert data_valid["valid"] is True, "Valid coupon code returned valid != true"
    assert (
        "discount" in data_valid and isinstance(data_valid["discount"], (int, float))
    ), "Valid coupon returned no discount amount"

    # Test expired coupon code - expect valid=false
    expired_code = "EXPIRED_COUPON_CODE"
    resp_expired = requests.post(
        BASE_URL + COUPON_VALIDATE_ENDPOINT,
        json={"code": expired_code},
        headers=headers,
        timeout=TIMEOUT,
    )
    assert resp_expired.status_code == 200, f"Expired code call failed: {resp_expired.text}"
    data_expired = resp_expired.json()
    assert (
        "valid" in data_expired and data_expired["valid"] is False
    ), "Expired coupon code returned valid != false"

    # Test unknown coupon code - expect valid=false
    unknown_code = "UNKNOWN_COUPON_CODE_999999"
    resp_unknown = requests.post(
        BASE_URL + COUPON_VALIDATE_ENDPOINT,
        json={"code": unknown_code},
        headers=headers,
        timeout=TIMEOUT,
    )
    assert resp_unknown.status_code == 200, f"Unknown code call failed: {resp_unknown.text}"
    data_unknown = resp_unknown.json()
    assert (
        "valid" in data_unknown and data_unknown["valid"] is False
    ), "Unknown coupon code returned valid != false"


test_coupon_validate_api()