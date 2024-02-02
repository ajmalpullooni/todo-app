import 'package:flutter/material.dart';

void errorMessage(BuildContext context, {required String message}) {
    final snackBar = SnackBar (
      content: Text(
        message,
        style: const TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  } 