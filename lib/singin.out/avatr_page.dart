import 'dart:io';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pim/singin.out/verifier_page.dart';
import '../main.dart';
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

  void _clear() {
    final form = formKey.currentState;
    form!.reset();
    FocusScope.of(context).requestFocus(_focusNode);
  }

  @override
  Widget build(BuildContext context) {
    var children = [
      _buildInputForm(),
    ];
    if (_name.length > 0) {
      var url = 'https://robohash.org/$_name';
      var avatar = Avatar(url: url, size: 150.0);
      children.addAll([
        VerticalPadding(child: avatar),
        VerticalPadding(child: Text('Courtesy of robohash.org')),
      ]);
    }

    children.addAll([
      Expanded(child: Container()),
      Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
        VerticalPadding(
            child: FlatButton(
          child: Text('Clear', style: new TextStyle(fontSize: 24.0)),
          onPressed: _clear,
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
  VerticalPadding({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }
}
