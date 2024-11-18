// fitness_icon.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// icon_constants.dart
class IconConstants {
  static const String _basePath = "lib/assets/icons";
  
  static String _getPath(String name) => "$_basePath/$name.svg";
}
enum FitnessIconType {
  // add new icons here
  logo('newfflogo'),
  notify('notifyattention'),
  tick('tickicon'),
  charge('chargeicon'),
  evo('evoicon'),
  fire('fireicon'),
  premium('premium_icon'),
  success('success_text'),
  fail('fail_text'),
  speech_bubble('speech_icon'),
  logo_white('fflogowhite'),
  regular_badge('regular_badge'),
  figure_full('full_figure'),
  panel_evolution_info("panel_evolution_info"),
  panel_evolution_info_test('panel_evolution_info_test'),
  evolution_circuits('evolution_circuits'),
  // dashboard icons
  home('dashboard_icons/home'),
  home_active('dashboard_icons/home_active'),
  inventory('dashboard_icons/inventory'),
  inventory_active('dashboard_icons/inventory_active'),
  workout_adder('dashboard_icons/workout_adder'),
  workout_adder_active('dashboard_icons/workout_adder_active'),
  profile('dashboard_icons/profile'),
  profile_active('dashboard_icons/profile_active'),
  history('dashboard_icons/history'),
  history_active('dashboard_icons/history_active'),
  // calendar icons
  calendar_slot('calendar_slot_default'),
  calendar_slot_unlogged('calendar_slot_not_logged'),
  calendar_slot_logged('calendar_slot_logged'),
  calendar_slot_frozen('calendar_slot_frozen');


  final String fileName;
  const FitnessIconType(this.fileName);

  String get path => IconConstants._getPath(fileName);
}

class FitnessIcon extends StatelessWidget {
  final double? size;
  final double? height;
  final FitnessIconType type;
  final Color? color;
  
  const FitnessIcon({
    super.key, 
    required this.type,
    this.size,
    this.height, // height if needed for some icons
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      type.path,
      width: size,
      height: height ?? size, // if height is null, default to equaling the width
      colorFilter: color != null 
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }
}