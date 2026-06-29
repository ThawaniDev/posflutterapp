# Revamped Flutter Edfapay SoftPOS SDK
<h3>Helps developers to easly integrate EdfaPay SoftPos to flutter mobile application with few simple steps. </h3>

### [Wiki & Documentation](https://github.com/edfapay/edfapay-softpos-sdk-examples/wiki)


# EdfaPay SoftPos SDK
> [!IMPORTANT]
> ### Install edfapay-softpos-sdk
> - **Add the dependency in to your project by running terminal command `pub add`** at project directory.
> ```terminal
> flutter pub add edfapay_softpos_sdk
> ```
> 
> - **or add the dependency in to project `pubspec.yaml`**
> ```yaml
>  dependencies:
>    edfapay_softpos_sdk: 1.0.0+1 # or specify 'any' to always look for the latest version
> ```

> [!IMPORTANT]
> ### Set Repository Access Credentials
> - Add below credentials properties to your project **`./android/gradle.properties`** or **`~/.gradle/gradle.properties`**
> ```properties
>  PARTNER_REPO_USERNAME=edfapay-sdk-consumer
>  PARTNER_REPO_PASSWORD=Edfapay@123
> ```



> [!IMPORTANT]
> ### FlutterFragmentActivity
> - Change the android **MainActivity** super class from **`FlutterActivity`** to **`FlutterFragmentActivity`**
>   - Path: At project directory: `./android/app/src/main/kotlin/app_package_tree/MainActivity.kt`
>
> **Example**
> ```
> package com.edfapay.sample_app // your application package
> 
> import io.flutter.embedding.android.FlutterFragmentActivity
>
> class MainActivity: FlutterFragmentActivity()
> ```


## Usage

### 1: Imports
- All files under package **`package:edfapay_softpos_sdk`** you need to import to your integration class.
```dart
import 'package:edfapay_softpos_sdk/edfapay_softpos_sdk.dart';
import 'package:edfapay_softpos_sdk/models/edfapay_credentials.dart';
import 'package:edfapay_softpos_sdk/enums/flow_type.dart';
import 'package:edfapay_softpos_sdk/enums/purchase_secondary_action.dart';
import 'package:edfapay_softpos_sdk/enums/presentation.dart';
import 'package:edfapay_softpos_sdk/models/txn_params.dart';
import 'package:edfapay_softpos_sdk/enums/env.dart';
import 'package:edfapay_softpos_sdk/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
```
### 2: Setting Theme (Optional)
**2.1: Setting Colors and Logos**
```dart
final logo = "base64 of image";
// final logo = await assetsBase64('path to image asset');

EdfaPayPlugin.theme()
    .setPrimaryColor("#06E59F")
    .setSecondaryColor("#000000")
    .setPoweredByImage(logo)
    .setHeaderImage(logo)
```
> [!TIP]
> There is an helper method in SDK to convert image asset to base64
> ```dart
> final logo = await assetsBase64('path to image asset');
> ```

**2.2: Setting Presentation**
- Presentation.**FULLSCREEN**
- Presentation.**DIALOG_CENTER**
- Presentation.**DIALOG_TOP_FILL**
- Presentation.**DIALOG_BOTTOM_FILL**
- Presentation.**DIALOG_TOP_START**
- Presentation.**DIALOG_TOP_END**
- Presentation.**DIALOG_TOP_CENTER**
- Presentation.**DIALOG_BOTTOM_START**
- Presentation.**DIALOG_BOTTOM_END**
- Presentation.**DIALOG_BOTTOM_CENTER**

**Note:** Properties of each presentation can be change from `default` to change `User Experience`

```dart
// Usage:
EdfaPayPlugin.theme()
    .setPresentation(
        Presentation.DIALOG_CENTER
            .sizePercent(0.85) // aligned to screen smallest axis 0.20 to 1.0
            .dismissOnBackPress(true)
            .dismissOnTouchOutside(true)
            .animateExit(true)
            .animateEntry(true)
            .dimBackground(true)
            .dimAmount(1.0) // 0.0 to 1.0
            .marginAll(0) // open number
            .cornerRadius(20)  // open number
            .marginHorizontal(10)  // open number
            .marginVertical(10)  // open number
            .setPurchaseSecondaryAction(PurchaseSecondaryAction.none)
);
```

