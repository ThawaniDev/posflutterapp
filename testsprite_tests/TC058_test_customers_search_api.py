import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
CUSTOMER_SEARCH_ENDPOINT = "/api/customers"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_customers_search_api():
    # Authenticate and get token
    try:
        login_resp = requests.post(
            BASE_URL + LOGIN_ENDPOINT,
            json={"email": EMAIL, "password": PASSWORD},
            timeout=TIMEOUT,
        )
        assert login_resp.status_code == 200, f"Login failed: {login_resp.text}"
        token = login_resp.json().get("token") or login_resp.json().get("access_token")
        assert token, "Bearer token not found in login response"
    except Exception as e:
        assert False, f"Exception during login: {e}"

    headers = {"Authorization": f"Bearer {token}"}

    # Test with a search term that should return results (using 'a' as common term)
    try:
        resp = requests.get(
            BASE_URL + CUSTOMER_SEARCH_ENDPOINT,
            params={"q": "a"},
            headers=headers,
            timeout=TIMEOUT,
        )
        assert resp.status_code == 200, f"Search with term returned status {resp.status_code}"
        data = resp.json()
        assert isinstance(data, list), "Search results should be a list"
    except Exception as e:
        assert False, f"Exception during search with term: {e}"

    # Test with a search term that returns no results
    try:
        resp_empty = requests.get(
            BASE_URL + CUSTOMER_SEARCH_ENDPOINT,
            params={"q": "noresultsfoundxyz123"},
            headers=headers,
            timeout=TIMEOUT,
        )
        assert resp_empty.status_code == 200, f"Search empty term returned status {resp_empty.status_code}"
        data_empty = resp_empty.json()
        assert isinstance(data_empty, list), "Empty search results should be a list"
        assert len(data_empty) == 0, "Empty search results list should be empty"
    except Exception as e:
        assert False, f"Exception during search with empty results: {e}"


test_customers_search_api()
