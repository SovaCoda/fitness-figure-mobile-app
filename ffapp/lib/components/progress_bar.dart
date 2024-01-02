import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {

  const ProgressBar({super.key});

  final barWidth = 320.0;

  //TO DO: GET CHARGE PERCENT
  final progressPercent = .83;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
          Container(
            width: barWidth,
            height: 40.0,
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Color.fromARGB(255, 143, 246, 148),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 44, 44, 44),
                  spreadRadius: .5,
                  blurRadius: 10
                )]
            ),
            child: Container(
              width: barWidth - 10,
              height: 40,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white,
              ),
              child: Row(
                  children: [
                    SizedBox(width: 20),

                    Container(
                      width: barWidth - 90,
                      height: 10.0,
                      alignment: Alignment.centerLeft,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.grey,
                      ),
                      child: Container(
                        width: (barWidth - 90) * progressPercent,
                        height: 10,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Color.fromARGB(255, 143, 246, 148),
                          boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 111, 110, 110),
                            spreadRadius: .1,
                            blurRadius: .5
                          )]
                        ),
                      ),
                    ),

                    SizedBox(width: 10),

                    Text(
                      "${(progressPercent * 100).toStringAsFixed(0)}%",
                      style: const TextStyle(
                        color: Color.fromARGB(255, 143, 246, 148),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ]
                ),
            ),
          ),
      ],);
  }
}