**2.3: Secondary/Post Purchase Transaction Action**
- PurchaseSecondaryAction.**reverse**
- PurchaseSecondaryAction.**refund**
- PurchaseSecondaryAction.**none**

```dart
// Usage:
EdfaPayPlugin.theme()
    .setPresentation(
        Presentation.DIALOG_CENTER
            .setPurchaseSecondaryAction(PurchaseSecondaryAction.none)
    );
```

**2.4: Enable or disable PIN PAD shuffle at PIN Transaction**
```dart
// Usage:
EdfaPayPlugin.theme()
  .setPresentation(
      Presentation.DIALOG_CENTER
          .setShufflePinPad(true); // default false
  );
```

### 3: Initialization
**3.1: Create Credentials**
- I will prompt for the credentials whether user Email/Password or Token 
    ```dart
    EdfaPayCredentials credentials = EdfaPayCredentials.withEmailPassword(
        environment: Env.DEVELOPMENT,
        email: null,
        password: null
    );
    ```

- I will also prompt for the credentials whether user Email/Password or Token
    ```dart
    EdfaPayCredentials credentials = EdfaPayCredentials.withInput(
        environment: Env.PRODUCTION,
    );
    ```

- I will prompt for the credentials with prefilled user Email/Password
    ```dart
    EdfaPayCredentials credentials = EdfaPayCredentials.withEmailPassword(
        environment: Env.DEVELOPMENT,
        email: "user@email.com",
        password: "Password@123"
    );
    ```
  
- I will prompt for the credentials with prefilled user Email
    ```dart
    EdfaPayCredentials credentials = EdfaPayCredentials.withEmail(
        environment: Env.DEVELOPMENT,
        email: "user@email.com",
    );
    ```

- I will silently prepare and initialize the SDK with prefilled terminal Token
  - This should be Terminal Token to behave as silent SDK initialization
   ```dart
   EdfaPayCredentials credentials = EdfaPayCredentials.withToken(
        environment: Env.DEVELOPMENT,
        token: "****Terminal Token Should be Generated at Edfapay SoftPOS Portal****",
   );
   ```

**3.2: Initialize with Created Credentials**
- This function will begin initialization and configure your phone for transactions.
  - **Note:** Make sure to catch the exception and observe the reason of failed initialization.
  ```dart
    EdfaPayPlugin.initiate(
        credentials: credentials,
        onError: (e){
          print('** Error Initializing SDK **');
          print('>>> Error');
          print('  >>> ${jsonEncode(e)}');
          
        },
        onTerminalBindingTask: (bindingTask){

          print('>>> Terminal Binding Required');

          List<Terminal> terminals = bindingTask.terminals;

          // Binding Option 1: Show SDK's built-in terminal selection UI
          bindingTask.bind();

          // Binding Option 2: Bind programmatically or InApp UI list
          terminals.firstOrNull?.bind();

          // Refresh terminal list, then show custom UI
          bindingTask.refresh((error, data){
            if(error != null){
              
              print('** Error Refreshing Terminal List **');
              print('>>> Error');
              print('  >>> ${jsonEncode(error)}');
              
            }else if (data != null){
              
              print('** Success Refreshing Terminal List **');
              print('>>> Success');
              print('  >>> ${jsonEncode(data)}');
              
            }
          });
        },
        onSuccess: (sessionId){
          
          print('** Successful Initialized SDK **');
          print('>>> Success');
          print('  >>> Session ID: $sessionId');
          
          setState(() {
            _edfaPluginInitiated = true;
          });
        }
    );
  ```

**3.3: Enable start transaction from remote source [Optional]** 
* Make sure to open RemoteChannel after successful SDK initialization.
    ```dart
    // Usage: Make sure to open RemoteChannel after initialize successful 
    EdfaPayPlugin.RemoteChannel.LocalNetwork(8080, 3.0).open();
    ```
* Request from remote source:
    ```shell
     # This command passing json to local IP and port of device running our SDK, via Netcat nc 
     echo '{"id":"pay.1","data":{"fun":"purchase","flowType":"DETAIL","amount":"12.0"}}' | nc 192.168.100.70 8080
    ```
