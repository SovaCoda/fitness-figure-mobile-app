//
//  Generated code. Do not modify.
//  source: routes.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class LeaderboardType extends $pb.ProtobufEnum {
  static const LeaderboardType GLOBAL = LeaderboardType._(0, _omitEnumNames ? '' : 'GLOBAL');
  static const LeaderboardType FRIENDS_ONLY = LeaderboardType._(1, _omitEnumNames ? '' : 'FRIENDS_ONLY');

  static const $core.List<LeaderboardType> values = <LeaderboardType> [
    GLOBAL,
    FRIENDS_ONLY,
  ];

  static final $core.Map<$core.int, LeaderboardType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static LeaderboardType? valueOf($core.int value) => _byValue[value];

  const LeaderboardType._($core.int v, $core.String n) : super(v, n);
}

class LeaderboardTimeFrame extends $pb.ProtobufEnum {
  static const LeaderboardTimeFrame WEEKLY = LeaderboardTimeFrame._(0, _omitEnumNames ? '' : 'WEEKLY');
  static const LeaderboardTimeFrame ALL_TIME = LeaderboardTimeFrame._(1, _omitEnumNames ? '' : 'ALL_TIME');

  static const $core.List<LeaderboardTimeFrame> values = <LeaderboardTimeFrame> [
    WEEKLY,
    ALL_TIME,
  ];

  static final $core.Map<$core.int, LeaderboardTimeFrame> _byValue = $pb.ProtobufEnum.initByValue(values);
  static LeaderboardTimeFrame? valueOf($core.int value) => _byValue[value];

  const LeaderboardTimeFrame._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
