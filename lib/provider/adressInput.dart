import 'package:flutter/material.dart';

class AdressInput extends StatelessWidget {
  final IconData iconData;
  final TextEditingController controller;
  final String hintText;
  final Function() onTap;
  final bool enabled;

  const AdressInput(
      {Key? key,
      required this.iconData,
      required this.controller,
      required this.hintText,
      required this.onTap,
      required this.enabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
            height: 40.0,
            width: MediaQuery.of(context).size.width / 1.4,
            alignment: Alignment.center,
            // padding: EdgeInsets.only(left: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: TextField(
              controller: controller,
              enabled: enabled,
              onTap: onTap,
              decoration: InputDecoration(
                hintText: hintText,
              ),
            ),
          ),
        )
      ],
    );
  }
}
