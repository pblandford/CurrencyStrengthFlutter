import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HelpView extends StatelessWidget {
  const HelpView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setBackgroundColor(const Color(0x00000000))
      ..loadFlutterAsset("assets/help.html")
      ..setJavaScriptMode(JavaScriptMode.unrestricted);

    controller.setNavigationDelegate(NavigationDelegate(onPageFinished: (url) {
      String customCss = "body { font-size: 45px; }";
      String script = '''
          var style = document.createElement('style');
          style.innerHTML = '$customCss';
          document.head.appendChild(style);
        ''';
      controller.runJavaScript(script);
    }));
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: FractionallySizedBox(
            widthFactor: 0.9,
            heightFactor: 0.9,
            child: WebViewWidget(controller: controller)));
  }
}