* Remote Source will receive response in json.
    ```json
    // This json may receive multiple time depends on FlowType: 
    // IMIDIATE:1time | STATUS:2time | DETAIL:3time)
    // Developer have to observe the {{json}}.data.flowComplete
    {"id":"pay.1","status":"Status.Approved","data":{"status":true,"code":"0000","transaction":{"acquirer_bank":"RAJB","mada_merchant_id":"800150400566","mada_terminal_id":"5116203000000000","amount":"12.00","apk_version_no":"1.0.0","application_cryptogram":"97FA72F45E2921A9","application_id":"A0000002281010","auth_code":"963680","bid":"RAJB","card_acceptor_business_code":"7399","card_expiration_date":"2902","credit_number":"5069 68** **** 0286","credit_number_length":4,"cvm":"3F0000","cardholder_name":"202F","created_date":"2026-02-18T17:18:40.883889000","cryptogram_information_data":"80","currency":"682","cvmr":{"cvmr_code":"3","cvmr_message_arabic":"لا يتطلب التحقق","cvmr_message_english":"NO VERIFICATION REQUIRED"},"downloadParameter":0,"finish_date":"2026-02-18T17:18:40.900968079","forceReconciliation":0,"formatted_created_date":"18/02/2026","formatted_created_time":"17:18:40","formatted_finish_date":"18/02/2026","formatted_finish_time":"17:18:40","kernel_id":"02","location":"null/null","merchant_id":"cf6858e4-8396-46db-880f-2ca9cc0335ee","operation_type":"PURCHASE","qr_data":"MTI 1200 PCODE 000000 TXNAMT 000000001200 STAN 000212 L-DATE\u0026TIME 260218171840 BID RAJB SCHEME P1 TID 5116203000000000 MID 800150400566 POSCODE 71030170333C FCODE 200 MRCODE 1990 MCC 7399 RRN 181418400212 APPCODE 963680 ACTCODE 000 9F24 3233523033313038334848384149523255373550413158495039323449 9F25 0544","response_message_code":"000","response_message_text_english":"APPROVED","response_message_text_arabic":"مقبولة","rrn":"181418400212","scheme":"P1","stan":"000212","status":"APPROVED","tag9F24":"3233523033313038334848384149523255373550413158495039323449","tag9F25":"0544","tvr":"0480000000","transaction_number":"8d174e11-2a5a-48c6-84c1-d1cb8871ce7c","transaction_status_info":"0000","tsn":"102030","request":{"22":"710101711334","23":"000","47":"RAJBP1","cryptogram_data":"80","26":"7399","acquirer_bank":"RAJB","terminalCurrencyCode":"682","merchant_id":"800150400566","outlet_name":"","tsn":"102030","cvmr_code":"3","cardAcceptorNameLocation":"SULAIMAN ALSAID CENTER FOR HOUSE\\KING KHALIED ROAD\\\\","pos_sn":"ffffffff-8356-b142-ffff-ffff8356b142","cvm":"3F0000","terminal_id":"5116203000000000","53":"51FFFF10203000000002","32":"400022","cryptogram":"97FA72F45E2921A9","55":"BAF4A0F13C76E75FF6A5DA05BA8B96B24A3D823D3768DC2B19FD47ECE087780EA09945B21B4DFCC8661E69AB760B243815C5B5C05D15C0A259D548C8710BD8CFEAB4325E4C1010B2F7E771ED8347C36EF7B0CFF0A8C3ED2AF9961EC1D98B6932B8042C228EBBC28EB9665F3ACF77220D89B97F2CF20A60F678C82509304C169E85D6CE806D1858ACF7B131D454F3AA3AB6CC6478BCF2AAE9ECFA70DABF989DF9D7915BBFDD0B50463EB1FCBDB0F6A459A065A09694BA83D4D0E47158C110FBD3BA5FC1CCCDD24D7B224E61CAC8D968CC94DE1D06C5A65D3DA66A0D8F697650D49298B517D6751D4AE386DC8EFBE500F18BDFC361A05A240C6D099F96BFB0808D","12":"2026-02-18 17:18:41 GMT+03:00","transportData":"002004TMS2003004000000400200006001S","35":"1003A1C26FF6D281B2874A1406BDA85C7421EA76987AC91313C975E412C174C2","transaction_status_info":"0000","device_id":"ffffffff-8356-b142-ffff-ffff8356b142","kernel":"02","cardholder_name":"202F","version":"1.0.0","tvr":"0480000000","4":"12.00","outlet_id":"","business_unit_name":"Zohaib Kambrani 102030","61":"8d174e11-2a5a-48c6-84c1-d1cb8871ce7c","bid":"cf6858e4-8396-46db-880f-2ca9cc0335ee","62":{"11":"000000000","12":"170263041","02":"0","13":"000000000","03":"000000","04":"1","05":"1","16":"01020202","09":"0","location_in_utm_format":"59N244659E0464222","long":46.7061832,"lat":24.7830929,"10":"000000000"},"63":"us-en","41":"5116203000000000","order_id":"8d174e11-2a5a-48c6-84c1-d1cb8871ce7c","aid":"A0000002281010","application_label":"mada"}},"flowComplete":true}}
    ```

