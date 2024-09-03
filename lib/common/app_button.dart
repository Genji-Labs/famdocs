import 'package:flutter/material.dart';

class AppButton extends StatefulWidget {
  final Size size;
  final Widget child;
  final Color color;
  final Function() onPressed;
  const AppButton({super.key,required this.size,required this.onPressed,required this.child,
  required this.color});

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: widget.onPressed,
    style: Theme.of(context).textButtonTheme.style?.copyWith(
      minimumSize: WidgetStateProperty.all(widget.size),
      backgroundColor: WidgetStatePropertyAll(widget.color)
    ), child: widget.child);
  }
}
