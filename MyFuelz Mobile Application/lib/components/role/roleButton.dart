import 'package:flutter/material.dart';

class RoleButton extends StatelessWidget {
  final String buttonName;
  final Color bcolor;
  final Color fcolor;
  final Color tcolor;
  final double radius;
  final double minHeight;
  final Color borderColor;
  final void Function()? onPressed;

  const RoleButton({
    Key? key,
    required this.buttonName,
    required this.bcolor,
    required this.tcolor,
    required this.radius,
    required this.fcolor,
    required this.minHeight,
    required this.borderColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 335,
      height: 73,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x115A6CEA),
            blurRadius: 50,
            offset: Offset(12, 26),
            spreadRadius: 0,
          )
        ],
      ),
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(bcolor),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius)),
            ),
          ),
          minimumSize: MaterialStateProperty.all(Size(double.infinity, minHeight)),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 8.0,
            ),
          ),
          shadowColor: MaterialStateProperty.all(const Color(0x115A6CEA)),
          elevation: MaterialStateProperty.all(50),
        ),
        onPressed: () {
          onPressed!();
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              buttonName,
              style: TextStyle(
                color: tcolor,
                fontWeight: FontWeight.w300,
                fontSize: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
