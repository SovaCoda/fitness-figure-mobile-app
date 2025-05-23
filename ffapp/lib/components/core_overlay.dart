import 'package:ffapp/components/animated_core.dart';
import 'package:ffapp/services/auth.dart';
import 'package:flutter/material.dart';

OverlayEntry coreOverlay = OverlayEntry(builder: (context) {
  return AnimatedOverlayWidget(onRemoveOverlay: () {
    try {
      coreOverlay.remove();
    } on AssertionError catch (e) {
      logger.e(e);
    }
  });
});
