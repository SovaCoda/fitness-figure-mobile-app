import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  // final Colors backGroundColor;
  const CustomButton({
    super.key,
    required this.onTap,
    required this.text,
    // required this.backGroundColor
  });

  void press() {
    onTap;
  }

  @override
  Widget build(BuildContext context) {
    ButtonStyle style = ElevatedButton.styleFrom( 
      textStyle: const TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.all(30.0)
    );

    return ElevatedButton(
      onPressed: onTap,
      style: style,
      child: 
        Container(
        alignment: Alignment.center,
        child: Text(text)
      ),
      
    
    );
    // return Container(
    //   margin: const EdgeInsets.symmetric(horizontal: 25),
    //   child: Material(
    //     child: Ink(
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(8),
    //         color: Colors.black,
    //       ),
    //       child: InkWell(
    //         onTap: onTap,
    //         child: Container(
    //           padding: const EdgeInsets.all(22),
    //           child: Center(
    //             child: Text(
    //               text,
    //               style: const TextStyle(
    //               color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
    //             ),
    //           ),
    //         )
    //       ),
    //     )
    //   ),
    // );  
  }
}
