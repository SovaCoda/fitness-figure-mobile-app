//
//  Generated code. Do not modify.
//  source: routes.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use genericStringResponseDescriptor instead')
const GenericStringResponse$json = {
  '1': 'GenericStringResponse',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `GenericStringResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List genericStringResponseDescriptor = $convert.base64Decode(
    'ChVHZW5lcmljU3RyaW5nUmVzcG9uc2USGAoHbWVzc2FnZRgBIAEoCVIHbWVzc2FnZQ==');

@$core.Deprecated('Use workoutDescriptor instead')
const Workout$json = {
  '1': 'Workout',
  '2': [
    {'1': 'Email', '3': 1, '4': 1, '5': 9, '10': 'Email'},
    {'1': 'Start_date', '3': 2, '4': 1, '5': 9, '10': 'StartDate'},
    {'1': 'Elapsed', '3': 3, '4': 1, '5': 3, '10': 'Elapsed'},
    {'1': 'Evo_Add', '3': 4, '4': 1, '5': 3, '10': 'EvoAdd'},
    {'1': 'End_Date', '3': 5, '4': 1, '5': 9, '10': 'EndDate'},
    {'1': 'Charge_Add', '3': 6, '4': 1, '5': 3, '10': 'ChargeAdd'},
    {'1': 'Countable', '3': 7, '4': 1, '5': 5, '10': 'Countable'},
    {'1': 'Robot_Name', '3': 8, '4': 1, '5': 9, '10': 'RobotName'},
    {'1': 'investment', '3': 9, '4': 1, '5': 1, '10': 'investment'},
  ],
};

/// Descriptor for `Workout`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workoutDescriptor = $convert.base64Decode(
    'CgdXb3Jrb3V0EhQKBUVtYWlsGAEgASgJUgVFbWFpbBIdCgpTdGFydF9kYXRlGAIgASgJUglTdG'
    'FydERhdGUSGAoHRWxhcHNlZBgDIAEoA1IHRWxhcHNlZBIXCgdFdm9fQWRkGAQgASgDUgZFdm9B'
    'ZGQSGQoIRW5kX0RhdGUYBSABKAlSB0VuZERhdGUSHQoKQ2hhcmdlX0FkZBgGIAEoA1IJQ2hhcm'
    'dlQWRkEhwKCUNvdW50YWJsZRgHIAEoBVIJQ291bnRhYmxlEh0KClJvYm90X05hbWUYCCABKAlS'
    'CVJvYm90TmFtZRIeCgppbnZlc3RtZW50GAkgASgBUgppbnZlc3RtZW50');

@$core.Deprecated('Use multiWorkoutDescriptor instead')
const MultiWorkout$json = {
  '1': 'MultiWorkout',
  '2': [
    {'1': 'workouts', '3': 1, '4': 3, '5': 11, '6': '.routes.Workout', '10': 'workouts'},
  ],
};

/// Descriptor for `MultiWorkout`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List multiWorkoutDescriptor = $convert.base64Decode(
    'CgxNdWx0aVdvcmtvdXQSKwoId29ya291dHMYASADKAsyDy5yb3V0ZXMuV29ya291dFIId29ya2'
    '91dHM=');

@$core.Deprecated('Use userDescriptor instead')
const User$json = {
  '1': 'User',
  '2': [
    {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
    {'1': 'cur_figure', '3': 2, '4': 1, '5': 9, '10': 'curFigure'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'currency', '3': 4, '4': 1, '5': 1, '10': 'currency'},
    {'1': 'week_complete', '3': 5, '4': 1, '5': 3, '10': 'weekComplete'},
    {'1': 'week_goal', '3': 6, '4': 1, '5': 3, '10': 'weekGoal'},
    {'1': 'cur_workout', '3': 7, '4': 1, '5': 9, '10': 'curWorkout'},
    {'1': 'workout_min_time', '3': 8, '4': 1, '5': 3, '10': 'workoutMinTime'},
    {'1': 'last_login', '3': 9, '4': 1, '5': 9, '10': 'lastLogin'},
    {'1': 'streak', '3': 10, '4': 1, '5': 3, '10': 'streak'},
    {'1': 'premium', '3': 11, '4': 1, '5': 3, '10': 'premium'},
    {'1': 'ready_for_week_reset', '3': 12, '4': 1, '5': 9, '10': 'readyForWeekReset'},
    {'1': 'is_in_grace_period', '3': 13, '4': 1, '5': 9, '10': 'isInGracePeriod'},
    {'1': 'daily_chat_messages', '3': 14, '4': 1, '5': 3, '10': 'dailyChatMessages'},
  ],
};

/// Descriptor for `User`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userDescriptor = $convert.base64Decode(
    'CgRVc2VyEhQKBWVtYWlsGAEgASgJUgVlbWFpbBIdCgpjdXJfZmlndXJlGAIgASgJUgljdXJGaW'
    'd1cmUSEgoEbmFtZRgDIAEoCVIEbmFtZRIaCghjdXJyZW5jeRgEIAEoAVIIY3VycmVuY3kSIwoN'
    'd2Vla19jb21wbGV0ZRgFIAEoA1IMd2Vla0NvbXBsZXRlEhsKCXdlZWtfZ29hbBgGIAEoA1IId2'
    'Vla0dvYWwSHwoLY3VyX3dvcmtvdXQYByABKAlSCmN1cldvcmtvdXQSKAoQd29ya291dF9taW5f'
    'dGltZRgIIAEoA1IOd29ya291dE1pblRpbWUSHQoKbGFzdF9sb2dpbhgJIAEoCVIJbGFzdExvZ2'
    'luEhYKBnN0cmVhaxgKIAEoA1IGc3RyZWFrEhgKB3ByZW1pdW0YCyABKANSB3ByZW1pdW0SLwoU'
    'cmVhZHlfZm9yX3dlZWtfcmVzZXQYDCABKAlSEXJlYWR5Rm9yV2Vla1Jlc2V0EisKEmlzX2luX2'
    'dyYWNlX3BlcmlvZBgNIAEoCVIPaXNJbkdyYWNlUGVyaW9kEi4KE2RhaWx5X2NoYXRfbWVzc2Fn'
    'ZXMYDiABKANSEWRhaWx5Q2hhdE1lc3NhZ2Vz');

@$core.Deprecated('Use userInfoDescriptor instead')
const UserInfo$json = {
  '1': 'UserInfo',
  '2': [
    {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.routes.User', '10': 'user'},
    {'1': 'figures', '3': 2, '4': 1, '5': 11, '6': '.routes.MultiFigureInstance', '10': 'figures'},
    {'1': 'workouts', '3': 3, '4': 1, '5': 11, '6': '.routes.MultiWorkout', '10': 'workouts'},
  ],
};

/// Descriptor for `UserInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userInfoDescriptor = $convert.base64Decode(
    'CghVc2VySW5mbxIgCgR1c2VyGAEgASgLMgwucm91dGVzLlVzZXJSBHVzZXISNQoHZmlndXJlcx'
    'gCIAEoCzIbLnJvdXRlcy5NdWx0aUZpZ3VyZUluc3RhbmNlUgdmaWd1cmVzEjAKCHdvcmtvdXRz'
    'GAMgASgLMhQucm91dGVzLk11bHRpV29ya291dFIId29ya291dHM=');

@$core.Deprecated('Use dailySnapshotDescriptor instead')
const DailySnapshot$json = {
  '1': 'DailySnapshot',
  '2': [
    {'1': 'User_Email', '3': 1, '4': 1, '5': 9, '10': 'UserEmail'},
    {'1': 'Date', '3': 2, '4': 1, '5': 9, '10': 'Date'},
    {'1': 'Figure_Name', '3': 3, '4': 1, '5': 9, '10': 'FigureName'},
    {'1': 'Ev_Points', '3': 4, '4': 1, '5': 5, '10': 'EvPoints'},
    {'1': 'Ev_Level', '3': 5, '4': 1, '5': 5, '10': 'EvLevel'},
    {'1': 'Charge', '3': 6, '4': 1, '5': 5, '10': 'Charge'},
    {'1': 'User_Streak', '3': 7, '4': 1, '5': 5, '10': 'UserStreak'},
    {'1': 'User_Week_Complete', '3': 8, '4': 1, '5': 5, '10': 'UserWeekComplete'},
    {'1': 'User_Week_Goal', '3': 9, '4': 1, '5': 5, '10': 'UserWeekGoal'},
    {'1': 'User_Workout_Min_Time', '3': 10, '4': 1, '5': 5, '10': 'UserWorkoutMinTime'},
    {'1': 'User_Currency', '3': 11, '4': 1, '5': 5, '10': 'UserCurrency'},
  ],
};

/// Descriptor for `DailySnapshot`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dailySnapshotDescriptor = $convert.base64Decode(
    'Cg1EYWlseVNuYXBzaG90Eh0KClVzZXJfRW1haWwYASABKAlSCVVzZXJFbWFpbBISCgREYXRlGA'
    'IgASgJUgREYXRlEh8KC0ZpZ3VyZV9OYW1lGAMgASgJUgpGaWd1cmVOYW1lEhsKCUV2X1BvaW50'
    'cxgEIAEoBVIIRXZQb2ludHMSGQoIRXZfTGV2ZWwYBSABKAVSB0V2TGV2ZWwSFgoGQ2hhcmdlGA'
    'YgASgFUgZDaGFyZ2USHwoLVXNlcl9TdHJlYWsYByABKAVSClVzZXJTdHJlYWsSLAoSVXNlcl9X'
    'ZWVrX0NvbXBsZXRlGAggASgFUhBVc2VyV2Vla0NvbXBsZXRlEiQKDlVzZXJfV2Vla19Hb2FsGA'
    'kgASgFUgxVc2VyV2Vla0dvYWwSMQoVVXNlcl9Xb3Jrb3V0X01pbl9UaW1lGAogASgFUhJVc2Vy'
    'V29ya291dE1pblRpbWUSIwoNVXNlcl9DdXJyZW5jeRgLIAEoBVIMVXNlckN1cnJlbmN5');

