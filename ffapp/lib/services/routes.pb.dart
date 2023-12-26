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

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'google/protobuf/timestamp.pb.dart' as $1;

class User extends $pb.GeneratedMessage {
  factory User({
    $core.String? email,
    $core.String? curFigure,
    $core.String? name,
    $core.String? pass,
    $fixnum.Int64? currency,
    $fixnum.Int64? weekComplete,
    $fixnum.Int64? weekGoal,
    $1.Timestamp? curWorkout,
  }) {
    final $result = create();
    if (email != null) {
      $result.email = email;
    }
    if (curFigure != null) {
      $result.curFigure = curFigure;
    }
    if (name != null) {
      $result.name = name;
    }
    if (pass != null) {
      $result.pass = pass;
    }
    if (currency != null) {
      $result.currency = currency;
    }
    if (weekComplete != null) {
      $result.weekComplete = weekComplete;
    }
    if (weekGoal != null) {
      $result.weekGoal = weekGoal;
    }
    if (curWorkout != null) {
      $result.curWorkout = curWorkout;
    }
    return $result;
  }
  User._() : super();
  factory User.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory User.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'User', package: const $pb.PackageName(_omitMessageNames ? '' : 'routes'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'email')
    ..aOS(2, _omitFieldNames ? '' : 'curFigure')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'pass')
    ..aInt64(5, _omitFieldNames ? '' : 'currency')
    ..aInt64(6, _omitFieldNames ? '' : 'weekComplete')
    ..aInt64(7, _omitFieldNames ? '' : 'weekGoal')
    ..aOM<$1.Timestamp>(8, _omitFieldNames ? '' : 'curWorkout', subBuilder: $1.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  User clone() => User()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  User copyWith(void Function(User) updates) => super.copyWith((message) => updates(message as User)) as User;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static User create() => User._();
  User createEmptyInstance() => create();
  static $pb.PbList<User> createRepeated() => $pb.PbList<User>();
  @$core.pragma('dart2js:noInline')
  static User getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<User>(create);
  static User? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get email => $_getSZ(0);
  @$pb.TagNumber(1)
  set email($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasEmail() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmail() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get curFigure => $_getSZ(1);
  @$pb.TagNumber(2)
  set curFigure($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCurFigure() => $_has(1);
  @$pb.TagNumber(2)
  void clearCurFigure() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get pass => $_getSZ(3);
  @$pb.TagNumber(4)
  set pass($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPass() => $_has(3);
  @$pb.TagNumber(4)
  void clearPass() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get currency => $_getI64(4);
  @$pb.TagNumber(5)
  set currency($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasCurrency() => $_has(4);
  @$pb.TagNumber(5)
  void clearCurrency() => clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get weekComplete => $_getI64(5);
  @$pb.TagNumber(6)
  set weekComplete($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasWeekComplete() => $_has(5);
  @$pb.TagNumber(6)
  void clearWeekComplete() => clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get weekGoal => $_getI64(6);
  @$pb.TagNumber(7)
  set weekGoal($fixnum.Int64 v) { $_setInt64(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasWeekGoal() => $_has(6);
  @$pb.TagNumber(7)
  void clearWeekGoal() => clearField(7);

  @$pb.TagNumber(8)
  $1.Timestamp get curWorkout => $_getN(7);
  @$pb.TagNumber(8)
  set curWorkout($1.Timestamp v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasCurWorkout() => $_has(7);
  @$pb.TagNumber(8)
  void clearCurWorkout() => clearField(8);
  @$pb.TagNumber(8)
  $1.Timestamp ensureCurWorkout() => $_ensure(7);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
