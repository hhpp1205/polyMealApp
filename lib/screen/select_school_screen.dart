import 'package:flutter/material.dart';

class SelectSchoolScreen extends StatelessWidget {
  const SelectSchoolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
            child: Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                color: Colors.red,
              ),
            )
        ),
      ],
    );
  }
}
