import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../const/colors.dart';

Widget customTextField(
    {required Function(dynamic value) onSubmitted,
    required TextEditingController controller,
    required String hintText}) {
  return Container(
      height: 60,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: fieldsGradients),
          borderRadius: BorderRadius.circular(10)),
      child: TextField(
          textAlignVertical: TextAlignVertical.center,
          enabled: true,
          controller: controller,
          cursorColor: Colors.pink.shade100,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 1, color: Colors.orange),
            ),
          ),
          textAlign: TextAlign.center,
          onSubmitted: onSubmitted));
}