@$core.Deprecated('Use multiDailySnapshotDescriptor instead')
const MultiDailySnapshot$json = {
  '1': 'MultiDailySnapshot',
  '2': [
    {'1': 'dailySnapshots', '3': 1, '4': 3, '5': 11, '6': '.routes.DailySnapshot', '10': 'dailySnapshots'},
  ],
};

/// Descriptor for `MultiDailySnapshot`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List multiDailySnapshotDescriptor = $convert.base64Decode(
    'ChJNdWx0aURhaWx5U25hcHNob3QSPQoOZGFpbHlTbmFwc2hvdHMYASADKAsyFS5yb3V0ZXMuRG'
    'FpbHlTbmFwc2hvdFIOZGFpbHlTbmFwc2hvdHM=');

@$core.Deprecated('Use multiUserDescriptor instead')
const MultiUser$json = {
  '1': 'MultiUser',
  '2': [
    {'1': 'users', '3': 1, '4': 3, '5': 11, '6': '.routes.User', '10': 'users'},
  ],
};

/// Descriptor for `MultiUser`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List multiUserDescriptor = $convert.base64Decode(
    'CglNdWx0aVVzZXISIgoFdXNlcnMYASADKAsyDC5yb3V0ZXMuVXNlclIFdXNlcnM=');