### 4: Purchase
- FlowType.**immediate** 
  - It will close the Card Scanning Interface immediately after receive response from server.  
- FlowType.**status**
  - It will close the Card Scanning Interface at the status animation check/cross.
- FlowType.**detail**
  - It will take the UI flow up to transaction detail screen and will completed by closing screen/ui.

**Note:** Observe the 4th **`isFlowCompleted`** parameter of **`onPaymentProcessComplete`** callback.

```dart
        final params = TxnParams(
            amount: amountToPay,
            orderId: "12340987"
        );

        EdfaPayPlugin.purchase(
            txnParams: params,
            flowType: FlowType.DETAIL,
            onPaymentProcessComplete: (status, code, result, isFlowCompleted) {
              if(status){
                print(' >>> [ Success ]');
                print(' >>> [ ${jsonEncode(result)} ]');
              }else{
                print(' >>> [ Failed ]');
                print(' >>> [ ${jsonEncode(result)} ]');
              }
            }, 
            onRequestTimerEnd: () {
              print('>>> Server Timeout');
              print(' >>> The request timeout while performing transaction at backend');
            },
            onCardScanTimerEnd: () {
              print('>>> Scan Card Timeout');
              print(' >>> The scan card timeout, no any card tap on device');
            },
            onCancelByUser: () {
              print('>>> Canceled By User');
              print(' >>> User have cancel the scanning/payment process on its own choice');
            },
            onError: (error) {
              print('>>> Error');
              print(' >>> "Scanning/Payment process through an error');
              print('  >>> ${jsonEncode(error)}');
        });
```



# [Example](https://pub.dev/packages/edfapay_softpos_sdk/example) 
**Instruction to Run Example:** 
- Make sure to install below plugins to your sample flutter app
  - https://pub.dev/packages/hexcolor
  - https://pub.dev/packages/fluttertoast
