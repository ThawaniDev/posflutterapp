import requests
import uuid

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
GROUPS_ENDPOINT = "/api/customers/groups"

EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"

TIMEOUT = 30


def test_customer_groups_api():
    # Authenticate and get token
    login_payload = {
        "email": EMAIL,
        "password": PASSWORD
    }
    try:
        login_resp = requests.post(
            f"{BASE_URL}{LOGIN_ENDPOINT}", json=login_payload, timeout=TIMEOUT
        )
        login_resp.raise_for_status()
        login_data = login_resp.json()
        token = login_data.get("token")
        assert token and isinstance(token, str), "Authentication token not returned properly"
    except Exception as e:
        assert False, f"Login failed: {e}"

    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }

    # Test GET /api/customers/groups returns groups
    try:
        groups_resp = requests.get(
            f"{BASE_URL}{GROUPS_ENDPOINT}", headers=headers, timeout=TIMEOUT
        )
        groups_resp.raise_for_status()
        groups_data = groups_resp.json()
        assert isinstance(groups_data, list), "Groups list response is not a list"
    except Exception as e:
        assert False, f"GET groups list failed: {e}"

    created_group_id = None

    # Test POST /api/customers/groups creates group with name and discount config
    # Generate unique group name to avoid conflicts
    unique_group_name = f"TestGroup_{uuid.uuid4()}"
    group_payload = {
        "name": unique_group_name,
        "discount": {
            "type": "percentage",
            "value": 10  # 10% discount as example
        }
    }

    try:
        create_resp = requests.post(
            f"{BASE_URL}{GROUPS_ENDPOINT}",
            json=group_payload,
            headers=headers,
            timeout=TIMEOUT,
        )
        create_resp.raise_for_status()
        create_data = create_resp.json()

        # Assuming the created group object is returned with an 'id' field
        created_group_id = create_data.get("id")
        assert created_group_id is not None, "Created group ID not returned"
        assert create_data.get("name") == unique_group_name, "Created group name mismatch"
        discount = create_data.get("discount")
        assert discount is not None, "Discount config missing in created group"
        assert discount.get("type") == "percentage", "Discount type mismatch"
        assert discount.get("value") == 10, "Discount value mismatch"
    except Exception as e:
        assert False, f"POST create group failed: {e}"
    finally:
        # Cleanup: delete the created group if possible
        if created_group_id:
            try:
                del_resp = requests.delete(
                    f"{BASE_URL}{GROUPS_ENDPOINT}/{created_group_id}",
                    headers=headers,
                    timeout=TIMEOUT,
                )
                # Accept 200 or 204 for successful deletion
                assert del_resp.status_code in (200, 204), f"Failed to delete group, status code: {del_resp.status_code}"
            except Exception:
                # Ignore errors in cleanup
                pass


test_customer_groups_api()
