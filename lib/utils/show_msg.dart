
import 'package:flutter/material.dart';

void ShowMsg (BuildContext context, String msg){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text( msg),));
}