@$core.Deprecated('Use figureInstanceDescriptor instead')
const FigureInstance$json = {
  '1': 'FigureInstance',
  '2': [
    {'1': 'Figure_Id', '3': 1, '4': 1, '5': 9, '10': 'FigureId'},
    {'1': 'Figure_Name', '3': 2, '4': 1, '5': 9, '10': 'FigureName'},
    {'1': 'User_Email', '3': 3, '4': 1, '5': 9, '10': 'UserEmail'},
    {'1': 'Cur_Skin', '3': 4, '4': 1, '5': 9, '10': 'CurSkin'},
    {'1': 'Ev_Points', '3': 5, '4': 1, '5': 5, '10': 'EvPoints'},
    {'1': 'Charge', '3': 6, '4': 1, '5': 5, '10': 'Charge'},
    {'1': 'Mood', '3': 7, '4': 1, '5': 5, '10': 'Mood'},
    {'1': 'Last_Reset', '3': 8, '4': 1, '5': 9, '10': 'LastReset'},
    {'1': 'Ev_Level', '3': 9, '4': 1, '5': 5, '10': 'EvLevel'},
  ],
};

/// Descriptor for `FigureInstance`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List figureInstanceDescriptor = $convert.base64Decode(
    'Cg5GaWd1cmVJbnN0YW5jZRIbCglGaWd1cmVfSWQYASABKAlSCEZpZ3VyZUlkEh8KC0ZpZ3VyZV'
    '9OYW1lGAIgASgJUgpGaWd1cmVOYW1lEh0KClVzZXJfRW1haWwYAyABKAlSCVVzZXJFbWFpbBIZ'
    'CghDdXJfU2tpbhgEIAEoCVIHQ3VyU2tpbhIbCglFdl9Qb2ludHMYBSABKAVSCEV2UG9pbnRzEh'
    'YKBkNoYXJnZRgGIAEoBVIGQ2hhcmdlEhIKBE1vb2QYByABKAVSBE1vb2QSHQoKTGFzdF9SZXNl'
    'dBgIIAEoCVIJTGFzdFJlc2V0EhkKCEV2X0xldmVsGAkgASgFUgdFdkxldmVs');

