import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
CATEGORIES_ENDPOINT = "/api/catalog/categories"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_categories_crud_api():
    # Authenticate and get token
    login_payload = {"email": EMAIL, "password": PASSWORD}
    try:
        login_resp = requests.post(
            BASE_URL + LOGIN_ENDPOINT, json=login_payload, timeout=TIMEOUT
        )
        assert login_resp.status_code == 200, f"Login failed: {login_resp.text}"
        token = login_resp.json().get("token")
        assert token, "Auth token not found in login response"
    except Exception as e:
        raise AssertionError(f"Authentication request failed: {e}")

    headers = {"Authorization": f"Bearer {token}", "Content-Type": "application/json"}

    # 1. List categories (GET) - Expect 200
    try:
        list_resp = requests.get(BASE_URL + CATEGORIES_ENDPOINT, headers=headers, timeout=TIMEOUT)
        assert list_resp.status_code == 200, f"Listing categories failed: {list_resp.text}"
        categories_list = list_resp.json()
        assert isinstance(categories_list, list), "Categories list is not a list"
    except Exception as e:
        raise AssertionError(f"List categories request failed: {e}")

    # 2. Create category (POST) - Expect 201
    new_category = {"name": "Test Category for CRUD API"}
    category_id = None
    try:
        create_resp = requests.post(
            BASE_URL + CATEGORIES_ENDPOINT, json=new_category, headers=headers, timeout=TIMEOUT
        )
        assert create_resp.status_code == 201, f"Category creation failed: {create_resp.text}"
        created_category = create_resp.json()
        category_id = created_category.get("id")
        assert category_id is not None, "Created category ID missing"
        assert created_category.get("name") == new_category["name"], "Category name mismatch on create"
    except Exception as e:
        raise AssertionError(f"Create category request failed: {e}")

    try:
        # 3. Get single category (GET) - Expect 200
        try:
            get_resp = requests.get(f"{BASE_URL}{CATEGORIES_ENDPOINT}/{category_id}", headers=headers, timeout=TIMEOUT)
            assert get_resp.status_code == 200, f"Get category failed: {get_resp.text}"
            got_category = get_resp.json()
            assert got_category.get("id") == category_id, "Category ID mismatch on get"
            assert got_category.get("name") == new_category["name"], "Category name mismatch on get"
        except Exception as e:
            raise AssertionError(f"Get category request failed: {e}")

        # 4. Update category (PUT) - Expect 200
        updated_name = "Updated Test Category"
        update_payload = {"name": updated_name}
        try:
            update_resp = requests.put(
                f"{BASE_URL}{CATEGORIES_ENDPOINT}/{category_id}",
                json=update_payload,
                headers=headers,
                timeout=TIMEOUT
            )
            assert update_resp.status_code == 200, f"Update category failed: {update_resp.text}"
            updated_category = update_resp.json()
            assert updated_category.get("id") == category_id, "Category ID mismatch on update"
            assert updated_category.get("name") == updated_name, "Category name not updated correctly"
        except Exception as e:
            raise AssertionError(f"Update category request failed: {e}")

        # 5. Test 422 error on create missing name (POST)
        try:
            bad_payload = {}
            err_resp = requests.post(
                BASE_URL + CATEGORIES_ENDPOINT, json=bad_payload, headers=headers, timeout=TIMEOUT
            )
            assert err_resp.status_code == 422, f"Expected 422 for missing name got {err_resp.status_code}"
        except Exception as e:
            raise AssertionError(f"Create category with missing name request failed: {e}")

    finally:
        # 6. Delete category (DELETE) - Expect 200
        if category_id is not None:
            try:
                del_resp = requests.delete(
                    f"{BASE_URL}{CATEGORIES_ENDPOINT}/{category_id}", headers=headers, timeout=TIMEOUT
                )
                assert del_resp.status_code == 200, f"Delete category failed: {del_resp.text}"

                # Confirm deletion by trying to get it - expect 404
                get_after_del_resp = requests.get(
                    f"{BASE_URL}{CATEGORIES_ENDPOINT}/{category_id}", headers=headers, timeout=TIMEOUT
                )
                assert get_after_del_resp.status_code == 404, (
                    f"Category still exists after deletion, got: {get_after_del_resp.status_code}"
                )
            except Exception as e:
                raise AssertionError(f"Delete category request failed: {e}")


test_categories_crud_api()