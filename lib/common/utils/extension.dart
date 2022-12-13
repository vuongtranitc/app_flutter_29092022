import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/single_child_widget.dart';

void showMessage(
    [BuildContext? context,
    String? title,
    String? message,
    List<Widget>? actionsAlert]) {
  if (context == null) return;
  var actionAlignment = (actionsAlert?.length == 1) ? MainAxisAlignment.end : MainAxisAlignment.center;
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: (title == null || title.isEmpty) ? null : Text(title),
        content: (message == null || message.isEmpty) ? null : Text(message),
        actions: actionsAlert,
        actionsAlignment: actionAlignment,
      );
    },
  );
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

bool isNotEmpty(List<String> data) {
  for (int i = 0; i < data.length; i++){
    if (data[i].isEmpty) {
      return false;
    }
  }
  return true;
}

String formatPrice(int price) {
  return NumberFormat("#,###", "en_US").format(price);
}

String formatDate(String date){
  var inputFormat = DateFormat('yyyy-MM-dd');
  var inputDate = inputFormat.parse(date); // <-- dd/MM 24H format

  var outputFormat = DateFormat('dd/MM/yyyy');
  var outputDate = outputFormat.format(inputDate);
  return outputDate.toString();
}