## 1.0.6
- Validate and fix all from 1.0.5
- Random Fixes
- + Fixed Refund by fixing transaction date as TxnParams 

## 1.0.5

### Breaking Changes
* **TxnParams**: Removed required `transactionType` parameter. Transaction type is now inferred from the method called (`purchase`, `refund`, etc.).
  ```dart
  // Before
  TxnParams(amount: '10.00', transactionType: TransactionType.PURCHASE);

  // Now
  TxnParams(amount: '10.00');
  ```

* **Transaction.txnDate**: Changed from `String?` to `DateTime?` for type safety.
  ```dart
  // Before
  Transaction.withRRN('123456', txnDate: '2026-03-14');

  // Now
  Transaction.withRRN('123456', DateTime.now());
  ```

* **Env enum**: Removed `REVAMP` environment. Use `DEVELOPMENT`, `STAGING`, `SANDBOX`, or `PRODUCTION`.

* **Simplified Terminal Binding**: Removed standalone `bindTerminal()` method; terminal binding is now handled through `TerminalBindingTask.bind()`.

### Major Architectural Update
* Complete rewrite of the Dart-Native bridge, migrating away from legacy Pigeon platform channels to a direct MethodChannel approach for robust performance and exact alignment with Native SDK standards.
* **Typed Models**: Replaced generic and risky array structures with strongly-typed Dart models (`TxnParams`, `EdfaPayCredentials`, `Transaction`, `Pagination`, `Location`).
* **Chainable Builders**: Introduced chainable builders for `SdkTheme` and `PresentationConfig` to mirror native implementation.
* **Callback Refactoring**: Flutter side callbacks are now invoked directly with mapped `Function.apply` payloads for seamless error handling and multiple parameter execution.

### Massive API Expansion
The previous versions of the SDK only exposed a fraction of the native capabilities (`purchase`, `refund`, `reconcile`, `txnHistory`, etc.). **1.0.5** directly maps *every* feature available in the Android Native SDK to Flutter.

* **New Transaction Flows**: `authorize`, `capture`, `changePin`, `activateCard`, `void`, `reverse`, `reverseLastTransaction`, and `txnDetail`.
* **New Session Management**: `getSessionId`, `getSessionDetail`, `getSessionList`, `logoutCurrentSession`, and `logoutSession`.
* **New Reconciliation & Terminal Management**: `reconciliationHistory`, `reconciliationDetail`, `reconciliationReceipt`, `terminalInfo`, `activateTerminal`, `deActivateTerminal`, and `syncTerminal`.
* **New Utilities & Extensions**: `EdfaPayPlugin.Extension` (`initKernels`, `loginWithToken`, `getTerminalConfig`, `getUserInfo`, etc.) and `EdfaPayPlugin.Utils` (`getDeviceId`, `currentLocation`, `isLocationMocked`, etc.).

### New Features
* **Terminal Binding Task**: Added `Terminal` and `TerminalBindingTask` models for improved terminal binding workflow.
  ```dart
  EdfaPayPlugin.initiate(
    credentials: credentials,
    onSuccess: (sessionId) => print('Initialized'),
    onTerminalBindingTask: (task) {
      // Show native binding UI or bind programmatically
      task.bind(); // or task.bind(terminal: task.terminals.first);
    },
    onError: (e) => print('Error: $e'),
  );
  ```

* **Extension.getUserInfo()**: New method to retrieve current user information.

* **TxnParams.setOriginalTransaction()**: New method to set original transaction reference for refund/capture operations.

* **BNPL (Buy Now Pay Later)**: Added `buyNowPayLater()` method supporting Tamara and Tabby providers.
  ```dart
  EdfaPayPlugin.buyNowPayLater(
    request: BnplRequest(
      provider: BnplProvider.TAMARA,
      merchantId: 'merchant-id',
      amount: 11100, // in minor units (cents)
      currency: 'SAR',
      phoneNumber: '+966512345678',
      email: 'customer@example.com',
      orderReferenceId: 'ORD-111',
      orderNumber: '10111',
      invoice: BnplInvoice(
        total: 11100,
        lineItems: [
          BnplLineItem(sku: 'SKU-001', description: 'Product', unitCost: 11100, quantity: 1, netTotal: 11100, total: 11100),
        ],
      ),
      additionalData: BnplAdditionalData(storeId: 'STORE-01'),
    ),
    onSuccess: (response) {
      // Launch response.checkoutDeeplink in browser
      print('Checkout URL: ${response.checkoutDeeplink}');
    },
    onError: (e) => print('Error: $e'),
  );
  ```

