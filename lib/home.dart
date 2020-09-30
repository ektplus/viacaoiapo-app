import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';


void main() => runApp(Home());

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Viação Iapó',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WebViewWebPage(),
    );
  }
}

class WebViewWebPage extends StatefulWidget {
  @override
  _WebViewWebPageState createState() => _WebViewWebPageState();
}

class _WebViewWebPageState extends State<WebViewWebPage> {
  var url = "https://iapo.crosier.iapo.com.br/app/tur/compra/ini";

  InAppWebViewController webView;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBack,
      child: Scaffold(
        body: Container(
          child: Column(
              children: <Widget>[
            Expanded(
              child: Container(
                child: InAppWebView(
                  initialUrl: url,
                  initialHeaders: {},
                  onWebViewCreated: (InAppWebViewController controller) {
                    webView = controller;
                  },
                ),
              ),
            )
          ].where((Object o) => o != null).toList()),
        ),
      ),
    ); //Remove null widgets
  }

  Future<bool> _onBack() async {
    bool goBack;
    var value = await webView.canGoBack();
    if (value) {
      webView.goBack();
      return false;
    } else {
      await showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title:
              new Text('Confirmação ', style: TextStyle(color: Colors.purple)),
          content: new Text('Sair do aplicativo ?'),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                setState(() {
                  goBack = false;
                });
              },
              child: new Text('Não'),
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
      if (goBack) SystemNavigator.pop();
      return goBack;
    }
  }
}
