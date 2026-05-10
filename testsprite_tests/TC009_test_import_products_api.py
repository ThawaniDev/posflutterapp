import requests
import io

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = f"{BASE_URL}/api/auth/login"
IMPORT_ENDPOINT = f"{BASE_URL}/api/products/import"

EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"


def test_import_products_api():
    session = requests.Session()
    # Authenticate and get Bearer token
    try:
        auth_resp = session.post(
            LOGIN_ENDPOINT,
            json={"email": EMAIL, "password": PASSWORD},
            timeout=30
        )
        assert auth_resp.status_code == 200, f"Login failed: {auth_resp.text}"
        auth_json = auth_resp.json()
        assert "token" in auth_json, f"No token in login response: {auth_json}"
        token = auth_json["token"]
    except Exception as e:
        raise AssertionError(f"Authentication request failed: {e}")

    headers = {
        "Authorization": f"Bearer {token}",
    }

    # Prepare CSV data to import
    csv_content = (
        "name,sku,barcode,price,category\n"
        "Test Product 1,SKU001,1234567890123,9.99,General\n"
        "Test Product 2,SKU002,1234567890124,19.99,General\n"
    )
    files = {
        "file": ("products.csv", io.BytesIO(csv_content.encode("utf-8")), "text/csv")
    }

    try:
        import_resp = session.post(
            IMPORT_ENDPOINT,
            headers=headers,
            files=files,
            timeout=30
        )
        assert import_resp.status_code == 200 or import_resp.status_code == 201, (
            f"Product import failed: HTTP {import_resp.status_code} Response: {import_resp.text}"
        )
        import_response_json = import_resp.json()
        # Basic validation that response contains success or products added info
        assert (
            isinstance(import_response_json, dict)
            and ("imported_count" in import_response_json or "message" in import_response_json)
        ), f"Unexpected response JSON from import endpoint: {import_response_json}"
    except Exception as e:
        raise AssertionError(f"Products import request failed: {e}")


test_import_products_api()