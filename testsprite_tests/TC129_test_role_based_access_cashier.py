import requests

BASE_URL = "http://localhost:8080"
TIMEOUT = 30

def test_role_based_access_cashier():
    # Login as cashier using email/password (assuming cashier email and password known for test)
    # Since the PRD and instructions only provide owner credentials,
    # we must use a known cashier's credentials; assuming:
    # email: cashier@ostora.sa, password: cashier@ostora.sa for this test case
    login_url = f"{BASE_URL}/api/auth/login"
    cashier_credentials = {
        "email": "cashier@ostora.sa",
        "password": "cashier@ostora.sa"
    }
    try:
        login_resp = requests.post(login_url, json=cashier_credentials, timeout=TIMEOUT)
        assert login_resp.status_code == 200, f"Login failed with status {login_resp.status_code}: {login_resp.text}"
        login_data = login_resp.json()
        token = login_data.get("token") or login_data.get("access_token")
        assert token, "No token found in login response"
    except Exception as e:
        raise AssertionError(f"Cashier login failed: {e}")

    # Access admin endpoint /api/admin/stores with cashier token
    admin_stores_url = f"{BASE_URL}/api/admin/stores"
    headers = {
        "Authorization": f"Bearer {token}"
    }
    try:
        admin_resp = requests.get(admin_stores_url, headers=headers, timeout=TIMEOUT)
        # Expect 403 Forbidden for low privilege role
        assert admin_resp.status_code == 403, f"Expected 403 Forbidden but got {admin_resp.status_code}"
    except Exception as e:
        raise AssertionError(f"Accessing admin endpoint failed: {e}")

test_role_based_access_cashier()