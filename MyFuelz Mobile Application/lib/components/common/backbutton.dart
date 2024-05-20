import 'package:flutter/material.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0x21154378),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15)),
      child: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Color(0xFF154478),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
