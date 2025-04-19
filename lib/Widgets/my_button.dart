import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? color;

  const MyButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = Colors.blueAccent,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text( 
        label,
        style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w600, color: Colors.white),
      ),
    );
  }
}