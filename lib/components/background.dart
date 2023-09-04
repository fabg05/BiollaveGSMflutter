import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;

  //const Background({required Key key, required this.child}) : super(key: key);
  const Background({Key? key, required this.child}) : super(key: key);
  // const Background({
  //   Key key,
  //   @required this.child,
  // }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 40,
            left: 30,
            child: Image.asset("assets/images/biollave.png",
                width: size.width * 0.25),
          ),
        ],
      ),
    );
  }
}
