import 'package:flutter/material.dart';

class ErrorWidgetApp extends StatelessWidget {
  final VoidCallback retry;

  const ErrorWidgetApp({super.key, required this.retry});

  Widget build(context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Text("Errore caricamento dati"),

          ElevatedButton(onPressed: retry, child: Text("Riprova")),
        ],
      ),
    );
  }
}
