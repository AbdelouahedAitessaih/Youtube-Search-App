import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CentredMessage extends StatelessWidget {
  final String message;
  final IconData icon;
  CentredMessage({Key key, @required this.message, @required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Opacity(
        opacity: 0.5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              size: 45,
            ),
            Text(
              message,
              style: TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold
              ),
            )
          ],
        ),
      ),
    );
  }
}
