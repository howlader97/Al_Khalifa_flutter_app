import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SSLCommerzWebView extends StatefulWidget {
  final String paymentUrl;
  final VoidCallback onPaymentSuccess;
  final VoidCallback onPaymentFailed;
  final VoidCallback onPaymentCancelled;

  const SSLCommerzWebView({
    super.key,
    required this.paymentUrl,
    required this.onPaymentSuccess,
    required this.onPaymentFailed,
    required this.onPaymentCancelled,
  });

  @override
  State<SSLCommerzWebView> createState() => _SSLCommerzWebViewState();
}

class _SSLCommerzWebViewState extends State<SSLCommerzWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            if (url.contains('/payments/success')) {
              widget.onPaymentSuccess();
            } else if (url.contains('/payments/fail')) {
              widget.onPaymentFailed();
            } else if (url.contains('/payments/cancel')) {
              widget.onPaymentCancelled();
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pay with SSLCommerz"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
