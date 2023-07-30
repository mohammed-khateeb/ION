import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ion_application/Models/Api/current_user.dart';
import 'package:ion_application/Widgets/custom_inkwell.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../Widgets/custom_app_bar.dart';
import '../../Widgets/gradient_card.dart';

class WebViewComponent extends StatefulWidget {

  const WebViewComponent({super.key});

  @override
  WebViewComponentState createState() => WebViewComponentState();
}

class WebViewComponentState extends State<WebViewComponent> {
  WebViewController? controller;
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))

      ..loadRequest(Uri.parse("https://api.evse.cloud/api/v3/app/home?token=${CurrentUser.token}"),);

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GradientCard(
      borderRadiusValue: size.height*0.01,
      child: controller == null
          ? const SizedBox()
          : ClipRRect(
        borderRadius: BorderRadius.circular(size.height*0.01),
            child: SizedBox(
        height: size.height*0.22,
        width: size.width*0.9,
        child: IgnorePointer(
          ignoring: true,
          child: WebViewWidget(
          controller: controller!,
      ),
        ),
            ),
          ),
    );
  }
}
