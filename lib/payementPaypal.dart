import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'event_detail_page.dart';

class paymentPaypal extends StatefulWidget {
  paymentPaypal(this.prix);
  final prix;

  @override
  _payementPaypalState createState() => _payementPaypalState();
}

//<html>
//         <body onload="document.f.submit();">
//           <form id="f" name="f" method="post" action="http://10.0.2.2:3001/pay">
//             <input type="hidden" name="prix" value="${widget.price}" />
//           </form>
//         </body>
//       </html>
class _payementPaypalState extends State<paymentPaypal> {
  String _loadHTML() {
    return r'''
    
      ''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WebView(
            onPageFinished: (page) {
              /*if (page.contains('/success'))
              {
                Navigator.pop(context);
              } */
            },
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl:
                'https://eventado.herokuapp.com/create-charge' // coinbase
            //initialUrl: Uri.dataFromString(_loadHTML(), mimeType: 'text/html').toString(),
            //initialUrl: 'http://10.0.2.2:3001/pay',
            ));
  }
}
