import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  Widget build(context) {
    return const Center(child: CircularProgressIndicator());
  }
}