@$core.Deprecated('Use multiFigureInstanceDescriptor instead')
const MultiFigureInstance$json = {
  '1': 'MultiFigureInstance',
  '2': [
    {'1': 'figureInstances', '3': 1, '4': 3, '5': 11, '6': '.routes.FigureInstance', '10': 'figureInstances'},
  ],
};

/// Descriptor for `MultiFigureInstance`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List multiFigureInstanceDescriptor = $convert.base64Decode(
    'ChNNdWx0aUZpZ3VyZUluc3RhbmNlEkAKD2ZpZ3VyZUluc3RhbmNlcxgBIAMoCzIWLnJvdXRlcy'
    '5GaWd1cmVJbnN0YW5jZVIPZmlndXJlSW5zdGFuY2Vz');

@$core.Deprecated('Use figureDescriptor instead')
const Figure$json = {
  '1': 'Figure',
  '2': [
    {'1': 'Figure_Name', '3': 1, '4': 1, '5': 9, '10': 'FigureName'},
    {'1': 'Base_Ev_Gain', '3': 2, '4': 1, '5': 5, '10': 'BaseEvGain'},
    {'1': 'Base_Currency_Gain', '3': 3, '4': 1, '5': 5, '10': 'BaseCurrencyGain'},
    {'1': 'Price', '3': 4, '4': 1, '5': 5, '10': 'Price'},
    {'1': 'Stage1_Ev_Cutoff', '3': 5, '4': 1, '5': 5, '10': 'Stage1EvCutoff'},
    {'1': 'Stage2_Ev_Cutoff', '3': 6, '4': 1, '5': 5, '10': 'Stage2EvCutoff'},
    {'1': 'Stage3_Ev_Cutoff', '3': 7, '4': 1, '5': 5, '10': 'Stage3EvCutoff'},
    {'1': 'Stage4_Ev_Cutoff', '3': 8, '4': 1, '5': 5, '10': 'Stage4EvCutoff'},
    {'1': 'Stage5_Ev_Cutoff', '3': 9, '4': 1, '5': 5, '10': 'Stage5EvCutoff'},
    {'1': 'Stage6_Ev_Cutoff', '3': 10, '4': 1, '5': 5, '10': 'Stage6EvCutoff'},
    {'1': 'Stage7_Ev_Cutoff', '3': 11, '4': 1, '5': 5, '10': 'Stage7EvCutoff'},
    {'1': 'Stage8_Ev_Cutoff', '3': 12, '4': 1, '5': 5, '10': 'Stage8EvCutoff'},
    {'1': 'Stage9_Ev_Cutoff', '3': 13, '4': 1, '5': 5, '10': 'Stage9EvCutoff'},
    {'1': 'Stage10_Ev_Cutoff', '3': 14, '4': 1, '5': 5, '10': 'Stage10EvCutoff'},
  ],
};

