import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
PRODUCTS_ENDPOINT = "/api/products"
LOGIN_EMAIL = "owner@ostora.sa"
LOGIN_PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_input_validation_xss_prevention():
    session = requests.Session()
    try:
        # Authenticate and get token
        login_resp = session.post(
            BASE_URL + LOGIN_ENDPOINT,
            json={"email": LOGIN_EMAIL, "password": LOGIN_PASSWORD},
            timeout=TIMEOUT,
        )
        assert login_resp.status_code == 200, f"Login failed: {login_resp.text}"
        token = login_resp.json().get("token")
        assert token, "No token in login response"

        headers = {"Authorization": f"Bearer {token}"}

        # Attempt to create product with XSS payload in name
        xss_payload = "<script>alert(1)</script>"
        product_data = {
            "name": xss_payload,
            "sku": "XSS-TEST-001",
            "barcode": "0000000000000",
            "price": 10.0,
            "category_id": 1,  # Assuming 1 is valid; if needed, create category first
            # Add any other required fields as necessary
        }

        post_resp = session.post(
            BASE_URL + PRODUCTS_ENDPOINT, json=product_data, headers=headers, timeout=TIMEOUT
        )

        # The system should either reject (4xx) or sanitize input (201)
        # Accept 201 Created if sanitizes; if rejects, expect 400 or 422
        if post_resp.status_code == 201:
            # Check that returned product name does not contain raw script tags
            created_product = post_resp.json()
            returned_name = created_product.get("name", "")
            # Assert script tags are either removed or escaped (not literally present)
            assert (
                xss_payload not in returned_name
            ), "XSS raw payload present in stored product name, input not sanitized"
            # Cleanup: delete created product
            product_id = created_product.get("id")
            if product_id:
                del_resp = session.delete(
                    f"{BASE_URL}{PRODUCTS_ENDPOINT}/{product_id}",
                    headers=headers,
                    timeout=TIMEOUT,
                )
                assert del_resp.status_code in (200, 204), f"Cleanup delete failed: {del_resp.text}"
        else:
            # On rejection, expect 400 or 422
            assert post_resp.status_code in (400, 422), f"Unexpected status code: {post_resp.status_code}"
            # Optionally, check error message for XSS-related rejection
            error_json = post_resp.json()
            error_message = str(error_json)
            assert (
                "script" in error_message.lower() or "xss" in error_message.lower() or "invalid" in error_message.lower()
            ), f"Unexpected error message: {error_message}"

    finally:
        session.close()


test_input_validation_xss_prevention()
