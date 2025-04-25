import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final VoidCallback? onTap; // Butona tıklama işlevi için geri çağırma
  final String? text; // Buton üzerindeki metin

  const MyButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Butona tıklama işlevi
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary, // Arka plan rengi
          borderRadius: BorderRadius.circular(12), // Kenar yuvarlama
        ),
        child: Center(
          child: Text(
            text!,
            style: TextStyle(
              fontWeight: FontWeight.bold, // Metin kalınlığı
              fontSize: 16, // Metin boyutu
            ),
          ),
        ),
      ),
    );
  }
}