/// Descriptor for `Figure`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List figureDescriptor = $convert.base64Decode(
    'CgZGaWd1cmUSHwoLRmlndXJlX05hbWUYASABKAlSCkZpZ3VyZU5hbWUSIAoMQmFzZV9Fdl9HYW'
    'luGAIgASgFUgpCYXNlRXZHYWluEiwKEkJhc2VfQ3VycmVuY3lfR2FpbhgDIAEoBVIQQmFzZUN1'
    'cnJlbmN5R2FpbhIUCgVQcmljZRgEIAEoBVIFUHJpY2USKAoQU3RhZ2UxX0V2X0N1dG9mZhgFIA'
    'EoBVIOU3RhZ2UxRXZDdXRvZmYSKAoQU3RhZ2UyX0V2X0N1dG9mZhgGIAEoBVIOU3RhZ2UyRXZD'
    'dXRvZmYSKAoQU3RhZ2UzX0V2X0N1dG9mZhgHIAEoBVIOU3RhZ2UzRXZDdXRvZmYSKAoQU3RhZ2'
    'U0X0V2X0N1dG9mZhgIIAEoBVIOU3RhZ2U0RXZDdXRvZmYSKAoQU3RhZ2U1X0V2X0N1dG9mZhgJ'
    'IAEoBVIOU3RhZ2U1RXZDdXRvZmYSKAoQU3RhZ2U2X0V2X0N1dG9mZhgKIAEoBVIOU3RhZ2U2RX'
    'ZDdXRvZmYSKAoQU3RhZ2U3X0V2X0N1dG9mZhgLIAEoBVIOU3RhZ2U3RXZDdXRvZmYSKAoQU3Rh'
    'Z2U4X0V2X0N1dG9mZhgMIAEoBVIOU3RhZ2U4RXZDdXRvZmYSKAoQU3RhZ2U5X0V2X0N1dG9mZh'
    'gNIAEoBVIOU3RhZ2U5RXZDdXRvZmYSKgoRU3RhZ2UxMF9Fdl9DdXRvZmYYDiABKAVSD1N0YWdl'
    'MTBFdkN1dG9mZg==');

@$core.Deprecated('Use multiFigureDescriptor instead')
const MultiFigure$json = {
  '1': 'MultiFigure',
  '2': [
    {'1': 'figures', '3': 1, '4': 3, '5': 11, '6': '.routes.Figure', '10': 'figures'},
  ],
};

/// Descriptor for `MultiFigure`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List multiFigureDescriptor = $convert.base64Decode(
    'CgtNdWx0aUZpZ3VyZRIoCgdmaWd1cmVzGAEgAygLMg4ucm91dGVzLkZpZ3VyZVIHZmlndXJlcw'
    '==');

