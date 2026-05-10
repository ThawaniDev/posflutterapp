import requests
from datetime import datetime, timedelta

BASE_URL = "http://localhost:8080"
LOGIN_URL = f"{BASE_URL}/api/auth/login"
STOCK_MOVEMENTS_URL = f"{BASE_URL}/api/inventory/stock-movements"

EMAIL = "owner@ostora.sa"
PASSWORD = "owner@ostora.sa"
TIMEOUT = 30


def test_stock_movements_api():
    # Authenticate and obtain token
    try:
        login_resp = requests.post(
            LOGIN_URL,
            json={"email": EMAIL, "password": PASSWORD},
            timeout=TIMEOUT,
        )
        login_resp.raise_for_status()
        token = login_resp.json().get("token") or login_resp.json().get("access_token")
        assert token, "Authentication token not found in login response"
    except Exception as ex:
        raise AssertionError(f"Login failed: {ex}")

    headers = {
        "Authorization": f"Bearer {token}",
        "Accept": "application/json",
    }

    # First, perform an unfiltered request to get sample product_id and date range data
    try:
        resp_all = requests.get(STOCK_MOVEMENTS_URL, headers=headers, timeout=TIMEOUT)
        resp_all.raise_for_status()
        data_all = resp_all.json()
        assert isinstance(data_all, list), "Expected list of stock movements"
        assert len(data_all) >= 0, "Stock movements list should be present"

        # If no data, we can skip filters as no data to filter by
        if not data_all:
            print("No stock movement records found; skipping filter tests")
            return
    except Exception as ex:
        raise AssertionError(f"Failed to get stock movements general list: {ex}")

    # Extract a valid product_id from data if possible
    product_id = None
    for movement in data_all:
        if "product_id" in movement:
            product_id = movement["product_id"]
            break

    # Extract dates from data for filtering; fallback to recent dates
    dates = []
    for movement in data_all:
        date_str = movement.get("date") or movement.get("created_at") or movement.get("movement_date")
        if date_str:
            try:
                # Attempt parse ISO8601 date string
                dt = datetime.fromisoformat(date_str.replace("Z", "+00:00"))
                dates.append(dt)
            except Exception:
                continue
    dates.sort()
    if dates:
        from_date = dates[0].date().isoformat()
        to_date = dates[-1].date().isoformat()
    else:
        today = datetime.utcnow().date()
        from_date = (today - timedelta(days=7)).isoformat()
        to_date = today.isoformat()

    # Test filter by product_id
    if product_id:
        params = {"product_id": product_id}
        try:
            resp_filtered_pid = requests.get(
                STOCK_MOVEMENTS_URL, headers=headers, params=params, timeout=TIMEOUT
            )
            resp_filtered_pid.raise_for_status()
            data_pid = resp_filtered_pid.json()
            assert isinstance(data_pid, list), "Filtered response should be a list"
            # All returned records should match product_id
            for record in data_pid:
                assert (
                    record.get("product_id") == product_id
                ), f"Record product_id {record.get('product_id')} does not match filter {product_id}"
        except Exception as ex:
            raise AssertionError(f"Failed filter by product_id: {ex}")
    else:
        print("No product_id found in stock movements; skipping product_id filter test")

    # Test filter by date range (from_date and to_date)
    params = {"from_date": from_date, "to_date": to_date}
    try:
        resp_filtered_date = requests.get(
            STOCK_MOVEMENTS_URL, headers=headers, params=params, timeout=TIMEOUT
        )
        resp_filtered_date.raise_for_status()
        data_date = resp_filtered_date.json()
        assert isinstance(data_date, list), "Filtered by date response should be a list"

        # Verify dates in the range (inclusive). Date fields: "date", "created_at", "movement_date"
        from_dt = datetime.fromisoformat(from_date)
        to_dt = datetime.fromisoformat(to_date)
        for record in data_date:
            date_str = record.get("date") or record.get("created_at") or record.get("movement_date")
            assert date_str, "Movement record missing date for filtering validation"
            try:
                rec_dt = datetime.fromisoformat(date_str.replace("Z", "+00:00")).date()
            except Exception:
                raise AssertionError(f"Invalid date format in record: {date_str}")
            assert (
                from_dt.date() <= rec_dt <= to_dt.date()
            ), f"Record date {rec_dt} outside filter range {from_dt.date()} to {to_dt.date()}"
    except Exception as ex:
        raise AssertionError(f"Failed filter by date range: {ex}")


test_stock_movements_api()