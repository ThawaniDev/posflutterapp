import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
GIFT_CARDS_ENDPOINT = "/api/gift-cards"

EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_gift_cards_api():
    try:
        # Authenticate and get token
        login_resp = requests.post(
            BASE_URL + LOGIN_ENDPOINT,
            json={"email": EMAIL, "password": PASSWORD},
            timeout=TIMEOUT
        )
        assert login_resp.status_code == 200, f"Login failed: {login_resp.text}"
        token = login_resp.json().get("token")
        assert token and isinstance(token, str), "No token in login response"

        headers = {"Authorization": f"Bearer {token}"}

        # 1. Verify GET /api/gift-cards lists cards
        list_resp = requests.get(
            BASE_URL + GIFT_CARDS_ENDPOINT,
            headers=headers,
            timeout=TIMEOUT
        )
        assert list_resp.status_code == 200, f"Gift cards list failed: {list_resp.text}"
        gift_cards_list = list_resp.json()
        assert isinstance(gift_cards_list, list), "Gift cards list response is not a list"

        # Proceed only if there's at least one card to test balance
        if gift_cards_list:
            # Take the first card's code
            card_code = gift_cards_list[0].get("code")
            assert card_code and isinstance(card_code, str), "No code found in a gift card item"

            # 2. Verify GET /api/gift-cards/{code}/balance returns balance
            balance_resp = requests.get(
                f"{BASE_URL}{GIFT_CARDS_ENDPOINT}/{card_code}/balance",
                headers=headers,
                timeout=TIMEOUT
            )
            assert balance_resp.status_code == 200, f"Balance get failed for code {card_code}: {balance_resp.text}"
            balance_data = balance_resp.json()
            # Expecting a balance field as a number
            assert "balance" in balance_data, "Balance field missing in response"
            assert isinstance(balance_data["balance"], (int, float)), "Balance is not a number"

        # 3. Test 404 for unknown code balance check
        unknown_code = "UNKNOWN_CODE_123456"
        unknown_resp = requests.get(
            f"{BASE_URL}{GIFT_CARDS_ENDPOINT}/{unknown_code}/balance",
            headers=headers,
            timeout=TIMEOUT
        )
        assert unknown_resp.status_code == 404, f"Unknown code balance endpoint should return 404, got {unknown_resp.status_code}"

    except requests.RequestException as e:
        assert False, f"HTTP request failed: {e}"


test_gift_cards_api()