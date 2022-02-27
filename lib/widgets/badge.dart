import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final String value;
  const Badge({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      padding: const EdgeInsets.only(left: 6, top: 2),
      decoration:  BoxDecoration(
        color:  const Color(0xFF3558CD),
        borderRadius: BorderRadius.circular(10)
      ),
      
      child: Text(value, style: const TextStyle(color: Colors.white),),
    );
  }
}
