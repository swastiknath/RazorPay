import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  static const platform = const MethodChannel("razorpay_flutter");
  Razorpay _razorpay;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Payment Accept'),
        ),
        body: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              onPressed: openCheckout,
              child: Text('Pay Now'),
            ),
          ],
        )),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_ZEXxRa1wb2RanS',
      'amount': '2000',
      'name': 'PositionX Machines Research Company',
      'description':
          'ASUS VIVOBOOK S15-S532FL SI LVER 10th Gen Intel Core i5 10210U, 2GB NVIDIA MX250, ScreenPad 2.0, Ergolift Hinge, Frameless Nanoedge display',
      //'prefill': {'contact': '7872171128', 'email': 'ko@outl.co'},
      'shipping address': '',
      'billing address': '',
      'external': {
        'wallet': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }
}

void _handlePaymentSuccess(PaymentSuccessResponse response) {
  Fluttertoast.showToast(
      msg: "Success " + response.paymentId, timeInSecForIos: 4);
}

void _handlePaymentError(PaymentFailureResponse response) {
  Fluttertoast.showToast(
      msg: "Error " +
          response.message +
          "  ERROR CODE " +
          response.code.toString(),
      timeInSecForIos: 4);
}

void _handleExternalWallet(ExternalWalletResponse response) {
  Fluttertoast.showToast(
      msg: "External Wallet " + response.walletName, timeInSecForIos: 4);
}
