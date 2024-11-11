import 'package:flutter/material.dart';

extension adjustColorLightness on HSLColor{
  HSLColor adjustLightness(double percentage) {
    
    final double lightnessNewValue = double.parse(
      (
        this.lightness / 2 + (percentage / 100) / 2
        ).clamp(0.0, 1.0
      ).toStringAsFixed(1)
    );
    print(lightnessNewValue);

    final adjustedColor = HSLColor.fromAHSL(this.alpha, this.hue, this.saturation, lightnessNewValue);
    print(adjustedColor.lightness);
    return adjustedColor;
  }
}