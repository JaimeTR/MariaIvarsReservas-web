import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'dart:async';

class CustomNotificationError extends StatefulWidget {
  final String? message;
  final VoidCallback? onClose;

  CustomNotificationError({this.message, this.onClose});

  @override
  _CustomNotificationErrorState createState() =>
      _CustomNotificationErrorState();
}

class _CustomNotificationErrorState extends State<CustomNotificationError> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      widget.onClose!(); // Cierra la notificación después de 3 segundos
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.topCenter,
        child: Material(
          type: MaterialType.transparency,
          child: FadeInDown(
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Container(
                width: screenWidth * 0.2,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: Colors.red),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.badge, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text(widget.message ?? "Error",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 10))),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: widget.onClose,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
