import requests

BASE_URL = "http://localhost:8080"
LOGIN_URL = f"{BASE_URL}/api/auth/login"
CUSTOMERS_URL = f"{BASE_URL}/api/customers"
TIMEOUT = 30
LOGIN_EMAIL = "owner@ostora.sa"
LOGIN_PASSWORD = "owner@ostora.sa"


def authenticate():
    try:
        resp = requests.post(
            LOGIN_URL,
            json={"email": LOGIN_EMAIL, "password": LOGIN_PASSWORD},
            timeout=TIMEOUT,
        )
        resp.raise_for_status()
        data = resp.json()
        token = data.get("token") or data.get("access_token") or data.get("accessToken")
        if not token:
            raise ValueError("Authentication token not found in response")
        return token
    except Exception as e:
        raise RuntimeError(f"Authentication failed: {e}")


def test_customers_list_api():
    # 1. Verify 401 Unauthorized without auth
    resp_no_auth = requests.get(CUSTOMERS_URL, timeout=TIMEOUT)
    assert resp_no_auth.status_code == 401, f"Expected 401 without auth, got {resp_no_auth.status_code}"

    # Authenticate and get bearer token
    token = authenticate()
    headers = {"Authorization": f"Bearer {token}"}

    # 2. Verify GET /api/customers returns paginated list
    resp = requests.get(CUSTOMERS_URL, headers=headers, timeout=TIMEOUT)
    assert resp.status_code == 200, f"Expected 200 OK for customers list, got {resp.status_code}"
    result = resp.json()
    assert isinstance(result, dict), "Response should be a JSON object"
    # Expect keys like 'data', 'meta', or pagination keys
    assert ("data" in result and isinstance(result["data"], list)) or isinstance(result, list), "Response data should contain a list of customers"

    # 3. Test search by name (using first customer's name if available)
    customers_list = result.get("data") if isinstance(result, dict) else result
    if customers_list and len(customers_list) > 0:
        first_customer = customers_list[0]
        name_query = first_customer.get("name")
        if name_query:
            params = {"search": name_query}
            resp_search_name = requests.get(CUSTOMERS_URL, headers=headers, params=params, timeout=TIMEOUT)
            assert resp_search_name.status_code == 200, f"Expected 200 OK for search by name, got {resp_search_name.status_code}"
            search_result = resp_search_name.json()
            search_customers = search_result.get("data") if isinstance(search_result, dict) else search_result
            assert any(name_query.lower() in (cust.get("name") or "").lower() for cust in search_customers), "Search by name did not return matching customers"

    # 4. Test search by phone (using first customer's phone if available)
    if customers_list and len(customers_list) > 0:
        first_customer = customers_list[0]
        phone_query = first_customer.get("phone")
        if phone_query:
            params = {"search": phone_query}
            resp_search_phone = requests.get(CUSTOMERS_URL, headers=headers, params=params, timeout=TIMEOUT)
            assert resp_search_phone.status_code == 200, f"Expected 200 OK for search by phone, got {resp_search_phone.status_code}"
            search_result = resp_search_phone.json()
            search_customers = search_result.get("data") if isinstance(search_result, dict) else search_result
            assert any(phone_query in (cust.get("phone") or "") for cust in search_customers), "Search by phone did not return matching customers"


test_customers_list_api()