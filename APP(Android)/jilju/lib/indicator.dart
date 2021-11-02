import 'package:flutter/material.dart';

class IndicatorPage extends StatelessWidget {
  const IndicatorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 100,
        height: 100,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
