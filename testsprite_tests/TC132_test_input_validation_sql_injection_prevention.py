import requests

BASE_URL = "http://localhost:8080"
LOGIN_URL = f"{BASE_URL}/api/auth/login"
CUSTOMERS_SEARCH_URL = f"{BASE_URL}/api/customers"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_input_validation_sql_injection_prevention():
    # Authenticate and get token
    try:
        login_resp = requests.post(
            LOGIN_URL,
            json={"email": EMAIL, "password": PASSWORD},
            timeout=TIMEOUT,
        )
        login_resp.raise_for_status()
        token = login_resp.json().get("token") or login_resp.json().get("access_token")
        assert token, "Authentication token not found in login response"
    except requests.RequestException as e:
        assert False, f"Authentication failed: {e}"

    headers = {"Authorization": f"Bearer {token}"}

    # The malicious SQL injection string as search query parameter
    injection_string = "'; DROP TABLE customers;--"

    try:
        response = requests.get(
            CUSTOMERS_SEARCH_URL,
            headers=headers,
            params={"search": injection_string},
            timeout=TIMEOUT,
        )
    except requests.RequestException as e:
        assert False, f"API request failed: {e}"

    # Assert the response status code is not 500 (server error)
    assert response.status_code != 500, f"Server error occurred: {response.text}"

    # Assert the response status code is either 200 or 400 or 422 or another safe client error (not server error)
    # The main goal is to protect the server from crash. Typically, 200 with empty or safe response expected
    assert response.status_code in (200, 400, 422), f"Unexpected status code {response.status_code}"

    # Additional: The response body should be JSON and not contain any DB errors or stack traces
    try:
        data = response.json()
    except ValueError:
        assert False, "Response is not valid JSON"

    # The response should not contain error messages indicating SQL syntax or DB error
    error_messages = [
        "sql syntax",
        "database error",
        "exception",
        "stack trace",
        "syntax error",
        "unclosed quotation mark",
        "unterminated string",
    ]
    resp_text_lower = response.text.lower()
    for err_msg in error_messages:
        assert err_msg not in resp_text_lower, f"Potential SQL error leakage in response: {err_msg}"


test_input_validation_sql_injection_prevention()