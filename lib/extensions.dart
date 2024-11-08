import 'package:flutter/material.dart';

extension adjustColorLightness on HSLColor{
  HSLColor adjustLightness(double percentage) {
    
    final lightnessNewValue = (this.lightness + percentage).clamp(0.0, 1.0);
    return HSLColor.fromAHSL(this.alpha, this.hue, this.saturation, lightnessNewValue);
  }
}