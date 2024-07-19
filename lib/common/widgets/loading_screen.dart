import 'package:flutter/material.dart';

class LoadingScreen {
  LoadingScreen._();

  static show(BuildContext context, String text) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: _customDialog(context, text),
          );
        });
  }

  static hide(BuildContext context) {
    Navigator.pop(context);
  }

  static _customDialog(BuildContext context, String text) {
    return PopScope(
      canPop: false,
      child: Container(
        child: Center(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const CircularProgressIndicator(
                    strokeWidth: 10,
                    valueColor: AlwaysStoppedAnimation(Colors.black),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                  ),
                  Text(
                    text,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}