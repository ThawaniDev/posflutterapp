import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
REPORT_EXPORT_ENDPOINT = "/api/reports/export"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_reports_export_pdf_api():
    # Step 1: Authenticate and get token
    login_url = BASE_URL + LOGIN_ENDPOINT
    login_payload = {"email": EMAIL, "password": PASSWORD}
    try:
        login_response = requests.post(login_url, json=login_payload, timeout=TIMEOUT)
        login_response.raise_for_status()
    except requests.RequestException as e:
        assert False, f"Login request failed: {e}"

    login_data = login_response.json()
    token = login_data.get("token") or login_data.get("access_token") or login_data.get("bearerToken")
    assert token, "Authentication token not found in login response"

    headers = {"Authorization": f"Bearer {token}", "Content-Type": "application/json"}

    # Step 2: Test POST /api/reports/export with format=pdf returns download_url
    export_url = BASE_URL + REPORT_EXPORT_ENDPOINT
    payload_pdf = {"format": "pdf"}

    try:
        response_pdf = requests.post(export_url, json=payload_pdf, headers=headers, timeout=TIMEOUT)
    except requests.RequestException as e:
        assert False, f"POST /api/reports/export request failed for format=pdf: {e}"

    assert response_pdf.status_code == 200, f"Expected status 200 for pdf export, got {response_pdf.status_code}"
    json_pdf = response_pdf.json()
    assert "download_url" in json_pdf and isinstance(json_pdf["download_url"], str) and json_pdf["download_url"], \
        "Response for pdf export must contain non-empty 'download_url' string"

    # Step 3: Test POST /api/reports/export with unsupported format returns 422
    payload_unsupported = {"format": "unsupported_format"}

    try:
        response_422 = requests.post(export_url, json=payload_unsupported, headers=headers, timeout=TIMEOUT)
    except requests.RequestException as e:
        assert False, f"POST /api/reports/export request failed for unsupported format: {e}"

    assert response_422.status_code == 422, f"Expected status 422 for unsupported format, got {response_422.status_code}"


test_reports_export_pdf_api()