@$core.Deprecated('Use skinInstanceDescriptor instead')
const SkinInstance$json = {
  '1': 'SkinInstance',
  '2': [
    {'1': 'Skin_Id', '3': 1, '4': 1, '5': 9, '10': 'SkinId'},
    {'1': 'Skin_Name', '3': 2, '4': 1, '5': 9, '10': 'SkinName'},
    {'1': 'User_Email', '3': 3, '4': 1, '5': 9, '10': 'UserEmail'},
    {'1': 'Figure_Name', '3': 4, '4': 1, '5': 9, '10': 'FigureName'},
  ],
};

/// Descriptor for `SkinInstance`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List skinInstanceDescriptor = $convert.base64Decode(
    'CgxTa2luSW5zdGFuY2USFwoHU2tpbl9JZBgBIAEoCVIGU2tpbklkEhsKCVNraW5fTmFtZRgCIA'
    'EoCVIIU2tpbk5hbWUSHQoKVXNlcl9FbWFpbBgDIAEoCVIJVXNlckVtYWlsEh8KC0ZpZ3VyZV9O'
    'YW1lGAQgASgJUgpGaWd1cmVOYW1l');

@$core.Deprecated('Use multiSkinInstanceDescriptor instead')
const MultiSkinInstance$json = {
  '1': 'MultiSkinInstance',
  '2': [
    {'1': 'skinInstances', '3': 1, '4': 3, '5': 11, '6': '.routes.SkinInstance', '10': 'skinInstances'},
  ],
};

/// Descriptor for `MultiSkinInstance`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List multiSkinInstanceDescriptor = $convert.base64Decode(
    'ChFNdWx0aVNraW5JbnN0YW5jZRI6Cg1za2luSW5zdGFuY2VzGAEgAygLMhQucm91dGVzLlNraW'
    '5JbnN0YW5jZVINc2tpbkluc3RhbmNlcw==');

@$core.Deprecated('Use skinDescriptor instead')
const Skin$json = {
  '1': 'Skin',
  '2': [
    {'1': 'Skin_Name', '3': 1, '4': 1, '5': 9, '10': 'SkinName'},
    {'1': 'Figure_Name', '3': 2, '4': 1, '5': 9, '10': 'FigureName'},
    {'1': 'Price', '3': 3, '4': 1, '5': 5, '10': 'Price'},
  ],
};

/// Descriptor for `Skin`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List skinDescriptor = $convert.base64Decode(
    'CgRTa2luEhsKCVNraW5fTmFtZRgBIAEoCVIIU2tpbk5hbWUSHwoLRmlndXJlX05hbWUYAiABKA'
    'lSCkZpZ3VyZU5hbWUSFAoFUHJpY2UYAyABKAVSBVByaWNl');

@$core.Deprecated('Use multiSkinDescriptor instead')
const MultiSkin$json = {
  '1': 'MultiSkin',
  '2': [
    {'1': 'skins', '3': 1, '4': 3, '5': 11, '6': '.routes.Skin', '10': 'skins'},
  ],
};

/// Descriptor for `MultiSkin`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List multiSkinDescriptor = $convert.base64Decode(
    'CglNdWx0aVNraW4SIgoFc2tpbnMYASADKAsyDC5yb3V0ZXMuU2tpblIFc2tpbnM=');

@$core.Deprecated('Use surveyResponseDescriptor instead')
const SurveyResponse$json = {
  '1': 'SurveyResponse',
  '2': [
    {'1': 'Email', '3': 1, '4': 1, '5': 9, '10': 'Email'},
    {'1': 'Question', '3': 2, '4': 1, '5': 9, '10': 'Question'},
    {'1': 'Answer', '3': 3, '4': 1, '5': 9, '10': 'Answer'},
    {'1': 'Date', '3': 4, '4': 1, '5': 9, '10': 'Date'},
  ],
};

