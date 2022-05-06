import 'package:flutter/material.dart';

class Cinput extends StatelessWidget {
  final TextEditingController controller;
  final String lable;
  final int? maxlines;
  final int? minlines;

  const Cinput(
      {Key? key,
      required this.controller,
      required this.lable,
      this.maxlines,
      this.minlines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: minlines,
      maxLines: maxlines,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
          border: const OutlineInputBorder(
              borderSide: BorderSide(
            width: 4,
            color: Colors.blue,
          )),
          filled: true,
          fillColor: Colors.black26,
          label: Text(lable),
          labelStyle: TextStyle(color: Colors.white)),
    );
  }
}
