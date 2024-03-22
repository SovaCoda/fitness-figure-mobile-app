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

@$core.Deprecated('Use workoutDescriptor instead')
const Workout$json = {
  '1': 'Workout',
  '2': [
    {'1': 'Email', '3': 1, '4': 1, '5': 9, '10': 'Email'},
    {'1': 'Start_date', '3': 2, '4': 1, '5': 9, '10': 'StartDate'},
    {'1': 'Elapsed', '3': 3, '4': 1, '5': 3, '10': 'Elapsed'},
    {'1': 'Currency_Add', '3': 4, '4': 1, '5': 3, '10': 'CurrencyAdd'},
    {'1': 'End_Date', '3': 5, '4': 1, '5': 9, '10': 'EndDate'},
    {'1': 'Charge_Add', '3': 6, '4': 1, '5': 3, '10': 'ChargeAdd'},
  ],
};

/// Descriptor for `Workout`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workoutDescriptor = $convert.base64Decode(
    'CgdXb3Jrb3V0EhQKBUVtYWlsGAEgASgJUgVFbWFpbBIdCgpTdGFydF9kYXRlGAIgASgJUglTdG'
    'FydERhdGUSGAoHRWxhcHNlZBgDIAEoA1IHRWxhcHNlZBIhCgxDdXJyZW5jeV9BZGQYBCABKANS'
    'C0N1cnJlbmN5QWRkEhkKCEVuZF9EYXRlGAUgASgJUgdFbmREYXRlEh0KCkNoYXJnZV9BZGQYBi'
    'ABKANSCUNoYXJnZUFkZA==');

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
    {'1': 'currency', '3': 4, '4': 1, '5': 3, '10': 'currency'},
    {'1': 'week_complete', '3': 5, '4': 1, '5': 3, '10': 'weekComplete'},
    {'1': 'week_goal', '3': 6, '4': 1, '5': 3, '10': 'weekGoal'},
    {'1': 'cur_workout', '3': 7, '4': 1, '5': 9, '10': 'curWorkout'},
    {'1': 'workout_min_time', '3': 8, '4': 1, '5': 3, '10': 'workoutMinTime'},
  ],
};

/// Descriptor for `User`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userDescriptor = $convert.base64Decode(
    'CgRVc2VyEhQKBWVtYWlsGAEgASgJUgVlbWFpbBIdCgpjdXJfZmlndXJlGAIgASgJUgljdXJGaW'
    'd1cmUSEgoEbmFtZRgDIAEoCVIEbmFtZRIaCghjdXJyZW5jeRgEIAEoA1IIY3VycmVuY3kSIwoN'
    'd2Vla19jb21wbGV0ZRgFIAEoA1IMd2Vla0NvbXBsZXRlEhsKCXdlZWtfZ29hbBgGIAEoA1IId2'
    'Vla0dvYWwSHwoLY3VyX3dvcmtvdXQYByABKAlSCmN1cldvcmtvdXQSKAoQd29ya291dF9taW5f'
    'dGltZRgIIAEoA1IOd29ya291dE1pblRpbWU=');

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
  ],
};

/// Descriptor for `FigureInstance`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List figureInstanceDescriptor = $convert.base64Decode(
    'Cg5GaWd1cmVJbnN0YW5jZRIbCglGaWd1cmVfSWQYASABKAlSCEZpZ3VyZUlkEh8KC0ZpZ3VyZV'
    '9OYW1lGAIgASgJUgpGaWd1cmVOYW1lEh0KClVzZXJfRW1haWwYAyABKAlSCVVzZXJFbWFpbBIZ'
    'CghDdXJfU2tpbhgEIAEoCVIHQ3VyU2tpbhIbCglFdl9Qb2ludHMYBSABKAVSCEV2UG9pbnRzEh'
    'YKBkNoYXJnZRgGIAEoBVIGQ2hhcmdl');

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
  ],
};

/// Descriptor for `SkinInstance`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List skinInstanceDescriptor = $convert.base64Decode(
    'CgxTa2luSW5zdGFuY2USFwoHU2tpbl9JZBgBIAEoCVIGU2tpbklkEhsKCVNraW5fTmFtZRgCIA'
    'EoCVIIU2tpbk5hbWUSHQoKVXNlcl9FbWFpbBgDIAEoCVIJVXNlckVtYWls');

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

