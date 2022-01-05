import 'package:currency_converter_app/ui/app_colors.dart';
import 'package:flutter/material.dart';

class SwapButton extends StatefulWidget {
  final Function onTapAction;
  const SwapButton(this.onTapAction);

  @override
  _SwapButtonState createState() => _SwapButtonState(this.onTapAction);
}

class _SwapButtonState extends State<SwapButton> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOutBack,
  );

  final Function onTapAction;

  _SwapButtonState(this.onTapAction);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: AppColors.button,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
      child: RotationTransition(
        turns: _animation,
        child: Icon(
          Icons.swap_vert,
          color: AppColors.background2,
          size: 40,
        ),
      ),
      onPressed: () async {
        this.onTapAction();
        _controller.forward();
        await Future.delayed(Duration(seconds: 1));
        _controller.reset();
      },
    );
  }
}
