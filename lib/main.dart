import 'package:flutter/material.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crosier WebView',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WebViewWebPage(),
    );
  }
}

class WebViewWebPage extends StatefulWidget {
  @override
  _WebViewWebPageState createState() => _WebViewWebPageState();
}

class _WebViewWebPageState extends State<WebViewWebPage> {
  Future<bool> _onBack() async {
    bool goBack;
    var value = await webView.canGoBack(); // check webview can go back
    if (value) {
      webView.goBack(); // perform webview back operation
      return false;
    } else {
      await showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title:
              new Text('Confirmação ', style: TextStyle(color: Colors.purple)),
          // Are you sure?
          content: new Text('Sair do aplicativo ?'),
          // Do you want to go back?
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                setState(() {
                  goBack = false;
                });
              },
              child: new Text('Não'), // No
            ),
            new FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  goBack = true;
                });
              },
              child: new Text('Sim'), // Yes
            ),
          ],
        ),
      );
      if (goBack) Navigator.pop(context); // If user press Yes pop the page
      return goBack;
    }
  }

  var url = "https://core.demo.crosier.com.br";

  // Webview progress
  double progress = 0;
  InAppWebViewController webView;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBack,
      child: Scaffold(
          appBar: AppBar(
            title: Text("Crosier WebView"),
          ),
          body: Container(
              child: Column(
                  children: <Widget>[
            (progress != 1.0)
                ? LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.purple))
                : null, // Should be removed while showing
            Expanded(
              child: Container(
                child: InAppWebView(
                  initialUrl: url,
                  initialHeaders: {},
                  initialOptions: {},
                  onWebViewCreated: (InAppWebViewController controller) {
                    webView = controller;
                  },
                  onProgressChanged:
                      (InAppWebViewController controller, int progress) {
                    setState(() {
                      this.progress = progress / 100;
                    });
                  },
                ),
              ),
            )
          ].where((Object o) => o != null).toList()))),
    ); //Remove null widgets
  }
}
