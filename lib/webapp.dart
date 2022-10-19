import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'pack/raz.dart';


class MyWebApp extends StatefulWidget {
  const MyWebApp({super.key});

  @override
  State<MyWebApp> createState() => _MyWebAppState();
}

class _MyWebAppState extends State<MyWebApp> {
  static const platform = MethodChannel("razorpay_flutter");
  Razorweb? _razorpayy;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Razorpay Web Sample App'),
        ),
        body: Center(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[ElevatedButton(onPressed: openCheckout, child: const Text('Open'))])),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _razorpayy = Razorweb();
    _razorpayy!.on(Razorweb.EVENT_PAYMENT_SUCCESS, _hhandlePaymentSuccess);
    _razorpayy!.on(Razorweb.EVENT_PAYMENT_ERROR, _hhandlePaymentError);
    _razorpayy!.on(Razorweb.EVENT_EXTERNAL_WALLET, _hhandleExternalWallet);

  }

  @override
  void dispose() {
    super.dispose();

    _razorpayy!.clear();

  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': 100,
      'name': 'Acme Corp.',
      'description': 'Fine T-Shirt',
      'send_sms_hash': true,
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {

      _razorpayy!.open(options);


    } catch (e) {
      debugPrint('Error: e');
    }
  }


  void _hhandlePaymentSuccess(PaymentSuccessResponse response) {
    log('Success Response: $response');
    Fluttertoast.showToast(msg: "SUCCESS: ${response.paymentId!}", toastLength: Toast.LENGTH_SHORT);
  }

  void _hhandlePaymentError(PaymentFailureResponse response) {
    log('Error Response: $response');
    Fluttertoast.showToast(msg: "ERROR: ${response.code} - ${response.message!}", toastLength: Toast.LENGTH_SHORT);
  }

  void _hhandleExternalWallet(ExternalWalletResponse response) {
    log('External SDK Response: $response');
    Fluttertoast.showToast(msg: "EXTERNAL_WALLET: ${response.walletName!}", toastLength: Toast.LENGTH_SHORT);
  }


}
