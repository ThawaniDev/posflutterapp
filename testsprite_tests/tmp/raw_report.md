
# TestSprite AI Testing Report(MCP)

---

## 1️⃣ Document Metadata
- **Project Name:** posflutterapp
- **Date:** 2026-05-06
- **Prepared by:** TestSprite AI Team

---

## 2️⃣ Requirement Validation Summary

#### Test TC001 test_email_password_login_api
- **Test Code:** [TC001_test_email_password_login_api.py](./TC001_test_email_password_login_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 28, in test_email_password_login_api
AssertionError: Expected status 200, got 404

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 71, in <module>
  File "<string>", line 36, in test_email_password_login_api
AssertionError: Valid login test failed: Expected status 200, got 404

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/7262d816-b1dc-4378-804e-1420c7e66b7a
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC002 test_pin_login_api
- **Test Code:** [TC002_test_pin_login_api.py](./TC002_test_pin_login_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 18, in test_pin_login_api
AssertionError: Auth login failed with status 404

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 74, in <module>
  File "<string>", line 23, in test_pin_login_api
AssertionError: Failed to authenticate to get bearer token: Auth login failed with status 404

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/537d4001-f8d5-4a4a-ad64-b03ea29a5643
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC003 test_pos_checkout_api
- **Test Code:** [TC003_test_pos_checkout_api.py](./TC003_test_pos_checkout_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 125, in <module>
  File "<string>", line 24, in test_pos_checkout_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/fee9f671-f465-416d-8cd6-d44c27bac076
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC004 test_void_transaction_api
- **Test Code:** [TC004_test_void_transaction_api.py](./TC004_test_void_transaction_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 20, in test_void_transaction_api
AssertionError: Login failed

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 85, in <module>
  File "<string>", line 24, in test_void_transaction_api
Exception: Authentication failed: Login failed

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/327c43b0-e676-4503-b700-6ab6cbf2cfb0
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC005 test_product_search_api
- **Test Code:** [TC005_test_product_search_api.py](./TC005_test_product_search_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 86, in <module>
  File "<string>", line 20, in test_product_search_api
AssertionError: Login failed

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/9959a31b-ac93-4cf6-9209-0276438706b3
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC006 test_open_cash_shift_api
- **Test Code:** [TC006_test_open_cash_shift_api.py](./TC006_test_open_cash_shift_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 85, in <module>
  File "<string>", line 26, in test_open_cash_shift_api
AssertionError: Login failed with status 404

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/ec42cf31-028b-432b-b2e4-4dff8792ee6a
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC007 test_close_cash_shift_api
- **Test Code:** [TC007_test_close_cash_shift_api.py](./TC007_test_close_cash_shift_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 97, in <module>
  File "<string>", line 21, in test_close_cash_shift_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/73854e57-90ce-47fd-8306-eac55c50e7f5
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC008 test_create_product_api
- **Test Code:** [TC008_test_create_product_api.py](./TC008_test_create_product_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 19, in test_create_product_api
AssertionError: Login failed with status 404

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 85, in <module>
  File "<string>", line 23, in test_create_product_api
AssertionError: Authentication error: Login failed with status 404

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/5dab2866-3825-4bbe-9a74-a80e4587f3ba
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC009 test_import_products_api
- **Test Code:** [TC009_test_import_products_api.py](./TC009_test_import_products_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 21, in test_import_products_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 62, in <module>
  File "<string>", line 26, in test_import_products_api
AssertionError: Authentication request failed: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/86107716-e554-49c1-b28b-67fc6e1c29df
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC010 test_update_product_api
- **Test Code:** [TC010_test_update_product_api.py](./TC010_test_update_product_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 104, in <module>
  File "<string>", line 67, in test_update_product_api
  File "<string>", line 16, in authenticate
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/52abe027-971a-4e71-b3a6-5609412a080d
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC011 test_auth_me_endpoint
- **Test Code:** [TC011_test_auth_me_endpoint.py](./TC011_test_auth_me_endpoint.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 19, in test_auth_me_endpoint
AssertionError: Login failed with status 404

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 74, in <module>
  File "<string>", line 35, in test_auth_me_endpoint
AssertionError: Login request or token extraction failed: Login failed with status 404

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/72f3ebd3-a5f3-47b1-bd56-a11b7eed6261
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC012 test_auth_logout_endpoint
- **Test Code:** [TC012_test_auth_logout_endpoint.py](./TC012_test_auth_logout_endpoint.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 56, in <module>
  File "<string>", line 24, in test_auth_logout_endpoint
AssertionError: Login failed with status 404

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/4ccf3cad-8023-4625-b316-a3f29bd5bc1b
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC013 test_auth_token_refresh
- **Test Code:** [TC013_test_auth_token_refresh.py](./TC013_test_auth_token_refresh.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 68, in <module>
  File "<string>", line 17, in test_auth_token_refresh
AssertionError: Login failed with status 404

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/953b5a47-b1a2-4e40-b2c4-fe6378b5aed1
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC014 test_auth_security_no_token
- **Test Code:** [TC014_test_auth_security_no_token.py](./TC014_test_auth_security_no_token.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 16, in <module>
  File "<string>", line 14, in test_auth_security_no_token
AssertionError: Expected 401 Unauthorized, got 404

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/cd04faa6-ebc9-4675-a885-c0669ae407d3
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC015 test_auth_security_invalid_token
- **Test Code:** [TC015_test_auth_security_invalid_token.py](./TC015_test_auth_security_invalid_token.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 21, in <module>
  File "<string>", line 17, in test_auth_security_invalid_token
AssertionError: Expected status code 401, got 404

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/d4cefe01-209c-460c-a987-ea33cdecb3d1
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC016 test_products_list_api
- **Test Code:** [TC016_test_products_list_api.py](./TC016_test_products_list_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 17, in test_products_list_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 186, in <module>
  File "<string>", line 21, in test_products_list_api
AssertionError: Authentication request failed: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/89fa55bb-590b-45a0-9fa7-c5b8a63e3bb9
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC017 test_products_get_single_api
- **Test Code:** [TC017_test_products_get_single_api.py](./TC017_test_products_get_single_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 83, in <module>
  File "<string>", line 56, in test_products_get_single_api
  File "<string>", line 15, in authenticate
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/90db5b63-e36f-4532-8bc5-5a294c8d9c64
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC018 test_products_update_api
- **Test Code:** [TC018_test_products_update_api.py](./TC018_test_products_update_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 84, in <module>
  File "<string>", line 19, in test_products_update_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/a0bfe058-aadc-44bf-b5f5-be2c4924c86d
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC019 test_products_delete_api
- **Test Code:** [TC019_test_products_delete_api.py](./TC019_test_products_delete_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 61, in <module>
  File "<string>", line 13, in test_products_delete_api
AssertionError

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/a9fff437-3ac3-44b7-8eab-bd6f0c1bfa95
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC020 test_products_search_by_barcode
- **Test Code:** [TC020_test_products_search_by_barcode.py](./TC020_test_products_search_by_barcode.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 71, in <module>
  File "<string>", line 19, in test_products_search_by_barcode
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/e19356f4-f25d-447f-800d-5b010a256bba
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC021 test_categories_crud_api
- **Test Code:** [TC021_test_categories_crud_api.py](./TC021_test_categories_crud_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 18, in test_categories_crud_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 108, in <module>
  File "<string>", line 22, in test_categories_crud_api
AssertionError: Authentication request failed: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/dd844c9f-1134-47c4-af9e-37786b72e3af
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC022 test_suppliers_crud_api
- **Test Code:** [TC022_test_suppliers_crud_api.py](./TC022_test_suppliers_crud_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 16, in test_suppliers_crud_api
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 73, in <module>
  File "<string>", line 20, in test_suppliers_crud_api
AssertionError: Login failed: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/5bfe6665-70b7-47cd-a8bd-9048cce060fc
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC023 test_stock_levels_api
- **Test Code:** [TC023_test_stock_levels_api.py](./TC023_test_stock_levels_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 17, in test_stock_levels_api
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 106, in <module>
  File "<string>", line 19, in test_stock_levels_api
AssertionError: Login request failed: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/05e7c552-7c53-41fa-bb2d-78d7f3fedaf8
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC024 test_stock_adjustments_api
- **Test Code:** [TC024_test_stock_adjustments_api.py](./TC024_test_stock_adjustments_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 78, in <module>
  File "<string>", line 13, in test_stock_adjustments_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/b3ca5800-cddd-4f05-b675-373660498dfe
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC025 test_stock_movements_api
- **Test Code:** [TC025_test_stock_movements_api.py](./TC025_test_stock_movements_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 21, in test_stock_movements_api
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 121, in <module>
  File "<string>", line 25, in test_stock_movements_api
AssertionError: Login failed: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/2971314f-1754-4f67-b73b-a1c47d7140a0
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC026 test_stock_transfers_api
- **Test Code:** [TC026_test_stock_transfers_api.py](./TC026_test_stock_transfers_api.py)
- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/b9291736-36e7-4e98-b9de-6a46f755e5d1
- **Status:** ✅ Passed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC027 test_purchase_orders_api
- **Test Code:** [TC027_test_purchase_orders_api.py](./TC027_test_purchase_orders_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 105, in <module>
  File "<string>", line 17, in test_purchase_orders_api
AssertionError: Login failed

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/0543d10c-86ac-484c-9f52-44cbee6d877b
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC028 test_goods_receipts_api
- **Test Code:** [TC028_test_goods_receipts_api.py](./TC028_test_goods_receipts_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 21, in get_auth_token
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 168, in <module>
  File "<string>", line 133, in test_goods_receipts_api
  File "<string>", line 24, in get_auth_token
RuntimeError: Failed to get auth token: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/213df030-77e0-4872-98d0-624bc3217fb2
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC029 test_stocktakes_api
- **Test Code:** [TC029_test_stocktakes_api.py](./TC029_test_stocktakes_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 77, in <module>
  File "<string>", line 17, in test_stocktakes_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/2b4f6ae4-0639-4a73-9db3-d4519862890c
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC030 test_waste_records_api
- **Test Code:** [TC030_test_waste_records_api.py](./TC030_test_waste_records_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 110, in <module>
  File "<string>", line 25, in test_waste_records_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/96f00f5e-7375-45f5-867a-c4f0a45eb0a2
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC031 test_low_stock_alerts_api
- **Test Code:** [TC031_test_low_stock_alerts_api.py](./TC031_test_low_stock_alerts_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 45, in <module>
  File "<string>", line 19, in test_low_stock_alerts_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/a73e306a-cad6-403c-8e39-f91a3897f024
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC032 test_expiry_alerts_api
- **Test Code:** [TC032_test_expiry_alerts_api.py](./TC032_test_expiry_alerts_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 19, in test_expiry_alerts_api
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 72, in <module>
  File "<string>", line 21, in test_expiry_alerts_api
AssertionError: Authentication failed: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/bdb4ed01-5084-4467-9bd9-702fa5577fe9
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC033 test_pos_sessions_list_api
- **Test Code:** [TC033_test_pos_sessions_list_api.py](./TC033_test_pos_sessions_list_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 42, in <module>
  File "<string>", line 14, in test_pos_sessions_list_api
AssertionError: Login failed with status 404

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/64e8da8e-88d3-4f67-8b47-f956022a4207
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC034 test_pos_session_create_api
- **Test Code:** [TC034_test_pos_session_create_api.py](./TC034_test_pos_session_create_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 16, in authenticate
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 79, in <module>
  File "<string>", line 24, in test_pos_session_create_api
  File "<string>", line 21, in authenticate
RuntimeError: Authentication failed: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/a6d6228d-767f-497c-b00e-401c959f5305
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC035 test_pos_session_close_api
- **Test Code:** [TC035_test_pos_session_close_api.py](./TC035_test_pos_session_close_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 66, in <module>
  File "<string>", line 14, in test_pos_session_close_api
AssertionError: Login failed

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/beab75da-a98a-4ad0-9c5d-78a5615bb520
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC036 test_pos_transactions_list_api
- **Test Code:** [TC036_test_pos_transactions_list_api.py](./TC036_test_pos_transactions_list_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 20, in test_pos_transactions_list_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 101, in <module>
  File "<string>", line 24, in test_pos_transactions_list_api
AssertionError: Login request failed: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/22a35f5a-bd2b-4fcf-964f-3cffb23149fe
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC037 test_pos_held_carts_api
- **Test Code:** [TC037_test_pos_held_carts_api.py](./TC037_test_pos_held_carts_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 61, in <module>
  File "<string>", line 20, in test_pos_held_carts_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/2dca7dbb-8797-4c93-acb6-677a1060c196
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC038 test_pos_terminals_api
- **Test Code:** [TC038_test_pos_terminals_api.py](./TC038_test_pos_terminals_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 16, in test_pos_terminals_api
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 44, in <module>
  File "<string>", line 18, in test_pos_terminals_api
AssertionError: Login request failed: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/d4f90591-a3a5-48b4-a352-b62e73db4256
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC039 test_orders_list_api
- **Test Code:** [TC039_test_orders_list_api.py](./TC039_test_orders_list_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 19, in test_orders_list_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 54, in <module>
  File "<string>", line 23, in test_orders_list_api
AssertionError: Exception during login: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/740dcad1-3a71-40c5-8dbf-88d70876b41a
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC040 test_orders_get_api
- **Test Code:** [TC040_test_orders_get_api.py](./TC040_test_orders_get_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 137, in <module>
  File "<string>", line 19, in test_orders_get_api
AssertionError: Auth failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/92aa50fe-768e-4334-85e0-036e22bc083b
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC041 test_orders_status_update_api
- **Test Code:** [TC041_test_orders_status_update_api.py](./TC041_test_orders_status_update_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 93, in <module>
  File "<string>", line 18, in test_orders_status_update_api
AssertionError: Login failed

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/20987889-9d2d-4c29-becb-e758e0743609
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC042 test_orders_cancel_api
- **Test Code:** [TC042_test_orders_cancel_api.py](./TC042_test_orders_cancel_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 101, in <module>
  File "<string>", line 20, in test_orders_cancel_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/e1742b5a-1911-4761-ac8b-ee410fdb53a3
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC043 test_returns_create_api
- **Test Code:** [TC043_test_returns_create_api.py](./TC043_test_returns_create_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 89, in <module>
  File "<string>", line 43, in test_returns_create_api
  File "<string>", line 18, in authenticate
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/cb6d1772-be1a-4286-8ab4-7ddeb61ff566
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC044 test_returns_list_api
- **Test Code:** [TC044_test_returns_list_api.py](./TC044_test_returns_list_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 19, in test_returns_list_api
AssertionError: Login failed with status 404

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 55, in <module>
  File "<string>", line 24, in test_returns_list_api
AssertionError: Authentication failed: Login failed with status 404

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/a214a8f1-e6ef-4064-9ab1-3924e0f9449f
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC045 test_payments_list_api
- **Test Code:** [TC045_test_payments_list_api.py](./TC045_test_payments_list_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 17, in test_payments_list_api
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 70, in <module>
  File "<string>", line 19, in test_payments_list_api
AssertionError: Authentication failed: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/f21b1e52-b80b-4480-8f81-1a19c31bc832
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC046 test_cash_sessions_api
- **Test Code:** [TC046_test_cash_sessions_api.py](./TC046_test_cash_sessions_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 18, in authenticate
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 97, in <module>
  File "<string>", line 60, in test_cash_sessions_api
  File "<string>", line 25, in authenticate
Exception: Authentication failed: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/0182a041-cd89-4f15-91cc-e37a9f89e018
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC047 test_expenses_crud_api
- **Test Code:** [TC047_test_expenses_crud_api.py](./TC047_test_expenses_crud_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 78, in <module>
  File "<string>", line 21, in test_expenses_crud_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/be1ee244-7418-40af-b2fb-d008efeb62fe
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC048 test_gift_cards_api
- **Test Code:** [TC048_test_gift_cards_api.py](./TC048_test_gift_cards_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 67, in <module>
  File "<string>", line 20, in test_gift_cards_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/32e5df50-c2fc-4e01-8db4-e16ba829e8bd
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC049 test_gift_card_redeem_api
- **Test Code:** [TC049_test_gift_card_redeem_api.py](./TC049_test_gift_card_redeem_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 89, in <module>
  File "<string>", line 50, in test_gift_card_redeem_api
  File "<string>", line 16, in login_get_token
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/5690a093-529d-4893-b60d-6b9684c86e00
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC050 test_finance_daily_summary_api
- **Test Code:** [TC050_test_finance_daily_summary_api.py](./TC050_test_finance_daily_summary_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 17, in test_finance_daily_summary_api
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 54, in <module>
  File "<string>", line 19, in test_finance_daily_summary_api
AssertionError: Login request failed: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/ec3ae758-f1c3-481c-bd23-7a1e23b7716d
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC051 test_finance_reconciliation_api
- **Test Code:** [TC051_test_finance_reconciliation_api.py](./TC051_test_finance_reconciliation_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 60, in <module>
  File "<string>", line 20, in test_finance_reconciliation_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/eea70b02-ccde-4eee-8afb-722d2f7e44ab
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC052 test_payment_refund_api
- **Test Code:** [TC052_test_payment_refund_api.py](./TC052_test_payment_refund_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 127, in <module>
  File "<string>", line 85, in test_payment_refund_api
  File "<string>", line 17, in authenticate
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/9b9f8285-a5a6-49b8-bb1e-199df79db851
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC053 test_customers_list_api
- **Test Code:** [TC053_test_customers_list_api.py](./TC053_test_customers_list_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 71, in <module>
  File "<string>", line 31, in test_customers_list_api
AssertionError: Expected 401 without auth, got 404

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/21e2a0eb-7c54-44fe-8777-424d353493cb
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC054 test_customers_create_api
- **Test Code:** [TC054_test_customers_create_api.py](./TC054_test_customers_create_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 94, in <module>
  File "<string>", line 25, in test_customers_create_api
  File "<string>", line 12, in login
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/02d36644-5b24-45ff-94e8-4fff4712fea8
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC055 test_customers_get_api
- **Test Code:** [TC055_test_customers_get_api.py](./TC055_test_customers_get_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 82, in <module>
  File "<string>", line 20, in test_customers_get_api
AssertionError: Login failed

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/5250d155-74a3-46ed-9335-20a4e6e73441
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC056 test_customers_update_api
- **Test Code:** [TC056_test_customers_update_api.py](./TC056_test_customers_update_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 112, in <module>
  File "<string>", line 44, in test_customers_update_api
  File "<string>", line 18, in authenticate
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/85af099b-2522-47bc-a1e0-75d2f8ca7c6c
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC057 test_customers_delete_api
- **Test Code:** [TC057_test_customers_delete_api.py](./TC057_test_customers_delete_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 87, in <module>
  File "<string>", line 25, in test_customers_delete_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/48cf9ac0-fd18-4531-8711-284dc386f40b
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC058 test_customers_search_api
- **Test Code:** [TC058_test_customers_search_api.py](./TC058_test_customers_search_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 19, in test_customers_search_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 57, in <module>
  File "<string>", line 23, in test_customers_search_api
AssertionError: Exception during login: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/bad56ff6-c5f2-4ac4-98bb-29bcf8841cf9
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC059 test_customer_orders_api
- **Test Code:** [TC059_test_customer_orders_api.py](./TC059_test_customer_orders_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 82, in <module>
  File "<string>", line 17, in test_customer_orders_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/eae27e15-e2af-443f-b92e-88b407a6e0af
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC060 test_customer_loyalty_adjust_api
- **Test Code:** [TC060_test_customer_loyalty_adjust_api.py](./TC060_test_customer_loyalty_adjust_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 105, in <module>
  File "<string>", line 17, in test_customer_loyalty_adjust_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/f317f6e0-3567-4381-80e9-f5cc3e6d30cb
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC061 test_customer_loyalty_redeem_api
- **Test Code:** [TC061_test_customer_loyalty_redeem_api.py](./TC061_test_customer_loyalty_redeem_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 75, in <module>
  File "<string>", line 18, in test_customer_loyalty_redeem_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/094bbcb0-2c4c-4dc2-9838-439f9d33ca4f
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC062 test_customer_store_credit_api
- **Test Code:** [TC062_test_customer_store_credit_api.py](./TC062_test_customer_store_credit_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 19, in test_customer_store_credit_api
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 86, in <module>
  File "<string>", line 21, in test_customer_store_credit_api
AssertionError: Authentication request failed: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/8c585b27-a524-45ea-a7c3-844c5036ea75
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC063 test_customer_groups_api
- **Test Code:** [TC063_test_customer_groups_api.py](./TC063_test_customer_groups_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 24, in test_customer_groups_api
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 96, in <module>
  File "<string>", line 29, in test_customer_groups_api
AssertionError: Login failed: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/5356be6e-b169-46c7-a07e-4a0f8721c12c
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC064 test_dashboard_summary_api
- **Test Code:** [TC064_test_dashboard_summary_api.py](./TC064_test_dashboard_summary_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 36, in <module>
  File "<string>", line 13, in test_dashboard_summary_api
AssertionError: Expected 401 without auth, got 404

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/1e9b304f-a657-4317-b0a6-87aa67ae3ea0
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC065 test_dashboard_sales_trend_api
- **Test Code:** [TC065_test_dashboard_sales_trend_api.py](./TC065_test_dashboard_sales_trend_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 23, in test_dashboard_sales_trend_api
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 68, in <module>
  File "<string>", line 25, in test_dashboard_sales_trend_api
AssertionError: Authentication failed: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/e79cad6f-dc00-4d1f-9df6-3e4ad8965b32
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC066 test_dashboard_top_products_api
- **Test Code:** [TC066_test_dashboard_top_products_api.py](./TC066_test_dashboard_top_products_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 18, in test_dashboard_top_products_api
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 60, in <module>
  File "<string>", line 20, in test_dashboard_top_products_api
AssertionError: Login request failed: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/e38f1998-6367-410e-bae6-af8099b7e9b3
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC067 test_dashboard_recent_orders_api
- **Test Code:** [TC067_test_dashboard_recent_orders_api.py](./TC067_test_dashboard_recent_orders_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 41, in <module>
  File "<string>", line 15, in test_dashboard_recent_orders_api
AssertionError: Login failed with status 404

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/e70947b8-e53d-4081-ac85-b2b6d42bc59e
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC068 test_dashboard_financial_summary_api
- **Test Code:** [TC068_test_dashboard_financial_summary_api.py](./TC068_test_dashboard_financial_summary_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 54, in <module>
  File "<string>", line 24, in test_dashboard_financial_summary_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/1341778f-dbd3-4640-9b81-7b3159a0274c
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC069 test_dashboard_active_cashiers_api
- **Test Code:** [TC069_test_dashboard_active_cashiers_api.py](./TC069_test_dashboard_active_cashiers_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 18, in test_dashboard_active_cashiers_api
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 52, in <module>
  File "<string>", line 20, in test_dashboard_active_cashiers_api
AssertionError: Login request failed: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/6077123b-6dc7-4fcf-b358-a08eabf02aad
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC070 test_dashboard_hourly_sales_api
- **Test Code:** [TC070_test_dashboard_hourly_sales_api.py](./TC070_test_dashboard_hourly_sales_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 19, in test_dashboard_hourly_sales_api
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 49, in <module>
  File "<string>", line 21, in test_dashboard_hourly_sales_api
AssertionError: Authentication request failed: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/8616a5e1-efe4-437a-b2dd-06c2d647d1b5
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC071 test_dashboard_branches_api
- **Test Code:** [TC071_test_dashboard_branches_api.py](./TC071_test_dashboard_branches_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 18, in test_dashboard_branches_api
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 74, in <module>
  File "<string>", line 20, in test_dashboard_branches_api
AssertionError: Login request failed: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/fa997712-5d57-4ad5-a12a-b8a6d61195b9
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC072 test_reports_sales_summary_api
- **Test Code:** [TC072_test_reports_sales_summary_api.py](./TC072_test_reports_sales_summary_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 49, in <module>
  File "<string>", line 16, in test_reports_sales_summary_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/9ec92f11-a468-4eef-875c-d4dd5b7645d8
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC073 test_reports_daily_sales_api
- **Test Code:** [TC073_test_reports_daily_sales_api.py](./TC073_test_reports_daily_sales_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 18, in test_reports_daily_sales_api
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 80, in <module>
  File "<string>", line 20, in test_reports_daily_sales_api
AssertionError: Login request failed: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/c7198262-b297-4abd-a2af-6b2c189393e7
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC074 test_reports_product_sales_api
- **Test Code:** [TC074_test_reports_product_sales_api.py](./TC074_test_reports_product_sales_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 75, in <module>
  File "<string>", line 21, in test_reports_product_sales_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/15e68faa-e2a7-44c4-ac38-c667a12a1c85
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC075 test_reports_product_performance_api
- **Test Code:** [TC075_test_reports_product_performance_api.py](./TC075_test_reports_product_performance_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 43, in <module>
  File "<string>", line 18, in test_reports_product_performance_api
AssertionError: Auth failed with status 404

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/afd11c04-29b3-4fa7-a25f-969936e48e60
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC076 test_reports_category_breakdown_api
- **Test Code:** [TC076_test_reports_category_breakdown_api.py](./TC076_test_reports_category_breakdown_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 73, in <module>
  File "<string>", line 17, in test_reports_category_breakdown_api
AssertionError: Login failed with status 404

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/f2f50910-170d-428f-92e4-7aef35514fc4
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC077 test_reports_staff_performance_api
- **Test Code:** [TC077_test_reports_staff_performance_api.py](./TC077_test_reports_staff_performance_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 57, in <module>
  File "<string>", line 19, in test_reports_staff_performance_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/2b56c123-9985-4d3c-a48b-825afda607ba
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC078 test_reports_payment_methods_api
- **Test Code:** [TC078_test_reports_payment_methods_api.py](./TC078_test_reports_payment_methods_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 56, in <module>
  File "<string>", line 19, in test_reports_payment_methods_api
AssertionError: Login failed with status 404

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/06c700ce-9706-4d67-b6b5-88181ddc982b
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC079 test_reports_inventory_valuation_api
- **Test Code:** [TC079_test_reports_inventory_valuation_api.py](./TC079_test_reports_inventory_valuation_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 18, in test_reports_inventory_valuation_api
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 64, in <module>
  File "<string>", line 22, in test_reports_inventory_valuation_api
AssertionError: Authentication failed: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/3f627baa-2e58-4167-89bb-c07c689b4175
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC080 test_reports_inventory_turnover_api
- **Test Code:** [TC080_test_reports_inventory_turnover_api.py](./TC080_test_reports_inventory_turnover_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 17, in test_reports_inventory_turnover_api
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 58, in <module>
  File "<string>", line 23, in test_reports_inventory_turnover_api
AssertionError: Login request failed: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/e3056a95-19f2-4c76-86c7-6dce135082e2
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC081 test_reports_inventory_shrinkage_api
- **Test Code:** [TC081_test_reports_inventory_shrinkage_api.py](./TC081_test_reports_inventory_shrinkage_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 19, in test_reports_inventory_shrinkage_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 93, in <module>
  File "<string>", line 24, in test_reports_inventory_shrinkage_api
AssertionError: Exception during login: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/49df1822-2de5-4b97-a934-c3ecef6f5d1c
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC082 test_reports_financial_daily_pl_api
- **Test Code:** [TC082_test_reports_financial_daily_pl_api.py](./TC082_test_reports_financial_daily_pl_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 42, in <module>
  File "<string>", line 19, in test_reports_financial_daily_pl_api
AssertionError: Login failed with status 404

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/207bb68f-47ce-4096-8c3f-055745a836e1
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC083 test_reports_financial_cash_variance_api
- **Test Code:** [TC083_test_reports_financial_cash_variance_api.py](./TC083_test_reports_financial_cash_variance_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 20, in test_reports_financial_cash_variance_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 49, in <module>
  File "<string>", line 25, in test_reports_financial_cash_variance_api
AssertionError: Exception during login: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/4e828b11-1b77-48dd-8099-83f287b29c73
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC084 test_reports_top_customers_api
- **Test Code:** [TC084_test_reports_top_customers_api.py](./TC084_test_reports_top_customers_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 60, in <module>
  File "<string>", line 19, in test_reports_top_customers_api
AssertionError: Login failed with status code 404

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/08924a69-a945-4d7c-8025-25d7e9bbd1fb
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC085 test_reports_export_pdf_api
- **Test Code:** [TC085_test_reports_export_pdf_api.py](./TC085_test_reports_export_pdf_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 17, in test_reports_export_pdf_api
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 52, in <module>
  File "<string>", line 19, in test_reports_export_pdf_api
AssertionError: Login request failed: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/8687464c-4dfa-49bf-b972-2d23cba91233
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC086 test_staff_members_list_api
- **Test Code:** [TC086_test_staff_members_list_api.py](./TC086_test_staff_members_list_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 56, in <module>
  File "<string>", line 29, in test_staff_members_list_api
AssertionError: Expected 401 Unauthorized without auth but got 404

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/4b99a6ee-cfd2-4e61-9293-95044221761b
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC087 test_staff_members_create_api
- **Test Code:** [TC087_test_staff_members_create_api.py](./TC087_test_staff_members_create_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 20, in test_staff_members_create_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 105, in <module>
  File "<string>", line 24, in test_staff_members_create_api
AssertionError: Authentication failed: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/9ff37490-8a16-4f4a-8cea-81abf89f3c09
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC088 test_staff_members_get_api
- **Test Code:** [TC088_test_staff_members_get_api.py](./TC088_test_staff_members_get_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 86, in <module>
  File "<string>", line 17, in test_staff_members_get_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/1469e0a2-1125-4510-b27f-21d8b993c1ba
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC089 test_staff_members_update_api
- **Test Code:** [TC089_test_staff_members_update_api.py](./TC089_test_staff_members_update_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 116, in <module>
  File "<string>", line 58, in test_staff_members_update_api
  File "<string>", line 13, in login_and_get_token
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/14346bde-0380-4032-8fc1-5733f38d0678
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC090 test_staff_members_delete_api
- **Test Code:** [TC090_test_staff_members_delete_api.py](./TC090_test_staff_members_delete_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 63, in <module>
  File "<string>", line 18, in test_staff_members_delete_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/eead4d7a-df1d-46b8-92b9-82cf2ddae8be
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC091 test_staff_pin_update_api
- **Test Code:** [TC091_test_staff_pin_update_api.py](./TC091_test_staff_pin_update_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 74, in <module>
  File "<string>", line 16, in test_staff_pin_update_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/b6381b7f-6330-4f28-8646-d413d2681ea7
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC092 test_staff_roles_crud_api
- **Test Code:** [TC092_test_staff_roles_crud_api.py](./TC092_test_staff_roles_crud_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 71, in <module>
  File "<string>", line 15, in test_staff_roles_crud_api
AssertionError: Login failed with status 404

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/ed0ae218-9aae-4290-b84a-02b906d0b353
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC093 test_staff_permissions_api
- **Test Code:** [TC093_test_staff_permissions_api.py](./TC093_test_staff_permissions_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 18, in test_staff_permissions_api
AssertionError: Login failed with status 404

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 61, in <module>
  File "<string>", line 23, in test_staff_permissions_api
AssertionError: Authentication request failed: Login failed with status 404

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/cfb757d4-e56e-411c-bedc-c78f7a02c038
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC094 test_staff_attendance_clock_api
- **Test Code:** [TC094_test_staff_attendance_clock_api.py](./TC094_test_staff_attendance_clock_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 20, in test_staff_attendance_clock_api
AssertionError: Login failed with status 404

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 76, in <module>
  File "<string>", line 24, in test_staff_attendance_clock_api
AssertionError: Login request failed: Login failed with status 404

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/060d0b2b-b675-4352-b5f6-42317df68373
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC095 test_staff_attendance_list_api
- **Test Code:** [TC095_test_staff_attendance_list_api.py](./TC095_test_staff_attendance_list_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 20, in test_staff_attendance_list_api
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 64, in <module>
  File "<string>", line 22, in test_staff_attendance_list_api
AssertionError: Authentication request failed: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/e5ff1c61-3d41-491f-b3ef-b2e1f5c5f092
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC096 test_staff_shifts_api
- **Test Code:** [TC096_test_staff_shifts_api.py](./TC096_test_staff_shifts_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 89, in <module>
  File "<string>", line 17, in test_staff_shifts_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/b26191eb-42f2-4b17-8bed-2ee8c9402fb4
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC097 test_pin_override_check_api
- **Test Code:** [TC097_test_pin_override_check_api.py](./TC097_test_pin_override_check_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 17, in test_pin_override_check_api
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 64, in <module>
  File "<string>", line 59, in test_pin_override_check_api
AssertionError: HTTP request failed: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/02f46043-853a-429a-a45e-01f8221cb14f
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC098 test_staff_member_activity_log_api
- **Test Code:** [TC098_test_staff_member_activity_log_api.py](./TC098_test_staff_member_activity_log_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 2, in <module>
ModuleNotFoundError: No module named 'pytest'

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/08cec31c-9430-40c9-a5f5-81610a82fbf2
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC099 test_notifications_list_api
- **Test Code:** [TC099_test_notifications_list_api.py](./TC099_test_notifications_list_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 59, in <module>
  File "<string>", line 16, in test_notifications_list_api
AssertionError: Expected 401 Unauthorized without auth, got 404

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/88598463-dfb9-4ac1-b082-a99b4d82691e
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC100 test_notifications_unread_count_api
- **Test Code:** [TC100_test_notifications_unread_count_api.py](./TC100_test_notifications_unread_count_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 21, in test_notifications_unread_count_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 68, in <module>
  File "<string>", line 25, in test_notifications_unread_count_api
RuntimeError: Authentication error: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/5a2020db-b338-4221-a84b-a118a17dd743
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC101 test_notifications_read_all_api
- **Test Code:** [TC101_test_notifications_read_all_api.py](./TC101_test_notifications_read_all_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 65, in <module>
  File "<string>", line 21, in test_notifications_read_all_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/cf2aec4d-0021-4ac8-8e2d-4db9518c9a24
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC102 test_notification_preferences_api
- **Test Code:** [TC102_test_notification_preferences_api.py](./TC102_test_notification_preferences_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 73, in <module>
  File "<string>", line 19, in test_notification_preferences_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/a0dcb9d6-46d1-476e-ab8d-90ae3948d3ad
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC103 test_promotions_list_api
- **Test Code:** [TC103_test_promotions_list_api.py](./TC103_test_promotions_list_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 56, in <module>
  File "<string>", line 17, in test_promotions_list_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/f001de9c-97de-4058-8536-629a2f54e984
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC104 test_promotions_create_api
- **Test Code:** [TC104_test_promotions_create_api.py](./TC104_test_promotions_create_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 71, in <module>
  File "<string>", line 18, in test_promotions_create_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/8afd136a-ac82-46d6-86c3-c085755f1cfa
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC105 test_promotions_toggle_api
- **Test Code:** [TC105_test_promotions_toggle_api.py](./TC105_test_promotions_toggle_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 2, in <module>
ModuleNotFoundError: No module named 'pytest'

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/d14231ae-87db-4050-b0df-eb3185b3705a
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC106 test_promotions_duplicate_api
- **Test Code:** [TC106_test_promotions_duplicate_api.py](./TC106_test_promotions_duplicate_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 67, in <module>
  File "<string>", line 16, in test_promotions_duplicate_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/a2dd5751-7609-4c4a-b3d8-a147d89fb4bf
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC107 test_coupon_validate_api
- **Test Code:** [TC107_test_coupon_validate_api.py](./TC107_test_coupon_validate_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 67, in <module>
  File "<string>", line 17, in test_coupon_validate_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/e55bde49-017e-4fa3-b8b8-ed147a1ed0ab
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC108 test_coupon_redeem_api
- **Test Code:** [TC108_test_coupon_redeem_api.py](./TC108_test_coupon_redeem_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 22, in test_coupon_redeem_api
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 93, in <module>
  File "<string>", line 26, in test_coupon_redeem_api
AssertionError: Authentication failed: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/5f4ecc63-5d41-4a8c-9e39-abfd69183132
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC109 test_promotions_evaluate_api
- **Test Code:** [TC109_test_promotions_evaluate_api.py](./TC109_test_promotions_evaluate_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 16, in test_promotions_evaluate_api
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 78, in <module>
  File "<string>", line 20, in test_promotions_evaluate_api
AssertionError: Authentication failed: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/fb187e33-1c3f-43d4-ad83-630a42cc67f7
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC110 test_config_feature_flags_api
- **Test Code:** [TC110_test_config_feature_flags_api.py](./TC110_test_config_feature_flags_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 17, in test_config_feature_flags_api
AssertionError: Login failed, status code: 404

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 51, in <module>
  File "<string>", line 23, in test_config_feature_flags_api
AssertionError: Authentication failed: Login failed, status code: 404

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/72a938f2-f744-4c5c-b91a-008c2f524d96
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC111 test_config_maintenance_api
- **Test Code:** [TC111_test_config_maintenance_api.py](./TC111_test_config_maintenance_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 10, in test_config_maintenance_api
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/config/maintenance

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 23, in <module>
  File "<string>", line 12, in test_config_maintenance_api
AssertionError: Request failed: 404 Client Error: Not Found for url: http://localhost:8080/api/config/maintenance

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/c7faeb97-c8f1-45a2-bb5c-236a545d0229
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC112 test_config_tax_api
- **Test Code:** [TC112_test_config_tax_api.py](./TC112_test_config_tax_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 43, in <module>
  File "<string>", line 18, in test_config_tax_api
AssertionError: Login failed with status 404

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/9d4f4462-11fc-4a06-ac41-0abe8004853a
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC113 test_config_payment_methods_api
- **Test Code:** [TC113_test_config_payment_methods_api.py](./TC113_test_config_payment_methods_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 16, in test_config_payment_methods_api
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 41, in <module>
  File "<string>", line 18, in test_config_payment_methods_api
AssertionError: Login request failed: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/f8ae650b-3240-4eb1-827b-e9aad50eb56d
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC114 test_config_security_policies_api
- **Test Code:** [TC114_test_config_security_policies_api.py](./TC114_test_config_security_policies_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 20, in test_config_security_policies_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 55, in <module>
  File "<string>", line 25, in test_config_security_policies_api
AssertionError: Authentication error: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/d3f0919e-8461-4263-b240-2d840b177677
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC115 test_subscription_plans_api
- **Test Code:** [TC115_test_subscription_plans_api.py](./TC115_test_subscription_plans_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 54, in <module>
  File "<string>", line 19, in test_subscription_plans_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/180b20e0-a347-4105-a157-420e71c39638
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC116 test_subscription_current_api
- **Test Code:** [TC116_test_subscription_current_api.py](./TC116_test_subscription_current_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 20, in test_subscription_current_api
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 53, in <module>
  File "<string>", line 22, in test_subscription_current_api
AssertionError: Login request failed: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/149e97f7-aa4f-4b5d-a1f3-828286e06fa9
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC117 test_subscription_usage_api
- **Test Code:** [TC117_test_subscription_usage_api.py](./TC117_test_subscription_usage_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 17, in test_subscription_usage_api
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 53, in <module>
  File "<string>", line 48, in test_subscription_usage_api
AssertionError: HTTP request failed: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/b7e71175-8f63-468c-9fb4-8ed0828b0a20
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC118 test_subscription_invoices_api
- **Test Code:** [TC118_test_subscription_invoices_api.py](./TC118_test_subscription_invoices_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 17, in test_subscription_invoices_api
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 50, in <module>
  File "<string>", line 19, in test_subscription_invoices_api
AssertionError: Login request failed: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/ffc5b819-0bd0-4e1d-a5b0-c2f2156d027c
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC119 test_subscription_check_feature_api
- **Test Code:** [TC119_test_subscription_check_feature_api.py](./TC119_test_subscription_check_feature_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 18, in test_subscription_check_feature_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 49, in <module>
  File "<string>", line 47, in test_subscription_check_feature_api
AssertionError: Test failed: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/ef8296d4-f401-40ec-84c7-a9d0a2b2747a
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC120 test_stores_mine_api
- **Test Code:** [TC120_test_stores_mine_api.py](./TC120_test_stores_mine_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 18, in test_stores_mine_api
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 57, in <module>
  File "<string>", line 20, in test_stores_mine_api
AssertionError: Authentication request failed: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/1271b2b3-797f-4f32-863a-2cd80a43652a
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC121 test_business_types_public_api
- **Test Code:** [TC121_test_business_types_public_api.py](./TC121_test_business_types_public_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 11, in test_business_types_public_api
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/onboarding/business-types

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 27, in <module>
  File "<string>", line 13, in test_business_types_public_api
AssertionError: Request to http://localhost:8080/api/onboarding/business-types failed: 404 Client Error: Not Found for url: http://localhost:8080/api/onboarding/business-types

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/758384ac-f6d3-42cb-8bda-7c8af8d956dc
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC122 test_onboarding_steps_api
- **Test Code:** [TC122_test_onboarding_steps_api.py](./TC122_test_onboarding_steps_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 55, in <module>
  File "<string>", line 23, in test_onboarding_steps_api
AssertionError: Login failed: 404 <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/c56375a9-5b02-49fb-b019-92826a2d241d
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC123 test_onboarding_complete_step_api
- **Test Code:** [TC123_test_onboarding_complete_step_api.py](./TC123_test_onboarding_complete_step_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 21, in test_onboarding_store_api
AssertionError: Onboarding failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 30, in <module>
  File "<string>", line 27, in test_onboarding_store_api
AssertionError: Onboarding request exception: Onboarding failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/7ef5f60c-e478-428c-b25a-4f9b012d5fee
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC124 test_onboarding_checklist_api
- **Test Code:** [TC124_test_onboarding_checklist_api.py](./TC124_test_onboarding_checklist_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 19, in test_onboarding_checklist_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 58, in <module>
  File "<string>", line 24, in test_onboarding_checklist_api
AssertionError: Login request or verification failed: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/8f56e768-f256-4f52-b776-3a7e0fa9811e
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC125 test_label_templates_api
- **Test Code:** [TC125_test_label_templates_api.py](./TC125_test_label_templates_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 16, in authenticate
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 73, in <module>
  File "<string>", line 25, in test_label_templates_api
  File "<string>", line 21, in authenticate
RuntimeError: Authentication failed: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/c63fe4bf-c5b0-4b5b-9ce2-849bacc1b187
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC126 test_label_presets_api
- **Test Code:** [TC126_test_label_presets_api.py](./TC126_test_label_presets_api.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 72, in <module>
  File "<string>", line 20, in test_label_presets_api
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/88b55bcc-2170-4554-a10a-bc78610daa57
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC127 test_label_print_history_api
- **Test Code:** [TC127_test_label_print_history_api.py](./TC127_test_label_print_history_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 16, in test_label_templates_api
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 38, in <module>
  File "<string>", line 20, in test_label_templates_api
AssertionError: Login request failed: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/643d5cdb-0df6-4393-889b-914b5d015c41
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC128 test_label_print_history_stats_api
- **Test Code:** [TC128_test_label_print_history_stats_api.py](./TC128_test_label_print_history_stats_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 19, in test_label_print_history_stats_api
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 59, in <module>
  File "<string>", line 53, in test_label_print_history_stats_api
AssertionError: HTTP request failed: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/6f06e656-af43-42b2-a98b-373c7f64d0c7
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC129 test_role_based_access_cashier
- **Test Code:** [TC129_test_role_based_access_cashier.py](./TC129_test_role_based_access_cashier.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 18, in test_role_based_access_cashier
AssertionError: Login failed with status 404: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 37, in <module>
  File "<string>", line 23, in test_role_based_access_cashier
AssertionError: Cashier login failed: Login failed with status 404: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/8b69b70b-2ff9-458b-a8c4-3e040d83006f
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC130 test_role_based_access_owner
- **Test Code:** [TC130_test_role_based_access_owner.py](./TC130_test_role_based_access_owner.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 14, in authenticate
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 71, in <module>
  File "<string>", line 31, in test_role_based_access_owner
  File "<string>", line 24, in authenticate
RuntimeError: Authentication failed for owner@ostora.sa: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/3da3b3d2-4da0-4096-9242-a1a8d1afee40
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC131 test_input_validation_xss_prevention
- **Test Code:** [TC131_test_input_validation_xss_prevention.py](./TC131_test_input_validation_xss_prevention.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 74, in <module>
  File "<string>", line 20, in test_input_validation_xss_prevention
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/3594e999-8434-4f30-804a-6255f25f7fae
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC132 test_input_validation_sql_injection_prevention
- **Test Code:** [TC132_test_input_validation_sql_injection_prevention.py](./TC132_test_input_validation_sql_injection_prevention.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 19, in test_input_validation_sql_injection_prevention
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 68, in <module>
  File "<string>", line 23, in test_input_validation_sql_injection_prevention
AssertionError: Authentication failed: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/799759ea-8218-4724-baba-b5af05d2c8b5
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC133 test_pagination_api
- **Test Code:** [TC133_test_pagination_api.py](./TC133_test_pagination_api.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 15, in authenticate
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 172, in <module>
  File "<string>", line 24, in test_pagination_api
  File "<string>", line 20, in authenticate
Exception: Authentication failed: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/238a8246-2420-43f3-89b1-179653ea4d17
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC134 test_concurrent_pos_sessions
- **Test Code:** [TC134_test_concurrent_pos_sessions.py](./TC134_test_concurrent_pos_sessions.py)
- **Test Error:** Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 73, in <module>
  File "<string>", line 16, in test_concurrent_pos_sessions
AssertionError: Login failed: <!DOCTYPE html><head> <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/> <style> body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; cursor: default; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; } main, aside, section { display: flex; justify-content: center; align-items: center; flex-direction: column; } main { height: 100%; } aside { background: #000; flex-shrink: 1; padding: 30px 20px; } aside p { margin: 0; color: #999999; font-size: 14px; line-height: 24px; } aside a { color: #fff; text-decoration: none; } section span { font-size: 24px; font-weight: 500; display: block; border-bottom: 1px solid #EAEAEA; text-align: center; padding-bottom: 20px; width: 100px; } section p { font-size: 14px; font-weight: 400; } section span + p { margin: 20px 0 0 0; } @media (min-width: 768px) { section { height: 40px; flex-direction: row; } section span, section p { height: 100%; line-height: 40px; } section span { border-bottom: 0; border-right: 1px solid #EAEAEA; padding: 0 20px 0 0; width: auto; } section span + p { margin: 0; padding-left: 20px; } aside { padding: 50px 0; } aside p { max-width: 520px; text-align: center; } } </style></head><body> <main> <section> <span>404</span> <p>The requested path could not be found</p> </section> </main></body>

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/db0295e9-6480-486e-b7b0-2f97473ff282
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---

#### Test TC135 test_inventory_insufficient_stock_checkout
- **Test Code:** [TC135_test_inventory_insufficient_stock_checkout.py](./TC135_test_inventory_insufficient_stock_checkout.py)
- **Test Error:** Traceback (most recent call last):
  File "<string>", line 21, in test_inventory_insufficient_stock_checkout
  File "/var/lang/lib/python3.12/site-packages/requests/models.py", line 1024, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
requests.exceptions.HTTPError: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/var/task/handler.py", line 258, in run_with_retry
    exec(code, exec_env)
  File "<string>", line 104, in <module>
  File "<string>", line 25, in test_inventory_insufficient_stock_checkout
AssertionError: Authentication failed: 404 Client Error: Not Found for url: http://localhost:8080/api/auth/login

- **Test Visualization and Result:** https://www.testsprite.com/dashboard/mcp/tests/37b38920-7760-4145-8e84-8e48643cf402/cbf29e93-d546-49c8-b49f-b18366e9965d
- **Status:** ❌ Failed
- **Analysis / Findings:** {{TODO:AI_ANALYSIS}}.
---


## 3️⃣ Coverage & Matching Metrics

- **0.74** of tests passed

| Requirement        | Total Tests | ✅ Passed | ❌ Failed  |
|--------------------|-------------|-----------|------------|
| ...                | ...         | ...       | ...        |
---


## 4️⃣ Key Gaps / Risks
{AI_GNERATED_KET_GAPS_AND_RISKS}
---