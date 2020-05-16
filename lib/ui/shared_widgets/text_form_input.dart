import 'package:flutter/material.dart';

class TextFormInput extends StatelessWidget {
  final String name;
  final bool obscure;
  final Function validator;
  final TextEditingController controller;

  TextFormInput(
      {@required this.name,
      this.obscure = false,
      @required this.validator,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 45, right: 45),
      child: Container(
        height: 70,
        child: TextFormField(
          validator: validator,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            errorStyle: TextStyle(fontSize: 14),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.black)),
            contentPadding: EdgeInsets.all(4.0),
            labelStyle: TextStyle(color: Colors.black),
            labelText: name,
          ),
          controller: controller,
          obscureText: obscure,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
    );
  }
}
