import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
TIMEOUT = 30

def test_email_password_login_api():
    url = BASE_URL + LOGIN_ENDPOINT
    headers = {"Content-Type": "application/json"}

    valid_credentials = {
        "email": "owner@ostora.sa",
        "password": "owner@ostora.sa"
    }

    invalid_credentials_list = [
        {"email": "owner@ostora.sa", "password": "wrongpassword"},
        {"email": "wrong@ostora.sa", "password": "owner@ostora.sa"},
        {"email": "invalidemail@", "password": "owner@ostora.sa"},
        {"email": "", "password": "owner@ostora.sa"},
        {"email": "owner@ostora.sa", "password": ""},
        {"email": "", "password": ""}
    ]

    # Test valid login credentials
    try:
        response = requests.post(url, json=valid_credentials, headers=headers, timeout=TIMEOUT)
        assert response.status_code == 200, f"Expected status 200, got {response.status_code}"
        data = response.json()
        assert "token" in data or "access_token" in data or "Bearer " in response.text or "bearer" in response.text.lower() or any(
            key.lower() == "token" for key in data), "Token not found in successful login response"
        # Attempt to extract Bearer token
        token = data.get("token") or data.get("access_token")
        assert token and isinstance(token, str) and len(token) > 0, "Token value is invalid or empty"
    except (requests.RequestException, AssertionError) as e:
        raise AssertionError(f"Valid login test failed: {e}")

    # Test invalid login credentials
    for creds in invalid_credentials_list:
        try:
            resp = requests.post(url, json=creds, headers=headers, timeout=TIMEOUT)
        except requests.RequestException as e:
            raise AssertionError(f"Request failed for credentials {creds}: {e}")

        # Expect 4xx status code for invalid login
        if resp.status_code == 200:
            try:
                resp_data = resp.json()
            except Exception:
                resp_data = {}
            # If the response is 200 with no token, consider it failure
            token_in_resp = resp_data.get("token") or resp_data.get("access_token")
            if token_in_resp:
                raise AssertionError(f"Invalid credentials {creds} succeeded unexpectedly with token.")
            else:
                raise AssertionError(f"Invalid credentials {creds} returned 200 without token, should be error.")
        else:
            # Expected an error status code (e.g. 400, 401, 403)
            assert 400 <= resp.status_code < 500, f"Unexpected status code {resp.status_code} for creds {creds}"
            try:
                error_data = resp.json()
                # Check that error message or error field exists
                error_fields = ["error", "message", "detail", "errors"]
                if not any(field in error_data for field in error_fields):
                    # If no error message in body, at least the status code is correct
                    pass
            except Exception:
                # No JSON body, still okay if status code indicates error
                pass

test_email_password_login_api()