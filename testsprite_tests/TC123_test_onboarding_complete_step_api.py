import requests

BASE_URL = "http://localhost:8080"
ONBOARDING_ENDPOINT = "/api/onboarding/store"
TIMEOUT = 30

PAYLOAD = {
    "business_type": "Supermarket",
    "store_name": "Test Store",
    "address": "123 Main St, Riyadh",
    "vat_registration_number": "1234567890",
    "currency": "SAR",
    "timezone": "Asia/Riyadh"
}

def test_onboarding_store_api():
    try:
        response = requests.post(
            BASE_URL + ONBOARDING_ENDPOINT, json=PAYLOAD, timeout=TIMEOUT
        )
        assert response.status_code == 200 or response.status_code == 201, f"Onboarding failed: {response.text}"
        data = response.json()
        assert isinstance(data, dict), "Response is not a JSON object"
        # Optionally check expected keys in response like 'store_id' or 'message'
        assert "store_id" in data or "message" in data, "Expected keys not found in response"
    except Exception as e:
        raise AssertionError(f"Onboarding request exception: {e}")


test_onboarding_store_api()