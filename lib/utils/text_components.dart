
import 'package:flutter/material.dart';

InputDecoration textInputDeco({Icon? icon, String? hintText}){
  return InputDecoration(
    filled: true,
    errorMaxLines: 3,
    fillColor: Colors.grey.shade200,
    prefixIcon: icon,
    counterText: '',
    hintText: hintText,
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: Colors.grey.shade200)),
    focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: Colors.grey.shade400)),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: Colors.grey.shade200)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: Colors.grey.shade400)),
  );
}