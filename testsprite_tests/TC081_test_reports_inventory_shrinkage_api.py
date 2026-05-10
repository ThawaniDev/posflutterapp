import requests

BASE_URL = "http://localhost:8080"
LOGIN_URL = f"{BASE_URL}/api/auth/login"
SHRINKAGE_URL = f"{BASE_URL}/api/reports/inventory/shrinkage"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_reports_inventory_shrinkage_api():
    # Authenticate and get token
    try:
        login_resp = requests.post(
            LOGIN_URL,
            json={"email": EMAIL, "password": PASSWORD},
            timeout=TIMEOUT
        )
        assert login_resp.status_code == 200, f"Login failed: {login_resp.text}"
        login_data = login_resp.json()
        token = login_data.get("token")
        assert token, "No token found in login response"
    except Exception as e:
        raise AssertionError(f"Exception during login: {e}")

    headers = {
        "Authorization": f"Bearer {token}"
    }

    # Request the inventory shrinkage report
    try:
        resp = requests.get(SHRINKAGE_URL, headers=headers, timeout=TIMEOUT)
    except Exception as e:
        raise AssertionError(f"Exception during GET /api/reports/inventory/shrinkage: {e}")

    # Validate response
    assert resp.status_code == 200, f"Expected 200 OK, got {resp.status_code}: {resp.text}"

    try:
        data = resp.json()
    except Exception as e:
        raise AssertionError(f"Response is not valid JSON: {e}")

    # Check presence of waste and unexplained loss records in response
    # We expect the response to contain lists or dict keys related to waste and unexplained loss
    # Since schema is not explicitly provided, verify keys or data structure accordingly
    # Accepting top-level keys like 'waste', 'unexplained_loss', or items labeled similarly
    keys_found = data.keys() if isinstance(data, dict) else []

    waste_present = False
    unexplained_loss_present = False

    if isinstance(data, dict):
        # Look for common naming keys
        for key in keys_found:
            kl = key.lower()
            if "waste" in kl:
                waste_present = True
            if "unexplained" in kl and "loss" in kl:
                unexplained_loss_present = True

        # Alternatively, check lists inside dict for objects indicating type or category
        if not waste_present or not unexplained_loss_present:
            # Attempt heuristic check inside possible list values
            for value in data.values():
                if isinstance(value, list):
                    for record in value:
                        if isinstance(record, dict):
                            record_keys = record.keys()
                            # Look for typical fields
                            names = {k.lower() for k in record_keys}
                            # Heuristic: if reason, type or category key includes waste or unexplained loss
                            reason_val = ""
                            for rk in record_keys:
                                if "reason" in rk.lower() or "type" in rk.lower() or "category" in rk.lower():
                                    rv = record.get(rk, "")
                                    if isinstance(rv, str):
                                        reason_val = rv.lower()
                                        if "waste" in reason_val:
                                            waste_present = True
                                        if "unexplained" in reason_val and "loss" in reason_val:
                                            unexplained_loss_present = True
                            # If found both, break
                            if waste_present and unexplained_loss_present:
                                break
                    if waste_present and unexplained_loss_present:
                        break

    assert waste_present, "Response does not contain waste records"
    assert unexplained_loss_present, "Response does not contain unexplained loss records"


test_reports_inventory_shrinkage_api()