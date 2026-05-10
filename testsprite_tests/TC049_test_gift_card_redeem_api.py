import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
GIFT_CARD_BALANCE_ENDPOINT = "/api/gift-cards/{code}/balance"
GIFT_CARD_REDEEM_ENDPOINT = "/api/gift-cards/{code}/redeem"

EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30

def login_get_token():
    url = BASE_URL + LOGIN_ENDPOINT
    payload = {"email": EMAIL, "password": PASSWORD}
    resp = requests.post(url, json=payload, timeout=TIMEOUT)
    resp.raise_for_status()
    data = resp.json()
    token = data.get("token") or data.get("access_token")
    if not token:
        raise ValueError("Login response does not contain token")
    return token

def create_gift_card(headers):
    """
    Helper to create a gift card for testing to get a code with known balance.
    If the API does not provide gift card creation in PRD, we fallback to list and pick one.
    """
    # No gift card creation API described in PRD; fall back to getting gift cards list to pick a code.
    # Since test plan doesn't mention an endpoint for listing gift cards explicitly here,
    # we will assume /api/gift-cards GET is available from TC048.
    url = BASE_URL + "/api/gift-cards"
    resp = requests.get(url, headers=headers, timeout=TIMEOUT)
    resp.raise_for_status()
    cards = resp.json()
    # Pick first card with positive balance
    for card in cards:
        code = card.get("code")
        if not code:
            continue
        bal_resp = requests.get(BASE_URL + GIFT_CARD_BALANCE_ENDPOINT.format(code=code), headers=headers, timeout=TIMEOUT)
        if bal_resp.status_code != 200:
            continue
        balance_data = bal_resp.json()
        balance = balance_data.get("balance", 0)
        if balance > 0:
            return code, balance
    raise RuntimeError("No suitable gift card with positive balance found for testing.")

def test_gift_card_redeem_api():
    token = login_get_token()
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }

    # Create or get an existing gift card with positive balance
    code, balance = create_gift_card(headers)

    # Define a redeem amount less than or equal to balance
    redeem_amount_valid = balance if balance < 100 else 100

    # Redeem amount that exceeds balance
    redeem_amount_excess = balance + 10

    try:
        # 1. Test valid redemption deducts amount from balance
        redeem_url = BASE_URL + GIFT_CARD_REDEEM_ENDPOINT.format(code=code)
        payload_valid = {"amount": redeem_amount_valid}
        resp_valid = requests.post(redeem_url, json=payload_valid, headers=headers, timeout=TIMEOUT)
        assert resp_valid.status_code == 200, f"Valid redeem failed: {resp_valid.text}"

        # Verify balance is reduced by redeem_amount_valid
        bal_resp_after_valid = requests.get(BASE_URL + GIFT_CARD_BALANCE_ENDPOINT.format(code=code), headers=headers, timeout=TIMEOUT)
        bal_resp_after_valid.raise_for_status()
        new_balance = bal_resp_after_valid.json().get("balance")
        expected_balance = balance - redeem_amount_valid
        assert abs(new_balance - expected_balance) < 0.01, \
            f"Balance after redeem incorrect. Expected ~{expected_balance}, got {new_balance}"

        # 2. Test redeem amount exceeding balance returns 422
        payload_excess = {"amount": redeem_amount_excess}
        resp_excess = requests.post(redeem_url, json=payload_excess, headers=headers, timeout=TIMEOUT)
        assert resp_excess.status_code == 422, f"Excess redeem should fail with 422, got {resp_excess.status_code}"
    finally:
        # Optionally, restore the gift card balance by adding back redeemed amount if API supports it,
        # or leave as is if no API for crediting gift cards. No API for reversing given in PRD.
        pass

test_gift_card_redeem_api()
