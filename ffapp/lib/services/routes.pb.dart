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

class Workout extends $pb.GeneratedMessage {
  factory Workout({
    $core.String? email,
    $core.String? startDate,
    $fixnum.Int64? elapsed,
    $fixnum.Int64? currencyAdd,
    $core.String? endDate,
    $fixnum.Int64? chargeAdd,
  }) {
    final $result = create();
    if (email != null) {
      $result.email = email;
    }
    if (startDate != null) {
      $result.startDate = startDate;
    }
    if (elapsed != null) {
      $result.elapsed = elapsed;
    }
    if (currencyAdd != null) {
      $result.currencyAdd = currencyAdd;
    }
    if (endDate != null) {
      $result.endDate = endDate;
    }
    if (chargeAdd != null) {
      $result.chargeAdd = chargeAdd;
    }
    return $result;
  }
  Workout._() : super();
  factory Workout.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Workout.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Workout', package: const $pb.PackageName(_omitMessageNames ? '' : 'routes'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'Email', protoName: 'Email')
    ..aOS(2, _omitFieldNames ? '' : 'StartDate', protoName: 'Start_date')
    ..aInt64(3, _omitFieldNames ? '' : 'Elapsed', protoName: 'Elapsed')
    ..aInt64(4, _omitFieldNames ? '' : 'CurrencyAdd', protoName: 'Currency_Add')
    ..aOS(5, _omitFieldNames ? '' : 'EndDate', protoName: 'End_Date')
    ..aInt64(6, _omitFieldNames ? '' : 'ChargeAdd', protoName: 'Charge_Add')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Workout clone() => Workout()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Workout copyWith(void Function(Workout) updates) => super.copyWith((message) => updates(message as Workout)) as Workout;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Workout create() => Workout._();
  Workout createEmptyInstance() => create();
  static $pb.PbList<Workout> createRepeated() => $pb.PbList<Workout>();
  @$core.pragma('dart2js:noInline')
  static Workout getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Workout>(create);
  static Workout? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get email => $_getSZ(0);
  @$pb.TagNumber(1)
  set email($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasEmail() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmail() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get startDate => $_getSZ(1);
  @$pb.TagNumber(2)
  set startDate($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasStartDate() => $_has(1);
  @$pb.TagNumber(2)
  void clearStartDate() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get elapsed => $_getI64(2);
  @$pb.TagNumber(3)
  set elapsed($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasElapsed() => $_has(2);
  @$pb.TagNumber(3)
  void clearElapsed() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get currencyAdd => $_getI64(3);
  @$pb.TagNumber(4)
  set currencyAdd($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCurrencyAdd() => $_has(3);
  @$pb.TagNumber(4)
  void clearCurrencyAdd() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get endDate => $_getSZ(4);
  @$pb.TagNumber(5)
  set endDate($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasEndDate() => $_has(4);
  @$pb.TagNumber(5)
  void clearEndDate() => clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get chargeAdd => $_getI64(5);
  @$pb.TagNumber(6)
  set chargeAdd($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasChargeAdd() => $_has(5);
  @$pb.TagNumber(6)
  void clearChargeAdd() => clearField(6);
}

class MultiWorkout extends $pb.GeneratedMessage {
  factory MultiWorkout({
    $core.Iterable<Workout>? workouts,
  }) {
    final $result = create();
    if (workouts != null) {
      $result.workouts.addAll(workouts);
    }
    return $result;
  }
  MultiWorkout._() : super();
  factory MultiWorkout.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MultiWorkout.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MultiWorkout', package: const $pb.PackageName(_omitMessageNames ? '' : 'routes'), createEmptyInstance: create)
    ..pc<Workout>(1, _omitFieldNames ? '' : 'workouts', $pb.PbFieldType.PM, subBuilder: Workout.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MultiWorkout clone() => MultiWorkout()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MultiWorkout copyWith(void Function(MultiWorkout) updates) => super.copyWith((message) => updates(message as MultiWorkout)) as MultiWorkout;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MultiWorkout create() => MultiWorkout._();
  MultiWorkout createEmptyInstance() => create();
  static $pb.PbList<MultiWorkout> createRepeated() => $pb.PbList<MultiWorkout>();
  @$core.pragma('dart2js:noInline')
  static MultiWorkout getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MultiWorkout>(create);
  static MultiWorkout? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Workout> get workouts => $_getList(0);
}

class User extends $pb.GeneratedMessage {
  factory User({
    $core.String? email,
    $core.String? curFigure,
    $core.String? name,
    $fixnum.Int64? currency,
    $fixnum.Int64? weekComplete,
    $fixnum.Int64? weekGoal,
    $core.String? curWorkout,
    $fixnum.Int64? workoutMinTime,
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
    if (workoutMinTime != null) {
      $result.workoutMinTime = workoutMinTime;
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
    ..aInt64(4, _omitFieldNames ? '' : 'currency')
    ..aInt64(5, _omitFieldNames ? '' : 'weekComplete')
    ..aInt64(6, _omitFieldNames ? '' : 'weekGoal')
    ..aOS(7, _omitFieldNames ? '' : 'curWorkout')
    ..aInt64(8, _omitFieldNames ? '' : 'workoutMinTime')
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
  $fixnum.Int64 get currency => $_getI64(3);
  @$pb.TagNumber(4)
  set currency($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCurrency() => $_has(3);
  @$pb.TagNumber(4)
  void clearCurrency() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get weekComplete => $_getI64(4);
  @$pb.TagNumber(5)
  set weekComplete($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasWeekComplete() => $_has(4);
  @$pb.TagNumber(5)
  void clearWeekComplete() => clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get weekGoal => $_getI64(5);
  @$pb.TagNumber(6)
  set weekGoal($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasWeekGoal() => $_has(5);
  @$pb.TagNumber(6)
  void clearWeekGoal() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get curWorkout => $_getSZ(6);
  @$pb.TagNumber(7)
  set curWorkout($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasCurWorkout() => $_has(6);
  @$pb.TagNumber(7)
  void clearCurWorkout() => clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get workoutMinTime => $_getI64(7);
  @$pb.TagNumber(8)
  set workoutMinTime($fixnum.Int64 v) { $_setInt64(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasWorkoutMinTime() => $_has(7);
  @$pb.TagNumber(8)
  void clearWorkoutMinTime() => clearField(8);
}

class Figure extends $pb.GeneratedMessage {
  factory Figure({
    $core.String? figureId,
    $core.String? name,
    $core.int? evoPoints,
    $core.int? stage,
    $core.String? userEmail,
    $core.int? charge,
  }) {
    final $result = create();
    if (figureId != null) {
      $result.figureId = figureId;
    }
    if (name != null) {
      $result.name = name;
    }
    if (evoPoints != null) {
      $result.evoPoints = evoPoints;
    }
    if (stage != null) {
      $result.stage = stage;
    }
    if (userEmail != null) {
      $result.userEmail = userEmail;
    }
    if (charge != null) {
      $result.charge = charge;
    }
    return $result;
  }
  Figure._() : super();
  factory Figure.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Figure.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Figure', package: const $pb.PackageName(_omitMessageNames ? '' : 'routes'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'FigureId', protoName: 'Figure_Id')
    ..aOS(2, _omitFieldNames ? '' : 'Name', protoName: 'Name')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'EvoPoints', $pb.PbFieldType.O3, protoName: 'Evo_points')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'Stage', $pb.PbFieldType.O3, protoName: 'Stage')
    ..aOS(5, _omitFieldNames ? '' : 'UserEmail', protoName: 'User_email')
    ..a<$core.int>(6, _omitFieldNames ? '' : 'charge', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Figure clone() => Figure()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Figure copyWith(void Function(Figure) updates) => super.copyWith((message) => updates(message as Figure)) as Figure;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Figure create() => Figure._();
  Figure createEmptyInstance() => create();
  static $pb.PbList<Figure> createRepeated() => $pb.PbList<Figure>();
  @$core.pragma('dart2js:noInline')
  static Figure getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Figure>(create);
  static Figure? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get figureId => $_getSZ(0);
  @$pb.TagNumber(1)
  set figureId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFigureId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFigureId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get evoPoints => $_getIZ(2);
  @$pb.TagNumber(3)
  set evoPoints($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasEvoPoints() => $_has(2);
  @$pb.TagNumber(3)
  void clearEvoPoints() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get stage => $_getIZ(3);
  @$pb.TagNumber(4)
  set stage($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasStage() => $_has(3);
  @$pb.TagNumber(4)
  void clearStage() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get userEmail => $_getSZ(4);
  @$pb.TagNumber(5)
  set userEmail($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasUserEmail() => $_has(4);
  @$pb.TagNumber(5)
  void clearUserEmail() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get charge => $_getIZ(5);
  @$pb.TagNumber(6)
  set charge($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasCharge() => $_has(5);
  @$pb.TagNumber(6)
  void clearCharge() => clearField(6);
}

class MultiFigure extends $pb.GeneratedMessage {
  factory MultiFigure({
    $core.Iterable<Figure>? figures,
  }) {
    final $result = create();
    if (figures != null) {
      $result.figures.addAll(figures);
    }
    return $result;
  }
  MultiFigure._() : super();
  factory MultiFigure.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MultiFigure.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MultiFigure', package: const $pb.PackageName(_omitMessageNames ? '' : 'routes'), createEmptyInstance: create)
    ..pc<Figure>(1, _omitFieldNames ? '' : 'figures', $pb.PbFieldType.PM, subBuilder: Figure.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MultiFigure clone() => MultiFigure()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MultiFigure copyWith(void Function(MultiFigure) updates) => super.copyWith((message) => updates(message as MultiFigure)) as MultiFigure;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MultiFigure create() => MultiFigure._();
  MultiFigure createEmptyInstance() => create();
  static $pb.PbList<MultiFigure> createRepeated() => $pb.PbList<MultiFigure>();
  @$core.pragma('dart2js:noInline')
  static MultiFigure getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MultiFigure>(create);
  static MultiFigure? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Figure> get figures => $_getList(0);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
