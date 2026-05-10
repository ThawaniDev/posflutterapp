import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
SUBSCRIPTION_PLANS_ENDPOINT = "/api/subscription/plans"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_subscription_plans_api():
    try:
        # Step 1: Authenticate and get token
        login_response = requests.post(
            url=BASE_URL + LOGIN_ENDPOINT,
            json={"email": EMAIL, "password": PASSWORD},
            timeout=TIMEOUT,
        )
        assert login_response.status_code == 200, f"Login failed: {login_response.text}"
        token = login_response.json().get("token") or login_response.json().get("access_token")
        assert token, "No token found in login response"

        headers = {
            "Authorization": f"Bearer {token}"
        }

        # Step 2: Call /api/subscription/plans endpoint using GET
        plans_response = requests.get(
            url=BASE_URL + SUBSCRIPTION_PLANS_ENDPOINT,
            headers=headers,
            timeout=TIMEOUT,
        )
        assert plans_response.status_code == 200, f"Failed to get subscription plans: {plans_response.text}"
        plans = plans_response.json()

        # Validate response is list/array
        assert isinstance(plans, list), "Response is not a list of plans"

        # Validate keys in each plan: name, price, feature limits (at least check keys)
        for plan in plans:
            assert isinstance(plan, dict), "Plan item is not a JSON object"
            assert "name" in plan, "Plan missing 'name'"
            assert "price" in plan, "Plan missing 'price'"
            # The feature limits key might be named differently; search for keys that represent limits
            # We'll check for presence of at least one feature limit field - commonly in 'features', 'limits' or similar
            feature_limit_keys = ["features", "feature_limits", "limits", "features_limits"]
            has_feature_limits = any(key in plan for key in feature_limit_keys)
            assert has_feature_limits, f"Plan {plan.get('name', '')} missing feature limits field"

    except requests.RequestException as e:
        assert False, f"Request exception occurred: {e}"


test_subscription_plans_api()