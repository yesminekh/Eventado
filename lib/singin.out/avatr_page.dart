import "package:flutter/material.dart";
import 'package:pim/UserHome/home.dart';
import 'avatar.dart';

class AvatarPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AvatarPageState();
}

class _AvatarPageState extends State<AvatarPage> {
  static final formKey = GlobalKey<FormState>();

  String _name = '';

  FocusNode _focusNode = new FocusNode();

  void _updateName(String name) {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      setState(() {});
      print('Saved: $_name');
    }
  }

  void _continue() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MyHomePage(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    var children = [
      _buildInputForm(),
    ];
    if (_name.isNotEmpty) {
      var url = 'https://robohash.org/$_name';
      var avatar = Avatar(url: url, size: 150.0);
      children.addAll([
        VerticalPadding(child: avatar),
        const VerticalPadding(child: Text('Courtesy of robohash.org')),
      ]);
    }

    children.addAll([
      Expanded(child: Container()),
      Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
        VerticalPadding(
            child: FlatButton(
          child: const Text('Continue', style: TextStyle(fontSize: 24.0)),
          onPressed: _continue,
        ))
      ])
    ]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Greeting'),
        backgroundColor: const Color(0xFFEDECF2),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: Column(
            children: children,
          ),
        ),
      ),
    );
  }

  Widget _buildInputForm() {
    var children = [
      VerticalPadding(
          child: TextFormField(
        focusNode: _focusNode,
        decoration: const InputDecoration(
          labelText: 'Enter your unique identifier',
          labelStyle: TextStyle(fontSize: 20.0),
        ),
        style: const TextStyle(fontSize: 24.0, color: Colors.black),
        validator: (val) => val!.isEmpty ? 'Name can\'t be empty' : null,
        onSaved: (name) => _name = name!,
        onFieldSubmitted: (name) => _updateName(name),
      ))
    ];

    return Form(
      key: formKey,
      child: Column(
        children: children,
      ),
    );
  }
}

class VerticalPadding extends StatelessWidget {
  const VerticalPadding({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }
}
