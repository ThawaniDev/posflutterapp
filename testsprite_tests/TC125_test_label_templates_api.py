import requests
import uuid

BASE_URL = "http://localhost:8080"
LOGIN_URL = f"{BASE_URL}/api/auth/login"
LABEL_TEMPLATES_URL = f"{BASE_URL}/api/labels/templates"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def authenticate():
    payload = {"email": EMAIL, "password": PASSWORD}
    try:
        resp = requests.post(LOGIN_URL, json=payload, timeout=TIMEOUT)
        resp.raise_for_status()
        token = resp.json().get("access_token") or resp.json().get("token")
        assert token, "Missing access token in login response"
        return token
    except Exception as e:
        raise RuntimeError(f"Authentication failed: {e}")


def test_label_templates_api():
    token = authenticate()
    headers = {"Authorization": f"Bearer {token}", "Content-Type": "application/json"}

    # 1. Verify GET /api/labels/templates lists templates
    resp = requests.get(LABEL_TEMPLATES_URL, headers=headers, timeout=TIMEOUT)
    assert resp.status_code == 200, f"Expected 200 OK, got {resp.status_code}"
    templates = resp.json()
    assert isinstance(templates, list), "Templates response should be a list"

    # 2. POST creates new template with name and layout
    new_template_name = f"Test Template {uuid.uuid4()}"
    new_template_layout = {"width": 50, "height": 30, "elements": []}  # simple layout structure example
    create_payload = {
        "name": new_template_name,
        "layout": new_template_layout
    }

    created_id = None
    try:
        post_resp = requests.post(LABEL_TEMPLATES_URL, headers=headers, json=create_payload, timeout=TIMEOUT)
        assert post_resp.status_code == 201 or post_resp.status_code == 200,\
            f"Expected 201 Created or 200 OK, got {post_resp.status_code}"
        created_template = post_resp.json()
        # Basic assertion for created template
        assert isinstance(created_template, dict), "Created template should be a dict"
        assert created_template.get("name") == new_template_name, "Template name mismatch after creation"
        assert created_template.get("layout") == new_template_layout, "Template layout mismatch after creation"
        created_id = created_template.get("id") or created_template.get("_id")
        assert created_id, "Created template missing ID"
    finally:
        # Clean up by deleting the created template if possible
        if created_id:
            try:
                delete_url = f"{LABEL_TEMPLATES_URL}/{created_id}"
                del_resp = requests.delete(delete_url, headers=headers, timeout=TIMEOUT)
                # Accept 200 OK or 204 No Content as successful deletion
                assert del_resp.status_code in (200, 204), f"Failed to delete template, status {del_resp.status_code}"
            except Exception:
                pass  # best effort cleanup

    # 3. Test 422 for missing name in POST
    invalid_payload = {
        "layout": {"width": 10, "height": 10}
    }
    invalid_resp = requests.post(LABEL_TEMPLATES_URL, headers=headers, json=invalid_payload, timeout=TIMEOUT)
    assert invalid_resp.status_code == 422, f"Expected 422 for missing name, got {invalid_resp.status_code}"


test_label_templates_api()