import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
REPORT_TOP_CUSTOMERS_ENDPOINT = "/api/reports/customers/top"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30

def test_reports_top_customers_api():
    # Step 1: Authenticate and get Bearer token
    login_url = BASE_URL + LOGIN_ENDPOINT
    login_payload = {
        "email": EMAIL,
        "password": PASSWORD
    }
    try:
        login_response = requests.post(login_url, json=login_payload, timeout=TIMEOUT)
        assert login_response.status_code == 200, f"Login failed with status code {login_response.status_code}"
        login_json = login_response.json()
        token = login_json.get("token")
        assert token and isinstance(token, str), "Token not found in login response"
    except requests.RequestException as e:
        raise AssertionError(f"Login request failed: {e}")

    # Step 2: Call GET /api/reports/customers/top endpoint with Auth header
    headers = {
        "Authorization": f"Bearer {token}"
    }
    reports_url = BASE_URL + REPORT_TOP_CUSTOMERS_ENDPOINT
    try:
        response = requests.get(reports_url, headers=headers, timeout=TIMEOUT)
        assert response.status_code == 200, f"Reports endpoint returned status {response.status_code}"
        data = response.json()
        assert isinstance(data, list), "Expected response to be a list"

        # Validate each customer in the list
        for customer in data:
            # Each customer should be a dict
            assert isinstance(customer, dict), "Each customer item should be a dictionary"

            # Must have 'visit_count' and it should be int >= 0
            assert 'visit_count' in customer, "'visit_count' field missing in customer data"
            assert isinstance(customer['visit_count'], int), "'visit_count' should be an integer"
            assert customer['visit_count'] >= 0, "'visit_count' should be non-negative"

            # Must have 'total_spent' and it should be a number (int or float) >= 0
            assert 'total_spent' in customer, "'total_spent' field missing in customer data"
            total_spent = customer['total_spent']
            assert isinstance(total_spent, (int, float)), "'total_spent' should be int or float"
            assert total_spent >= 0, "'total_spent' should be non-negative"

        # Verify that the customers list is sorted by total_spent descending
        total_spent_list = [cust['total_spent'] for cust in data]
        assert total_spent_list == sorted(total_spent_list, reverse=True), "Customers not sorted by total_spent descending"

    except requests.RequestException as e:
        raise AssertionError(f"Reports API request failed: {e}")

test_reports_top_customers_api()