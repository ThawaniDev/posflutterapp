import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
TAX_CONFIG_ENDPOINT = "/api/config/tax"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30

def test_config_tax_api():
    try:
        # Authenticate and get token
        auth_response = requests.post(
            f"{BASE_URL}{LOGIN_ENDPOINT}",
            json={"email": EMAIL, "password": PASSWORD},
            timeout=TIMEOUT
        )
        assert auth_response.status_code == 200, f"Login failed with status {auth_response.status_code}"
        auth_data = auth_response.json()
        token = auth_data.get("token") or auth_data.get("access_token")
        assert token, "Authentication token not found in response"

        headers = {
            "Authorization": f"Bearer {token}"
        }

        # Call tax config endpoint
        response = requests.get(f"{BASE_URL}{TAX_CONFIG_ENDPOINT}", headers=headers, timeout=TIMEOUT)
        assert response.status_code == 200, f"Expected 200 OK, got {response.status_code}"
        tax_data = response.json()

        # Validate tax rate and name for Saudi stores
        assert isinstance(tax_data, dict), "Tax config response is not a JSON object"
        assert "rate" in tax_data, "Tax rate not present in response"
        assert "name" in tax_data, "Tax name not present in response"

        assert tax_data["rate"] == 15, f"Expected tax rate 15, got {tax_data['rate']}"
        assert tax_data["name"].upper() == "VAT", f"Expected tax name 'VAT', got {tax_data['name']}"

    except requests.RequestException as e:
        raise AssertionError(f"Request failed: {e}")

test_config_tax_api()