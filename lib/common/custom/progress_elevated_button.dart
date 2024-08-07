import 'package:flutter/material.dart';

final GlobalKey buttonKey = GlobalKey();

class ProgressElevatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final bool autofocus;
  final Clip? clipBehavior;
  final WidgetStatesController? statesController;
  final Widget child;
  final double progress;
  final IconAlignment iconAlignment;
  final Color progressColor;

  const ProgressElevatedButton({
    super.key,
    required this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior,
    this.statesController,
    required this.child,
    required this.progress,
    required this.progressColor,
    this.iconAlignment = IconAlignment.start,
  });

  @override
  State<ProgressElevatedButton> createState() => _ProgressElevatedButtonState();
}

class _ProgressElevatedButtonState extends State<ProgressElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: buttonKey,
      onPressed: widget.onPressed,
      autofocus: widget.autofocus,
      clipBehavior: widget.clipBehavior,
      focusNode: widget.focusNode,
      iconAlignment: widget.iconAlignment,
      onFocusChange: widget.onFocusChange,
      onHover: widget.onHover,
      onLongPress: widget.onLongPress,
      statesController: widget.statesController,
      style: widget.style,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            painter: ProgressPainter(buttonKey: buttonKey, progress: widget.progress, paintColor: widget.progressColor),
          ),
          widget.child
        ],
      ),
    );
  }
}

class ProgressPainter extends CustomPainter {
  const ProgressPainter({
    required this.progress,
    required this.buttonKey,
    required this.paintColor,
  });

  final double progress;
  final GlobalKey buttonKey;
  final Color paintColor;

  @override
  void paint(Canvas canvas, Size size) {
    // Using the [buttonKey] to get the runtime size of the parent [AsyncOutlinedBtn] button
    final buttonSize = buttonKey.currentContext?.size;

    if (buttonSize == null) return;

    canvas.clipRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset.zero,
          width: buttonSize.width,
          height: buttonSize.height - 8, //? account for overflow
        ),

        // This radius is same as button border raius.
        // If you prefer, you can pass down this value from the main button.
        const Radius.circular(100),
      ),
    );
    canvas.drawRect(
      Rect.fromLTWH(
        // Top left
        -buttonSize.width / 2,
        -buttonSize.height / 2,

        // if progress = 0.5, background will take 50% of button size
        buttonSize.width * progress,
        buttonSize.height,
      ),
      Paint()..color = paintColor,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
