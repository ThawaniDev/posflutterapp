import requests

BASE_URL = "http://localhost:8080"
TIMEOUT = 30

def test_config_maintenance_api():
    url = f"{BASE_URL}/api/config/maintenance"
    try:
        response = requests.get(url, timeout=TIMEOUT)
        response.raise_for_status()
    except requests.RequestException as e:
        assert False, f"Request failed: {e}"

    assert response.status_code == 200, f"Expected status code 200, got {response.status_code}"
    try:
        data = response.json()
    except Exception as e:
        assert False, f"Response is not valid JSON: {e}"

    assert "is_maintenance" in data, "Response JSON missing 'is_maintenance' field"
    assert isinstance(data["is_maintenance"], bool), "'is_maintenance' is not a boolean"

test_config_maintenance_api()