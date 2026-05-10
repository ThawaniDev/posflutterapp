import requests
import uuid

BASE_URL = "http://localhost:8080"
LOGIN_URL = f"{BASE_URL}/api/auth/login"
EXPENSES_URL = f"{BASE_URL}/api/expenses"
TIMEOUT = 30

EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"


def test_expenses_crud_api():
    # Authenticate and get token
    try:
        login_resp = requests.post(
            LOGIN_URL,
            json={"email": EMAIL, "password": PASSWORD},
            timeout=TIMEOUT,
        )
        assert login_resp.status_code == 200, f"Login failed: {login_resp.text}"
        token = login_resp.json().get("token")
        assert token, "No token found in login response"
        headers = {"Authorization": f"Bearer {token}", "Content-Type": "application/json"}

        # 1. List expenses (should be 200)
        list_resp = requests.get(EXPENSES_URL, headers=headers, timeout=TIMEOUT)
        assert list_resp.status_code == 200, f"Failed to list expenses: {list_resp.text}"
        assert isinstance(list_resp.json(), list), "Expenses list response is not a list"

        # 2. Create a new expense (should be 201)
        unique_reference = f"test-expense-{uuid.uuid4()}"
        expense_data = {
            "amount": 123.45,
            "description": "Test expense CRUD API",
            "reference": unique_reference,  # assuming API may allow extra fields
            # Add other required fields if any; not specified in PRD, so simplest payload
        }
        create_resp = requests.post(EXPENSES_URL, json=expense_data, headers=headers, timeout=TIMEOUT)
        assert create_resp.status_code == 201, f"Failed to create expense: {create_resp.text}"
        created_expense = create_resp.json()
        expense_id = created_expense.get("id")
        assert expense_id, "Created expense has no ID"
        assert float(created_expense.get("amount")) == expense_data["amount"]
        assert created_expense.get("description") == expense_data["description"]

        # 3. Update the created expense (should be 200)
        updated_data = {
            "amount": 150.00,
            "description": "Updated test expense",
        }
        update_resp = requests.put(f"{EXPENSES_URL}/{expense_id}", json=updated_data, headers=headers, timeout=TIMEOUT)
        assert update_resp.status_code == 200, f"Failed to update expense: {update_resp.text}"
        updated_expense = update_resp.json()
        assert float(updated_expense.get("amount")) == updated_data["amount"]
        assert updated_expense.get("description") == updated_data["description"]

        # 4. Delete the created expense (should be 200)
        delete_resp = requests.delete(f"{EXPENSES_URL}/{expense_id}", headers=headers, timeout=TIMEOUT)
        assert delete_resp.status_code == 200, f"Failed to delete expense: {delete_resp.text}"

        # Verify deletion by GET should likely 404 or not found (optional)
        get_after_delete = requests.get(f"{EXPENSES_URL}/{expense_id}", headers=headers, timeout=TIMEOUT)
        assert get_after_delete.status_code in (404, 400, 422), "Deleted expense should not be retrievable"

        # 5. Test creating expense with negative amount (should be 422)
        negative_expense_data = {
            "amount": -10,
            "description": "Negative amount test",
        }
        negative_resp = requests.post(EXPENSES_URL, json=negative_expense_data, headers=headers, timeout=TIMEOUT)
        assert negative_resp.status_code == 422, f"Negative amount did not return 422: {negative_resp.text}"

    except requests.RequestException as e:
        assert False, f"RequestException during test: {e}"


test_expenses_crud_api()