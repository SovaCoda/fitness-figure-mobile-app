import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  const CustomButton({
    super.key,
    required this.onTap,
    required this.text,
  });

  void press() {
    onTap;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      child: Material(
          child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.black,
        ),
        child: InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(22),
              child: Center(
                child: Text(
                  text,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ),
            )),
      )),
    );
  }
}
