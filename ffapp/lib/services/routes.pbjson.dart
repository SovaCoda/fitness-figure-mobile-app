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

