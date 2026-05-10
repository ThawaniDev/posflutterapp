import requests

BASE_URL = "http://localhost:8080"
BUSINESS_TYPES_ENDPOINT = "/api/onboarding/business-types"
TIMEOUT = 30

def test_business_types_public_api():
    url = BASE_URL + BUSINESS_TYPES_ENDPOINT
    try:
        response = requests.get(url, timeout=TIMEOUT)
        response.raise_for_status()
    except requests.RequestException as e:
        assert False, f"Request to {url} failed: {e}"

    data = response.json()
    assert isinstance(data, list), "Response should be a list of business types"

    for business_type in data:
        assert isinstance(business_type, dict), "Each business type should be an object/dict"
        assert "slug" in business_type, "'slug' field missing in business type item"
        assert "name" in business_type, "'name' field missing in business type item"
        assert isinstance(business_type["slug"], str), "'slug' should be a string"
        assert isinstance(business_type["name"], str), "'name' should be a string"
        assert business_type["slug"], "'slug' should not be empty"
        assert business_type["name"], "'name' should not be empty"

test_business_types_public_api()