import 'package:flutter/material.dart';
import 'package:ion_application/Models/Api/current_user.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Widgets/custom_app_bar.dart';
import '../Widgets/waiting_widget.dart';

class StaticPageScreen extends StatefulWidget {
  final String link;

  const StaticPageScreen({super.key, required this.link,});

  @override
  StaticPageScreenState createState() => StaticPageScreenState();
}

class StaticPageScreenState extends State<StaticPageScreen> {
  WebViewController? controller;
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(Uri.parse("${widget.link}?token=${CurrentUser.token}"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
      ),
      backgroundColor: Colors.white,
      body: controller == null
          ? const WaitingWidget()
          : WebViewWidget(
              controller: controller!,
            ),
    );
  }
}
