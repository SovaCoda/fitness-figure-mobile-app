import 'package:flutter/material.dart';

class FFAppSlider extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double> onChanged;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;
  final String? label;

  const FFAppSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
  });

  @override
  FFAppSliderState createState() => FFAppSliderState();
}

class FFAppSliderState extends State<FFAppSlider> {
  double _currentDragValue = 0.0;
  bool _dragging = false;

  // Convert user value to normalized value (0.0 to 1.0)
  double _normalize(double value) {
    return (value - widget.min) / (widget.max - widget.min);
  }

  // Convert normalized value to user value
  double _denormalize(double normalized) {
    return normalized * (widget.max - widget.min) + widget.min;
  }

  // Apply divisions if specified
  double _discretize(double value) {
    if (widget.divisions == null) return value;
    final double result =
        (value * widget.divisions!).round() / widget.divisions!;
    return result.clamp(0.0, 1.0);
  }

  void _handleDragUpdate(
      DragUpdateDetails details, BoxConstraints constraints,) {
    if (!_dragging) {
      _dragging = true;
      widget.onChangeStart?.call(widget.value);
    }

    final double delta = details.delta.dx / constraints.maxWidth;
    final double newValue = (_currentDragValue + delta).clamp(0.0, 1.0);
    _currentDragValue = newValue;

    final double discretizedValue = _discretize(newValue);
    final double finalValue = _denormalize(discretizedValue);

    widget.onChanged(finalValue);
  }

  void _handleDragEnd() {
    if (_dragging) {
      _dragging = false;
      widget.onChangeEnd?.call(widget.value);
    }
  }

  void _handleTapDown(TapDownDetails details, BoxConstraints constraints) {
    final double position = details.localPosition.dx / constraints.maxWidth;
    final double discretizedValue = _discretize(position.clamp(0.0, 1.0));
    final double finalValue = _denormalize(discretizedValue);

    widget.onChangeStart?.call(finalValue);
    widget.onChanged(finalValue);
    widget.onChangeEnd?.call(finalValue);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double normalizedValue = _normalize(widget.value);
        final double sliderWidth = constraints.maxWidth * 0.95;
        final double sliderHeight = MediaQuery.of(context).size.height *
            0.0351408450704225352112676056338;
        final double thumbWidth = MediaQuery.of(context).size.width *
            0.11101781170483460559796437659033;
        final double thumbHeight = MediaQuery.of(context).size.height *
            0.04618544600938967136150234741784;

        return GestureDetector(
          onTapDown: (details) => _handleTapDown(details, constraints),
          onHorizontalDragStart: (details) {
            _currentDragValue = normalizedValue;
          },
          onHorizontalDragUpdate: (details) =>
              _handleDragUpdate(details, constraints),
          onHorizontalDragEnd: (_) => _handleDragEnd(),
          child: SizedBox(
            width: sliderWidth,
            height: sliderHeight + thumbWidth,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  child: Image.asset(
                    "lib/assets/art/slider_start.png",
                    height: sliderHeight,
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  left: 0,
                  child: ClipRect(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      widthFactor: normalizedValue,
                      child: Image.asset(
                        "lib/assets/art/slider_end.png",
                        width: sliderWidth,
                        height: sliderHeight,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: (sliderWidth * normalizedValue) - (thumbWidth / 2),
                  child: Image.asset(
                    'lib/assets/art/custom_thumb.png',
                    width: thumbWidth,
                    height: thumbHeight,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
