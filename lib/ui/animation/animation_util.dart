import 'package:flutter/material.dart';
class AnimationUtil {
  static const int transitionSpeed = 1000;

  static Route<T> createRightToLeftRoute<T>(widgetScreen){
    const begin = Offset(1, 0);
    const end = Offset(0, 0);
    return createAnmiationRoute(widgetScreen, begin, end);
  }

  static Route<T> createAnmiationRoute<T>(Widget screen, Offset begin, Offset end){
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: transitionSpeed),
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child){
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeInOut));
        return SlideTransition(position: animation.drive(tween), child: child,);
      },
    );
  }
}