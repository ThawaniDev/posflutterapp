import requests

BASE_URL = "http://localhost:8080"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_customer_loyalty_adjust_api():
    session = requests.Session()
    # Authenticate and get token
    login_resp = session.post(
        f"{BASE_URL}/api/auth/login",
        json={"email": EMAIL, "password": PASSWORD},
        timeout=TIMEOUT,
    )
    assert login_resp.status_code == 200, f"Login failed: {login_resp.text}"
    token = login_resp.json().get("token") or login_resp.json().get("access_token")
    assert token, "Bearer token not found in login response"

    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json",
    }

    # Create a new customer for testing loyalty adjustment
    customer_data = {
        "name": "Test Loyalty Customer",
        "phone": "0550000000",
        "email": "test_loyalty_customer@example.com"
    }
    create_cust_resp = session.post(
        f"{BASE_URL}/api/customers", json=customer_data, headers=headers, timeout=TIMEOUT
    )
    assert create_cust_resp.status_code == 201, f"Customer creation failed: {create_cust_resp.text}"
    customer_id = create_cust_resp.json().get("id")
    assert customer_id, "Customer ID not returned after creation"

    try:
        # Get current loyalty balance (assumed part of customer details)
        get_cust_resp = session.get(
            f"{BASE_URL}/api/customers/{customer_id}",
            headers=headers,
            timeout=TIMEOUT,
        )
        assert get_cust_resp.status_code == 200, f"Get customer failed: {get_cust_resp.text}"
        loyalty_balance = get_cust_resp.json().get("loyalty_balance", 0)
        if loyalty_balance is None:
            loyalty_balance = 0

        # 1) Add points (positive adjustment)
        add_points = 100
        adjust_add_resp = session.post(
            f"{BASE_URL}/api/customers/{customer_id}/loyalty/adjust",
            headers=headers,
            json={"points": add_points},
            timeout=TIMEOUT,
        )
        assert adjust_add_resp.status_code == 200, f"Add points failed: {adjust_add_resp.text}"
        updated_balance = adjust_add_resp.json().get("loyalty_balance")
        assert updated_balance == loyalty_balance + add_points, (
            f"Expected loyalty balance {loyalty_balance + add_points}, got {updated_balance}"
        )

        # 2) Deduct points (valid deduction within balance)
        deduct_points = min(50, updated_balance if updated_balance is not None else 0)
        if deduct_points > 0:
            adjust_deduct_resp = session.post(
                f"{BASE_URL}/api/customers/{customer_id}/loyalty/adjust",
                headers=headers,
                json={"points": -deduct_points},
                timeout=TIMEOUT,
            )
            assert adjust_deduct_resp.status_code == 200, f"Deduct points failed: {adjust_deduct_resp.text}"
            updated_balance_2 = adjust_deduct_resp.json().get("loyalty_balance")
            expected_balance = updated_balance - deduct_points if updated_balance is not None else None
            assert updated_balance_2 == expected_balance, (
                f"Expected loyalty balance {expected_balance}, got {updated_balance_2}"
            )

        # 3) Deduct more points than current balance to trigger 422
        excessive_deduct = (updated_balance_2 if updated_balance_2 is not None else 0) + 1
        adjust_excess_resp = session.post(
            f"{BASE_URL}/api/customers/{customer_id}/loyalty/adjust",
            headers=headers,
            json={"points": -excessive_deduct},
            timeout=TIMEOUT,
        )
        assert adjust_excess_resp.status_code == 422, (
            f"Expected 422 when deducting too many points, got {adjust_excess_resp.status_code}: {adjust_excess_resp.text}"
        )

    finally:
        # Clean up: delete the test customer
        del_resp = session.delete(
            f"{BASE_URL}/api/customers/{customer_id}",
            headers=headers,
            timeout=TIMEOUT,
        )
        # 200 or 204 expected on delete; ignore if already deleted
        assert del_resp.status_code in {200, 204, 404}, f"Failed to delete test customer: {del_resp.status_code}"



test_customer_loyalty_adjust_api()