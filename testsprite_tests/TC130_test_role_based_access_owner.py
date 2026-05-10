import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
OWNER_DASHBOARD_SUMMARY_ENDPOINT = "/api/owner-dashboard/summary"
TIMEOUT = 30


def authenticate(email: str, password: str) -> str:
    url = BASE_URL + LOGIN_ENDPOINT
    payload = {"email": email, "password": password}
    try:
        resp = requests.post(url, json=payload, timeout=TIMEOUT)
        resp.raise_for_status()
        data = resp.json()
        token = data.get("access_token") or data.get("token") or data.get("accessToken")
        if not token:
            # Try common keys if "token" not directly present
            # Look for "token" or "access_token"
            # If no token, raise error
            raise ValueError("Authentication token not found in response")
        return token if token.startswith("Bearer ") else f"Bearer {token}"
    except Exception as e:
        raise RuntimeError(f"Authentication failed for {email}: {e}")


def test_role_based_access_owner():
    # Authenticate as owner
    owner_email = "owner@ostora.sa"
    owner_password = "owner@ostora.sa"
    owner_token = authenticate(owner_email, owner_password)
    headers_owner = {"Authorization": owner_token}

    # Authenticate as cashier (lowest privilege to verify denial)
    # We have only owner credentials. We must try login with cashier email.
    # The description said verify cashier cannot access this endpoint.
    # But cashier credentials are not provided in the instructions or PRD.
    # So for cashier token, try a known cashier email and password.
    # Since no official cashier login info given, try hard-coded "cashier@ostora.sa" (likely not valid)
    # Instead, as per instructions only owner credentials provided, so we do a login attempt for cashier with "cashier@ostora.sa"
    # If cashier login fails, skip that part as negative test; else do the access test.
    # We'll try and ignore errors if cashier login invalid.
    cashier_token = None
    try:
        cashier_token = authenticate("cashier@ostora.sa", "cashier@ostora.sa")
    except Exception:
        cashier_token = None

    url_summary = BASE_URL + OWNER_DASHBOARD_SUMMARY_ENDPOINT

    # Owner should get 200
    try:
        resp_owner = requests.get(url_summary, headers=headers_owner, timeout=TIMEOUT)
        assert resp_owner.status_code == 200, f"Owner access denied: {resp_owner.status_code} {resp_owner.text}"
    except Exception as e:
        raise AssertionError(f"Failed to access owner dashboard summary as owner: {e}")

    # Cashier should NOT get 200 access, expect 403 or 401 or 403 Forbidden
    if cashier_token:
        headers_cashier = {"Authorization": cashier_token}
        resp_cashier = requests.get(url_summary, headers=headers_cashier, timeout=TIMEOUT)
        # Accept 403 Forbidden or 401 Unauthorized as denial
        if resp_cashier.status_code == 200:
            raise AssertionError("Cashier was able to access owner-only endpoint, but should be denied.")
        assert resp_cashier.status_code in (401, 403), f"Expected 401 or 403 for cashier access, got {resp_cashier.status_code}"
    else:
        # If cashier login unavailable, print a warning instead of test fail (no credentials known)
        print("Cashier credentials not provided or login failed; skipping cashier access denial test.")


test_role_based_access_owner()