/// Descriptor for `SurveyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List surveyResponseDescriptor = $convert.base64Decode(
    'Cg5TdXJ2ZXlSZXNwb25zZRIUCgVFbWFpbBgBIAEoCVIFRW1haWwSGgoIUXVlc3Rpb24YAiABKA'
    'lSCFF1ZXN0aW9uEhYKBkFuc3dlchgDIAEoCVIGQW5zd2VyEhIKBERhdGUYBCABKAlSBERhdGU=');

@$core.Deprecated('Use multiSurveyResponseDescriptor instead')
const MultiSurveyResponse$json = {
  '1': 'MultiSurveyResponse',
  '2': [
    {'1': 'surveyResponses', '3': 1, '4': 3, '5': 11, '6': '.routes.SurveyResponse', '10': 'surveyResponses'},
  ],
};

/// Descriptor for `MultiSurveyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List multiSurveyResponseDescriptor = $convert.base64Decode(
    'ChNNdWx0aVN1cnZleVJlc3BvbnNlEkAKD3N1cnZleVJlc3BvbnNlcxgBIAMoCzIWLnJvdXRlcy'
    '5TdXJ2ZXlSZXNwb25zZVIPc3VydmV5UmVzcG9uc2Vz');

@$core.Deprecated('Use offlineDateTimeDescriptor instead')
const OfflineDateTime$json = {
  '1': 'OfflineDateTime',
  '2': [
    {'1': 'Email', '3': 1, '4': 1, '5': 9, '10': 'Email'},
    {'1': 'Currency', '3': 2, '4': 1, '5': 9, '10': 'Currency'},
  ],
};

/// Descriptor for `OfflineDateTime`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offlineDateTimeDescriptor = $convert.base64Decode(
    'Cg9PZmZsaW5lRGF0ZVRpbWUSFAoFRW1haWwYASABKAlSBUVtYWlsEhoKCEN1cnJlbmN5GAIgAS'
    'gJUghDdXJyZW5jeQ==');

@$core.Deprecated('Use subscriptionTimeStampDescriptor instead')
const SubscriptionTimeStamp$json = {
  '1': 'SubscriptionTimeStamp',
  '2': [
    {'1': 'Email', '3': 1, '4': 1, '5': 9, '10': 'Email'},
    {'1': 'SubscribedOn', '3': 2, '4': 1, '5': 9, '10': 'SubscribedOn'},
    {'1': 'ExpiresOn', '3': 3, '4': 1, '5': 9, '10': 'ExpiresOn'},
    {'1': 'Transaction_Id', '3': 4, '4': 1, '5': 9, '10': 'TransactionId'},
  ],
};

/// Descriptor for `SubscriptionTimeStamp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subscriptionTimeStampDescriptor = $convert.base64Decode(
    'ChVTdWJzY3JpcHRpb25UaW1lU3RhbXASFAoFRW1haWwYASABKAlSBUVtYWlsEiIKDFN1YnNjcm'
    'liZWRPbhgCIAEoCVIMU3Vic2NyaWJlZE9uEhwKCUV4cGlyZXNPbhgDIAEoCVIJRXhwaXJlc09u'
    'EiUKDlRyYW5zYWN0aW9uX0lkGAQgASgJUg1UcmFuc2FjdGlvbklk');

@$core.Deprecated('Use updateEmailRequestDescriptor instead')
const UpdateEmailRequest$json = {
  '1': 'UpdateEmailRequest',
  '2': [
    {'1': 'old_email', '3': 1, '4': 1, '5': 9, '10': 'oldEmail'},
    {'1': 'new_email', '3': 2, '4': 1, '5': 9, '10': 'newEmail'},
  ],
};

/// Descriptor for `UpdateEmailRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateEmailRequestDescriptor = $convert.base64Decode(
    'ChJVcGRhdGVFbWFpbFJlcXVlc3QSGwoJb2xkX2VtYWlsGAEgASgJUghvbGRFbWFpbBIbCgluZX'
    'dfZW1haWwYAiABKAlSCG5ld0VtYWls');