### Improvements
* **ProcessCompleteCallback Type Alias**: Transaction callbacks now use the `ProcessCompleteCallback` type alias for cleaner method signatures.
* **SdkTheme.setPresentation()**: Improved error messaging and internal code refactoring.

### Bug Fixes & Maintenance
* Improved error stack trace handling in native bridge
* Bug fixes and performance enhancements in MethodChannel communications
* Code cleanup and formatting improvements

* **Documentation Reference**: For full implementation details, see the [EdfaPay SoftPOS SDK Documentation](https://guides.edfapay.com/docs/softpos-sdk).

---

## 0.0.3
* Revamp version of sdk


## 0.0.4
* Revamp version of sdk
* fixes & enhancement


## 0.0.5
* Revamp version of sdk
* fixes & enhancement

## 1.0.0+2
* Revamp version of sdk.
* Fixes & enhancement.
* Fix terminal token login.

## 1.0.0+3
* Added ability to change presentation 
    - Presentation.FULLSCREEN
    - Presentation.DIALOG_CENTER 
    - Presentation.DIALOG_TOP_FILL 
    - Presentation.DIALOG_BOTTOM_FILL 
    - Presentation.DIALOG_TOP_START 
    - Presentation.DIALOG_TOP_END 
    - Presentation.DIALOG_TOP_CENTER 
    - Presentation.DIALOG_BOTTOM_START 
    - Presentation.DIALOG_BOTTOM_END 
    - Presentation.DIALOG_BOTTOM_CENTER
        ```dart
        // Usage:
        EdfaPayPlugin.theme()
            .setPresentation(
                Presentation.DIALOG_CENTER
                    .sizePercent(0.85) // scale to width of screen 1.0 to 0.20
                    .dismissOnBackPress(true) 
                    .dismissOnTouchOutside(true)
                    .animateExit(true)
                    .animateEntry(true)
                    .dimBackground(true)
                    .dimAmount(1.0) // scale to 1.0 to 0.0
                    .marginAll(0) // open number
                    .cornerRadius(20)  // open number
                    .marginHorizontal(10)  // open number
                    .marginVertical(10)  // open number
                    .setPurchaseSecondaryAction(PurchaseSecondaryAction.none)
            );
        ```
* Added ability enable Secondary/Post Purchase Transaction Action.
    - PurchaseSecondaryAction.reverse
    - PurchaseSecondaryAction.refund
    - PurchaseSecondaryAction.none
      ```dart
      // Usage:
      EdfaPayPlugin.theme()
          .setPresentation(
              Presentation.DIALOG_CENTER
                  .setPurchaseSecondaryAction(PurchaseSecondaryAction.reverse)
          );
      ```
* Added ability to decide UI Flow Type at the time of transaction.
    - FlowType.immediate
    - FlowType.status
    - FlowType.detail
      ```dart
      // Usage:
      EdfaPayPlugin.pay(
          params,
          flowType: FlowType.detail,
          /* */
      );
      ```


## 1.0.4
* Added ability to enable/disable **PIN PAD** shuffles at Pin Transaction.
    ```dart
    // Usage:
    EdfaPayPlugin.theme()
      .setPresentation(
          Presentation.DIALOG_CENTER
              .setShufflePinPad(true); // default false
      );
    ```
  
* Added ability to start transaction from remote source (LocalNetwork).
  * Note: Make sure to open RemoteChannel after successful SDK initialization.
  ```dart
    // Usage: Make sure to open RemoteChannel after initialize successful 
    EdfaPayPlugin.RemoteChannel.LocalNetwork(8080, 3.0).open();
  ```
