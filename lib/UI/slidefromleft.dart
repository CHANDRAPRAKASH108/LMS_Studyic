import 'package:flutter/material.dart';

class SlideFromLeft extends PageRouteBuilder {
  Widget widget;
  SlideFromLeft({required this.widget})
      : super(
            pageBuilder: (context, animation, secondaryAnimation) => widget,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                        begin: const Offset(-1.0, 0.0), end: Offset.zero)
                    .animate(animation),
                child: SlideTransition(
                  position: Tween<Offset>(
                          begin: Offset.zero, end: const Offset(-1.0, 0.0))
                      .animate(secondaryAnimation),
                  child: child,
                ),
              );
            });
}
