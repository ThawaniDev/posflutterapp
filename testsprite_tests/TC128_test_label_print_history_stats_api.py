import requests

BASE_URL = "http://localhost:8080"
LOGIN_ENDPOINT = "/api/auth/login"
LABEL_STATS_ENDPOINT = "/api/labels/print-history/stats"
EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"


def test_label_print_history_stats_api():
    session = requests.Session()
    try:
        # Authenticate and get token
        login_resp = session.post(
            f"{BASE_URL}{LOGIN_ENDPOINT}",
            json={"email": EMAIL, "password": PASSWORD},
            timeout=30,
        )
        login_resp.raise_for_status()
        token = login_resp.json().get("token")
        assert token, "Login response missing token"

        headers = {"Authorization": f"Bearer {token}"}

        # Call the label print history stats endpoint
        resp = session.get(f"{BASE_URL}{LABEL_STATS_ENDPOINT}", headers=headers, timeout=30)
        resp.raise_for_status()
        data = resp.json()

        # Validate response contents
        # Expect keys: total_labels_printed, most_used_template, daily_average
        assert isinstance(data, dict), "Response is not a JSON object"
        assert "total_labels_printed" in data, "Missing total_labels_printed in response"
        assert "most_used_template" in data, "Missing most_used_template in response"
        assert "daily_average" in data, "Missing daily_average in response"

        # Validate types and values
        total_labels = data["total_labels_printed"]
        most_used_template = data["most_used_template"]
        daily_avg = data["daily_average"]

        assert isinstance(total_labels, int), "total_labels_printed is not an integer"
        assert total_labels >= 0, "total_labels_printed should be non-negative"

        # most_used_template might be an object/dict with id and name or string,
        # or it could be null if no prints exist - allow null
        assert most_used_template is None or isinstance(most_used_template, (dict, str)), "most_used_template format invalid"

        assert isinstance(daily_avg, (int, float)), "daily_average is not a number"
        assert daily_avg >= 0, "daily_average should be non-negative"

    except requests.RequestException as e:
        assert False, f"HTTP request failed: {e}"

    except AssertionError:
        raise


test_label_print_history_stats_api()