- Dont forget to apply [Important](https://pub.dev/packages/edfapay_softpos_sdk#edfapay-softpos-sdk) marked configuration/change at the top in to your project
- Copy the below content and paste it to main.dart (make sure to replace all)

```dart
// ignore_for_file: avoid_print
import 'dart:convert';

import 'package:edfapay_softpos_sdk/edfapay_softpos_sdk.dart';
import 'package:edfapay_softpos_sdk/enums/flow_type.dart';
import 'package:edfapay_softpos_sdk/enums/presentation.dart';
import 'package:edfapay_softpos_sdk/enums/purchase_secondary_action.dart';
import 'package:edfapay_softpos_sdk/models/edfapay_credentials.dart';
import 'package:edfapay_softpos_sdk/models/txn_params.dart';
import 'package:edfapay_softpos_sdk/enums/env.dart';
import 'package:edfapay_softpos_sdk/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/* add the plugin for below: (hexcolor: any) https://pub.dev/packages/hexcolor */
import 'package:hexcolor/hexcolor.dart';

// add the plugin for below: (fluttertoast: any) https://pub.dev/packages/fluttertoast
import 'package:fluttertoast/fluttertoast.dart';



const TERMINAL_TOKEN = "D08BE4C0FE041A155F0028C0FCD042087771DA505D54087EFC3A0FC1183213D6";
const logoPath = "assets/images/edfa_logo.png";
const amountToPay = "01.01";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _edfaPluginInitiated = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FractionallySizedBox(widthFactor: 0.3, child: Image.asset(logoPath)),
                    const SizedBox(height: 30),
                    const Text("SDK", style: TextStyle(fontSize: 65, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
                    const SizedBox(height: 10),
                    const Text("v0.0.1", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  ],
                ),
              ),
              const Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("You're on your way to enabling your Android App to allow your customers to pay in a very easy and simple way just click the payment button and tap your payment card on NFC enabled Android phone.",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black45), textAlign: TextAlign.center),
                ),
              ),

              if(!_edfaPluginInitiated)
                ElevatedButton(onPressed: initiate, style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(HexColor("06E59F"))), child: const Text("Initiate", style: TextStyle(color: Colors.black))),

              if(_edfaPluginInitiated)
                ...[
                  ElevatedButton(onPressed: pay, style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(HexColor("06E59F"))), child: const Text("Pay $amountToPay", style: TextStyle(color: Colors.black))),
                  ElevatedButton(onPressed: refund, style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(HexColor("06E59F"))), child: const Text("Refund With RRN", style: TextStyle(color: Colors.black))),
                  ElevatedButton(onPressed: reconcile, style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(HexColor("06E59F"))), child: const Text("Reconciliation", style: TextStyle(color: Colors.black))),
                  ElevatedButton(onPressed: txnHistory, style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(HexColor("06E59F"))), child: const Text("Txn History $amountToPay", style: TextStyle(color: Colors.black))),
                ],

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text("Click on button above to test the card processing with 10.00 SAR", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400), textAlign: TextAlign.center),
              ),
            ],
          ),
        ),
      ),
    );
  }

  initiate() async {
    EdfaPayPlugin.enableLogs(true);
    /*
    EdfaPayCredentials credentials = EdfaPayCredentials.withEmailPassword(
        environment: Env.DEVELOPMENT,
        email: null,
        password: null
    );

    EdfaPayCredentials credentials = EdfaPayCredentials.withEmailPassword(
        environment: Env.DEVELOPMENT,
        email: "user@mail.com",
        password: "Password@123"
    );

    EdfaPayCredentials credentials = EdfaPayCredentials.withInput(
        environment: Env.PRODUCTION,
    );

    EdfaPayCredentials credentials = EdfaPayCredentials.withEmail(
        environment: Env.DEVELOPMENT,
        email: "user@mail.com",
    );

    EdfaPayCredentials credentials = EdfaPayCredentials.withToken(
        environment: Env.DEVELOPMENT,
        token: TERMINAL_TOKEN,
    );
    */

    EdfaPayCredentials credentials = EdfaPayCredentials.withToken(
      environment: Env.DEVELOPMENT,
      token: TERMINAL_TOKEN,
    );

    // setTheme();
    EdfaPayPlugin.initiate(
        credentials: credentials,
        onError: (e){
          toast("** Error Initializing SDK **");

          print('** Error Initializing SDK **');
          print('>>> Error');
          print('  >>> ${jsonEncode(e)}');

        },
        onTerminalBindingTask: (bindingTask){
          print('>>> Terminal Binding Required');

          List<Terminal> terminals = bindingTask.terminals;

          // Option 1: Show SDK's built-in terminal selection UI
          bindingTask.bind();

          // Option 2: Refresh terminal list, then show custom UI

          // Option 3: Bind programmatically or InApp UI list
          terminals.firstOrNull?.bind();
        },
        onSuccess: (sessionId){
          toast('** Successful Initialized SDK **');

          print('** Successful Initialized SDK **');
          print('>>> Success');
          print('  >>> Session ID: $sessionId');

          setState(() {
            _edfaPluginInitiated = true;
          });
        }
    );
  }

  setTheme() async {
    final logo = await assetsBase64(logoPath);
    final presentation = Presentation.DIALOG_CENTER
        .sizePercent(0.85)
        .dismissOnTouchOutside(true)
        .dimBackground(true)
        .dimAmount(1.0)
        .marginAll(0)
        .animateEntry(true)
        .animateExit(true)
        .cornerRadius(20)
        .dismissOnBackPress(true)
        .marginHorizontal(10)
        .marginVertical(10)
        .setPurchaseSecondaryAction(PurchaseSecondaryAction.REVERSE)
        .setShufflePinPad();
    EdfaPayPlugin.theme()
        .setPrimaryColor("#06E59F")
        .setSecondaryColor("#000000")
        .setHeaderImage(logo)
        .setPoweredByImage(logo)
        .setPresentation(presentation);
  }

  pay() async {
    if (!_edfaPluginInitiated) {
      toast("Edfapay plugin not initialized.");
      return;
    }

    final params = TxnParams(
        amount: amountToPay,
        orderId: "12340987"
    );

    EdfaPayPlugin.enableLogs(true);
    EdfaPayPlugin.purchase(
        txnParams: params,
        flowType: FlowType.DETAIL,
        onPaymentProcessComplete: (status, code, result, isFlowCompleted) {
          toast("Transaction Completed | Check the logs");
          if(status){
            print(' >>> [ Success ]');
            print(' >>> [ ${jsonEncode(result)} ]');
          }else{
            print(' >>> [ Failed ]');
            print(' >>> [ ${jsonEncode(result)} ]');
          }
        },
        onRequestTimerEnd: () {
          toast("Server Request Timeout");

          print('>>> Server Timeout');
          print(' >>> The request timeout while performing transaction at backend');
        },
        onCardScanTimerEnd: () {
          toast("Scan Card Timeout");

          print('>>> Scan Card Timeout');
          print(' >>> The scan card timeout, no any card tap on device');
        },
        onCancelByUser: () {
          toast("Cancel By User");
          print('>>> Canceled By User');
          print(' >>> User have cancel the scanning/payment process on its own choice');
        },
        onError: (error) {
          toast("Error occurred | Check the logs");
          print('>>> Error');
          print(' >>> "Scanning/Payment process through an error');
          print('  >>> ${jsonEncode(error)}');
        });
  }

  refund() async {
    if (!_edfaPluginInitiated) {
      toast("Edfapay plugin not initialized.");
      return;
    }

    final params = TxnParams(
        amount: amountToPay,
        originalTransaction: Transaction.withRRN("1234567890", DateTime.now())
    );

    EdfaPayPlugin.enableLogs(true);
    EdfaPayPlugin.refund(txnParams: params, onPaymentProcessComplete: (status, code, result, isFlowCompleted) {
      toast("Card Payment Process Completed");
      print('>>> Payment Process Complete');
    }, onRequestTimerEnd: () {
      toast("Server Request Timeout");
      print('>>> Server Timeout');
      print(' >>> The request timeout while performing transaction at backend');
    }, onCardScanTimerEnd: () {
      toast("Card Scan Timeout");
      print('>>> Scan Card Timeout');
      print(' >>> The scan card timeout, no any card tap on device');
    }, onCancelByUser: () {
      toast("Cancel By User");
      print('>>> Canceled By User');
      print(' >>> User have cancel the scanning/payment process on its own choice');
    }, onError: (error) {
      toast(error.toString());
      print('>>> Exceptio¬n');
      print(' >>> "Scanning/Payment process through an exception, Check the logs');
      print('  >>> ${error.toString()}');
    });
  }


  reconcile() async {
    if (!_edfaPluginInitiated) {
      toast("Edfapay plugin not initialized.");
      return;
    }

    EdfaPayPlugin.reconcile(
        onSuccess: (response){
          toast("Success reconcile");
        },
        onError: (error){
          print('>>> Exception');
          print(' >>> "Scanning/Payment process through an exception, Check the logs');
          print('  >>> ${error.toString()}');
        }
    );
  }


  txnHistory() async {
    if (!_edfaPluginInitiated) {
      toast("Edfapay plugin not initialized.");
      return;
    }

    EdfaPayPlugin.txnHistory(
        onSuccess: (response){
          toast("Success txnHistory");
        },
        onError: (error){
          print('>>> Exception');
          print(' >>> "Scanning/Payment process through an exception, Check the logs');
          print('  >>> ${error.toString()}');
        }
    );
  }

  toast(String text) {
    Fluttertoast.showToast(msg: text);
  }

}
```
## License

MIT

---
