import 'package:browser_app/provider/all_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebView extends StatefulWidget {
  final String url;

  const MyWebView({super.key, required this.url});

  @override
  State<MyWebView> createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  late final WebViewController controller;
  int loadingPercent = 0;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..loadRequest(Uri.parse(widget.url))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              loadingPercent = 0;
            });
          },
          onProgress: (progress) {
            setState(() {
              loadingPercent = progress;
            });
          },
          onPageFinished: (url) {
            setState(() {
              loadingPercent = 100;
            });
          },
        ),
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        "Snackbar",
        onMessageReceived: (message) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message.message)));
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Web View"),
        actions: [
          IconButton(
            onPressed: () async {
              if (await controller.canGoBack()) {
                controller.goBack();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("No Backward History found")),
                );
              }
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          IconButton(
            onPressed: () => controller.reload(),
            icon: const Icon(Icons.replay),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (loadingPercent < 100)
            LinearProgressIndicator(value: loadingPercent / 100),
        ],
      ),
    );
  }
}

// class MyWebView extends StatefulWidget {
//   final String url;
//   const MyWebView({super.key, required this.url});
//
//   @override
//   State<MyWebView> createState() => _MyWebViewState();
// }
//
// class _MyWebViewState extends State<MyWebView> {
//   late  WebViewController controller;
//   var loadingPercent = 0;
//   @override
//   void initState() {
//     super.initState();
//     controller = WebViewController()..loadRequest(Uri.parse(widget.url));
//     controller
//       ..setNavigationDelegate(NavigationDelegate(onPageStarted: (url) {
//         setState(() {
//           loadingPercent;
//         });
//       }, onProgress: (progess) {
//         setState(() {
//           loadingPercent = progess;
//         });
//       }, onPageFinished: (url) {
//         setState(() {
//           loadingPercent = 100;
//         });
//       }))
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..addJavaScriptChannel("Snackbar", onMessageReceived: (message) {
//         ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text(message.message)));
//       });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Web View"),
//         actions: [
//           Row(
//             children: [
//               IconButton(
//                   onPressed: () async {
//                     final messenger = ScaffoldMessenger.of(context);
//                     if (await controller.canGoBack()) {
//                       controller.goBack();
//                     } else {
//                       messenger.showSnackBar(
//                           SnackBar(content: Text("No Forward History found")));
//                     }
//                     return;
//                   },
//                   icon: Icon(Icons.arrow_back_ios)),
//               IconButton(
//                   onPressed: () {
//                     controller.reload();
//                   },
//                   icon: Icon(Icons.replay))
//             ],
//           )
//         ],
//       ),
//       body: Stack(
//         children: [
//           WebViewWidget(controller: controller),
//           if (loadingPercent < 100)
//             LinearProgressIndicator(
//               value: loadingPercent / 100,
//             )
//         ],
//       ),
//     );
//   }
// }
