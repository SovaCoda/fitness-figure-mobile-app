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

class GenericStringResponse extends $pb.GeneratedMessage {
  factory GenericStringResponse({
    $core.String? message,
  }) {
    final $result = create();
    if (message != null) {
      $result.message = message;
    }
    return $result;
  }
  GenericStringResponse._() : super();
  factory GenericStringResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GenericStringResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GenericStringResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'routes'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GenericStringResponse clone() => GenericStringResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GenericStringResponse copyWith(void Function(GenericStringResponse) updates) => super.copyWith((message) => updates(message as GenericStringResponse)) as GenericStringResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GenericStringResponse create() => GenericStringResponse._();
  GenericStringResponse createEmptyInstance() => create();
  static $pb.PbList<GenericStringResponse> createRepeated() => $pb.PbList<GenericStringResponse>();
  @$core.pragma('dart2js:noInline')
  static GenericStringResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GenericStringResponse>(create);
  static GenericStringResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => clearField(1);
}

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
    $core.String? lastReset,
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
    if (lastReset != null) {
      $result.lastReset = lastReset;
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
    ..aOS(9, _omitFieldNames ? '' : 'lastReset')
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

  @$pb.TagNumber(9)
  $core.String get lastReset => $_getSZ(8);
  @$pb.TagNumber(9)
  set lastReset($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasLastReset() => $_has(8);
  @$pb.TagNumber(9)
  void clearLastReset() => clearField(9);
}

class MultiUser extends $pb.GeneratedMessage {
  factory MultiUser({
    $core.Iterable<User>? users,
  }) {
    final $result = create();
    if (users != null) {
      $result.users.addAll(users);
    }
    return $result;
  }
  MultiUser._() : super();
  factory MultiUser.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MultiUser.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MultiUser', package: const $pb.PackageName(_omitMessageNames ? '' : 'routes'), createEmptyInstance: create)
    ..pc<User>(1, _omitFieldNames ? '' : 'users', $pb.PbFieldType.PM, subBuilder: User.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MultiUser clone() => MultiUser()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MultiUser copyWith(void Function(MultiUser) updates) => super.copyWith((message) => updates(message as MultiUser)) as MultiUser;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MultiUser create() => MultiUser._();
  MultiUser createEmptyInstance() => create();
  static $pb.PbList<MultiUser> createRepeated() => $pb.PbList<MultiUser>();
  @$core.pragma('dart2js:noInline')
  static MultiUser getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MultiUser>(create);
  static MultiUser? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<User> get users => $_getList(0);
}

class FigureInstance extends $pb.GeneratedMessage {
  factory FigureInstance({
    $core.String? figureId,
    $core.String? figureName,
    $core.String? userEmail,
    $core.String? curSkin,
    $core.int? evPoints,
    $core.int? charge,
    $core.int? mood,
    $core.String? lastReset,
    $core.int? evLevel,
  }) {
    final $result = create();
    if (figureId != null) {
      $result.figureId = figureId;
    }
    if (figureName != null) {
      $result.figureName = figureName;
    }
    if (userEmail != null) {
      $result.userEmail = userEmail;
    }
    if (curSkin != null) {
      $result.curSkin = curSkin;
    }
    if (evPoints != null) {
      $result.evPoints = evPoints;
    }
    if (charge != null) {
      $result.charge = charge;
    }
    if (mood != null) {
      $result.mood = mood;
    }
    if (lastReset != null) {
      $result.lastReset = lastReset;
    }
    if (evLevel != null) {
      $result.evLevel = evLevel;
    }
    return $result;
  }
  FigureInstance._() : super();
  factory FigureInstance.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FigureInstance.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FigureInstance', package: const $pb.PackageName(_omitMessageNames ? '' : 'routes'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'FigureId', protoName: 'Figure_Id')
    ..aOS(2, _omitFieldNames ? '' : 'FigureName', protoName: 'Figure_Name')
    ..aOS(3, _omitFieldNames ? '' : 'UserEmail', protoName: 'User_Email')
    ..aOS(4, _omitFieldNames ? '' : 'CurSkin', protoName: 'Cur_Skin')
    ..a<$core.int>(5, _omitFieldNames ? '' : 'EvPoints', $pb.PbFieldType.O3, protoName: 'Ev_Points')
    ..a<$core.int>(6, _omitFieldNames ? '' : 'Charge', $pb.PbFieldType.O3, protoName: 'Charge')
    ..a<$core.int>(7, _omitFieldNames ? '' : 'Mood', $pb.PbFieldType.O3, protoName: 'Mood')
    ..aOS(8, _omitFieldNames ? '' : 'LastReset', protoName: 'Last_Reset')
    ..a<$core.int>(9, _omitFieldNames ? '' : 'EvLevel', $pb.PbFieldType.O3, protoName: 'Ev_Level')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FigureInstance clone() => FigureInstance()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FigureInstance copyWith(void Function(FigureInstance) updates) => super.copyWith((message) => updates(message as FigureInstance)) as FigureInstance;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FigureInstance create() => FigureInstance._();
  FigureInstance createEmptyInstance() => create();
  static $pb.PbList<FigureInstance> createRepeated() => $pb.PbList<FigureInstance>();
  @$core.pragma('dart2js:noInline')
  static FigureInstance getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FigureInstance>(create);
  static FigureInstance? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get figureId => $_getSZ(0);
  @$pb.TagNumber(1)
  set figureId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFigureId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFigureId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get figureName => $_getSZ(1);
  @$pb.TagNumber(2)
  set figureName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasFigureName() => $_has(1);
  @$pb.TagNumber(2)
  void clearFigureName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get userEmail => $_getSZ(2);
  @$pb.TagNumber(3)
  set userEmail($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasUserEmail() => $_has(2);
  @$pb.TagNumber(3)
  void clearUserEmail() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get curSkin => $_getSZ(3);
  @$pb.TagNumber(4)
  set curSkin($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCurSkin() => $_has(3);
  @$pb.TagNumber(4)
  void clearCurSkin() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get evPoints => $_getIZ(4);
  @$pb.TagNumber(5)
  set evPoints($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasEvPoints() => $_has(4);
  @$pb.TagNumber(5)
  void clearEvPoints() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get charge => $_getIZ(5);
  @$pb.TagNumber(6)
  set charge($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasCharge() => $_has(5);
  @$pb.TagNumber(6)
  void clearCharge() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get mood => $_getIZ(6);
  @$pb.TagNumber(7)
  set mood($core.int v) { $_setSignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasMood() => $_has(6);
  @$pb.TagNumber(7)
  void clearMood() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get lastReset => $_getSZ(7);
  @$pb.TagNumber(8)
  set lastReset($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasLastReset() => $_has(7);
  @$pb.TagNumber(8)
  void clearLastReset() => clearField(8);

  @$pb.TagNumber(9)
  $core.int get evLevel => $_getIZ(8);
  @$pb.TagNumber(9)
  set evLevel($core.int v) { $_setSignedInt32(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasEvLevel() => $_has(8);
  @$pb.TagNumber(9)
  void clearEvLevel() => clearField(9);
}

class MultiFigureInstance extends $pb.GeneratedMessage {
  factory MultiFigureInstance({
    $core.Iterable<FigureInstance>? figureInstances,
  }) {
    final $result = create();
    if (figureInstances != null) {
      $result.figureInstances.addAll(figureInstances);
    }
    return $result;
  }
  MultiFigureInstance._() : super();
  factory MultiFigureInstance.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MultiFigureInstance.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MultiFigureInstance', package: const $pb.PackageName(_omitMessageNames ? '' : 'routes'), createEmptyInstance: create)
    ..pc<FigureInstance>(1, _omitFieldNames ? '' : 'figureInstances', $pb.PbFieldType.PM, protoName: 'figureInstances', subBuilder: FigureInstance.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MultiFigureInstance clone() => MultiFigureInstance()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MultiFigureInstance copyWith(void Function(MultiFigureInstance) updates) => super.copyWith((message) => updates(message as MultiFigureInstance)) as MultiFigureInstance;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MultiFigureInstance create() => MultiFigureInstance._();
  MultiFigureInstance createEmptyInstance() => create();
  static $pb.PbList<MultiFigureInstance> createRepeated() => $pb.PbList<MultiFigureInstance>();
  @$core.pragma('dart2js:noInline')
  static MultiFigureInstance getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MultiFigureInstance>(create);
  static MultiFigureInstance? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<FigureInstance> get figureInstances => $_getList(0);
}

class Figure extends $pb.GeneratedMessage {
  factory Figure({
    $core.String? figureName,
    $core.int? baseEvGain,
    $core.int? baseCurrencyGain,
    $core.int? price,
    $core.int? stage1EvCutoff,
    $core.int? stage2EvCutoff,
    $core.int? stage3EvCutoff,
    $core.int? stage4EvCutoff,
    $core.int? stage5EvCutoff,
    $core.int? stage6EvCutoff,
    $core.int? stage7EvCutoff,
    $core.int? stage8EvCutoff,
    $core.int? stage9EvCutoff,
    $core.int? stage10EvCutoff,
  }) {
    final $result = create();
    if (figureName != null) {
      $result.figureName = figureName;
    }
    if (baseEvGain != null) {
      $result.baseEvGain = baseEvGain;
    }
    if (baseCurrencyGain != null) {
      $result.baseCurrencyGain = baseCurrencyGain;
    }
    if (price != null) {
      $result.price = price;
    }
    if (stage1EvCutoff != null) {
      $result.stage1EvCutoff = stage1EvCutoff;
    }
    if (stage2EvCutoff != null) {
      $result.stage2EvCutoff = stage2EvCutoff;
    }
    if (stage3EvCutoff != null) {
      $result.stage3EvCutoff = stage3EvCutoff;
    }
    if (stage4EvCutoff != null) {
      $result.stage4EvCutoff = stage4EvCutoff;
    }
    if (stage5EvCutoff != null) {
      $result.stage5EvCutoff = stage5EvCutoff;
    }
    if (stage6EvCutoff != null) {
      $result.stage6EvCutoff = stage6EvCutoff;
    }
    if (stage7EvCutoff != null) {
      $result.stage7EvCutoff = stage7EvCutoff;
    }
    if (stage8EvCutoff != null) {
      $result.stage8EvCutoff = stage8EvCutoff;
    }
    if (stage9EvCutoff != null) {
      $result.stage9EvCutoff = stage9EvCutoff;
    }
    if (stage10EvCutoff != null) {
      $result.stage10EvCutoff = stage10EvCutoff;
    }
    return $result;
  }
  Figure._() : super();
  factory Figure.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Figure.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Figure', package: const $pb.PackageName(_omitMessageNames ? '' : 'routes'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'FigureName', protoName: 'Figure_Name')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'BaseEvGain', $pb.PbFieldType.O3, protoName: 'Base_Ev_Gain')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'BaseCurrencyGain', $pb.PbFieldType.O3, protoName: 'Base_Currency_Gain')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'Price', $pb.PbFieldType.O3, protoName: 'Price')
    ..a<$core.int>(5, _omitFieldNames ? '' : 'Stage1EvCutoff', $pb.PbFieldType.O3, protoName: 'Stage1_Ev_Cutoff')
    ..a<$core.int>(6, _omitFieldNames ? '' : 'Stage2EvCutoff', $pb.PbFieldType.O3, protoName: 'Stage2_Ev_Cutoff')
    ..a<$core.int>(7, _omitFieldNames ? '' : 'Stage3EvCutoff', $pb.PbFieldType.O3, protoName: 'Stage3_Ev_Cutoff')
    ..a<$core.int>(8, _omitFieldNames ? '' : 'Stage4EvCutoff', $pb.PbFieldType.O3, protoName: 'Stage4_Ev_Cutoff')
    ..a<$core.int>(9, _omitFieldNames ? '' : 'Stage5EvCutoff', $pb.PbFieldType.O3, protoName: 'Stage5_Ev_Cutoff')
    ..a<$core.int>(10, _omitFieldNames ? '' : 'Stage6EvCutoff', $pb.PbFieldType.O3, protoName: 'Stage6_Ev_Cutoff')
    ..a<$core.int>(11, _omitFieldNames ? '' : 'Stage7EvCutoff', $pb.PbFieldType.O3, protoName: 'Stage7_Ev_Cutoff')
    ..a<$core.int>(12, _omitFieldNames ? '' : 'Stage8EvCutoff', $pb.PbFieldType.O3, protoName: 'Stage8_Ev_Cutoff')
    ..a<$core.int>(13, _omitFieldNames ? '' : 'Stage9EvCutoff', $pb.PbFieldType.O3, protoName: 'Stage9_Ev_Cutoff')
    ..a<$core.int>(14, _omitFieldNames ? '' : 'Stage10EvCutoff', $pb.PbFieldType.O3, protoName: 'Stage10_Ev_Cutoff')
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
  $core.String get figureName => $_getSZ(0);
  @$pb.TagNumber(1)
  set figureName($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFigureName() => $_has(0);
  @$pb.TagNumber(1)
  void clearFigureName() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get baseEvGain => $_getIZ(1);
  @$pb.TagNumber(2)
  set baseEvGain($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBaseEvGain() => $_has(1);
  @$pb.TagNumber(2)
  void clearBaseEvGain() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get baseCurrencyGain => $_getIZ(2);
  @$pb.TagNumber(3)
  set baseCurrencyGain($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasBaseCurrencyGain() => $_has(2);
  @$pb.TagNumber(3)
  void clearBaseCurrencyGain() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get price => $_getIZ(3);
  @$pb.TagNumber(4)
  set price($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPrice() => $_has(3);
  @$pb.TagNumber(4)
  void clearPrice() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get stage1EvCutoff => $_getIZ(4);
  @$pb.TagNumber(5)
  set stage1EvCutoff($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasStage1EvCutoff() => $_has(4);
  @$pb.TagNumber(5)
  void clearStage1EvCutoff() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get stage2EvCutoff => $_getIZ(5);
  @$pb.TagNumber(6)
  set stage2EvCutoff($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasStage2EvCutoff() => $_has(5);
  @$pb.TagNumber(6)
  void clearStage2EvCutoff() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get stage3EvCutoff => $_getIZ(6);
  @$pb.TagNumber(7)
  set stage3EvCutoff($core.int v) { $_setSignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasStage3EvCutoff() => $_has(6);
  @$pb.TagNumber(7)
  void clearStage3EvCutoff() => clearField(7);

  @$pb.TagNumber(8)
  $core.int get stage4EvCutoff => $_getIZ(7);
  @$pb.TagNumber(8)
  set stage4EvCutoff($core.int v) { $_setSignedInt32(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasStage4EvCutoff() => $_has(7);
  @$pb.TagNumber(8)
  void clearStage4EvCutoff() => clearField(8);

  @$pb.TagNumber(9)
  $core.int get stage5EvCutoff => $_getIZ(8);
  @$pb.TagNumber(9)
  set stage5EvCutoff($core.int v) { $_setSignedInt32(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasStage5EvCutoff() => $_has(8);
  @$pb.TagNumber(9)
  void clearStage5EvCutoff() => clearField(9);

  @$pb.TagNumber(10)
  $core.int get stage6EvCutoff => $_getIZ(9);
  @$pb.TagNumber(10)
  set stage6EvCutoff($core.int v) { $_setSignedInt32(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasStage6EvCutoff() => $_has(9);
  @$pb.TagNumber(10)
  void clearStage6EvCutoff() => clearField(10);

  @$pb.TagNumber(11)
  $core.int get stage7EvCutoff => $_getIZ(10);
  @$pb.TagNumber(11)
  set stage7EvCutoff($core.int v) { $_setSignedInt32(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasStage7EvCutoff() => $_has(10);
  @$pb.TagNumber(11)
  void clearStage7EvCutoff() => clearField(11);

  @$pb.TagNumber(12)
  $core.int get stage8EvCutoff => $_getIZ(11);
  @$pb.TagNumber(12)
  set stage8EvCutoff($core.int v) { $_setSignedInt32(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasStage8EvCutoff() => $_has(11);
  @$pb.TagNumber(12)
  void clearStage8EvCutoff() => clearField(12);

  @$pb.TagNumber(13)
  $core.int get stage9EvCutoff => $_getIZ(12);
  @$pb.TagNumber(13)
  set stage9EvCutoff($core.int v) { $_setSignedInt32(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasStage9EvCutoff() => $_has(12);
  @$pb.TagNumber(13)
  void clearStage9EvCutoff() => clearField(13);

  @$pb.TagNumber(14)
  $core.int get stage10EvCutoff => $_getIZ(13);
  @$pb.TagNumber(14)
  set stage10EvCutoff($core.int v) { $_setSignedInt32(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasStage10EvCutoff() => $_has(13);
  @$pb.TagNumber(14)
  void clearStage10EvCutoff() => clearField(14);
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

class SkinInstance extends $pb.GeneratedMessage {
  factory SkinInstance({
    $core.String? skinId,
    $core.String? skinName,
    $core.String? userEmail,
    $core.String? figureName,
  }) {
    final $result = create();
    if (skinId != null) {
      $result.skinId = skinId;
    }
    if (skinName != null) {
      $result.skinName = skinName;
    }
    if (userEmail != null) {
      $result.userEmail = userEmail;
    }
    if (figureName != null) {
      $result.figureName = figureName;
    }
    return $result;
  }
  SkinInstance._() : super();
  factory SkinInstance.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SkinInstance.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SkinInstance', package: const $pb.PackageName(_omitMessageNames ? '' : 'routes'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'SkinId', protoName: 'Skin_Id')
    ..aOS(2, _omitFieldNames ? '' : 'SkinName', protoName: 'Skin_Name')
    ..aOS(3, _omitFieldNames ? '' : 'UserEmail', protoName: 'User_Email')
    ..aOS(4, _omitFieldNames ? '' : 'FigureName', protoName: 'Figure_Name')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SkinInstance clone() => SkinInstance()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SkinInstance copyWith(void Function(SkinInstance) updates) => super.copyWith((message) => updates(message as SkinInstance)) as SkinInstance;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SkinInstance create() => SkinInstance._();
  SkinInstance createEmptyInstance() => create();
  static $pb.PbList<SkinInstance> createRepeated() => $pb.PbList<SkinInstance>();
  @$core.pragma('dart2js:noInline')
  static SkinInstance getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SkinInstance>(create);
  static SkinInstance? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get skinId => $_getSZ(0);
  @$pb.TagNumber(1)
  set skinId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSkinId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSkinId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get skinName => $_getSZ(1);
  @$pb.TagNumber(2)
  set skinName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSkinName() => $_has(1);
  @$pb.TagNumber(2)
  void clearSkinName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get userEmail => $_getSZ(2);
  @$pb.TagNumber(3)
  set userEmail($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasUserEmail() => $_has(2);
  @$pb.TagNumber(3)
  void clearUserEmail() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get figureName => $_getSZ(3);
  @$pb.TagNumber(4)
  set figureName($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasFigureName() => $_has(3);
  @$pb.TagNumber(4)
  void clearFigureName() => clearField(4);
}

class MultiSkinInstance extends $pb.GeneratedMessage {
  factory MultiSkinInstance({
    $core.Iterable<SkinInstance>? skinInstances,
  }) {
    final $result = create();
    if (skinInstances != null) {
      $result.skinInstances.addAll(skinInstances);
    }
    return $result;
  }
  MultiSkinInstance._() : super();
  factory MultiSkinInstance.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MultiSkinInstance.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MultiSkinInstance', package: const $pb.PackageName(_omitMessageNames ? '' : 'routes'), createEmptyInstance: create)
    ..pc<SkinInstance>(1, _omitFieldNames ? '' : 'skinInstances', $pb.PbFieldType.PM, protoName: 'skinInstances', subBuilder: SkinInstance.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MultiSkinInstance clone() => MultiSkinInstance()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MultiSkinInstance copyWith(void Function(MultiSkinInstance) updates) => super.copyWith((message) => updates(message as MultiSkinInstance)) as MultiSkinInstance;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MultiSkinInstance create() => MultiSkinInstance._();
  MultiSkinInstance createEmptyInstance() => create();
  static $pb.PbList<MultiSkinInstance> createRepeated() => $pb.PbList<MultiSkinInstance>();
  @$core.pragma('dart2js:noInline')
  static MultiSkinInstance getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MultiSkinInstance>(create);
  static MultiSkinInstance? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<SkinInstance> get skinInstances => $_getList(0);
}

class Skin extends $pb.GeneratedMessage {
  factory Skin({
    $core.String? skinName,
    $core.String? figureName,
    $core.int? price,
  }) {
    final $result = create();
    if (skinName != null) {
      $result.skinName = skinName;
    }
    if (figureName != null) {
      $result.figureName = figureName;
    }
    if (price != null) {
      $result.price = price;
    }
    return $result;
  }
  Skin._() : super();
  factory Skin.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Skin.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Skin', package: const $pb.PackageName(_omitMessageNames ? '' : 'routes'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'SkinName', protoName: 'Skin_Name')
    ..aOS(2, _omitFieldNames ? '' : 'FigureName', protoName: 'Figure_Name')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'Price', $pb.PbFieldType.O3, protoName: 'Price')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Skin clone() => Skin()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Skin copyWith(void Function(Skin) updates) => super.copyWith((message) => updates(message as Skin)) as Skin;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Skin create() => Skin._();
  Skin createEmptyInstance() => create();
  static $pb.PbList<Skin> createRepeated() => $pb.PbList<Skin>();
  @$core.pragma('dart2js:noInline')
  static Skin getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Skin>(create);
  static Skin? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get skinName => $_getSZ(0);
  @$pb.TagNumber(1)
  set skinName($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSkinName() => $_has(0);
  @$pb.TagNumber(1)
  void clearSkinName() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get figureName => $_getSZ(1);
  @$pb.TagNumber(2)
  set figureName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasFigureName() => $_has(1);
  @$pb.TagNumber(2)
  void clearFigureName() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get price => $_getIZ(2);
  @$pb.TagNumber(3)
  set price($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPrice() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrice() => clearField(3);
}

class MultiSkin extends $pb.GeneratedMessage {
  factory MultiSkin({
    $core.Iterable<Skin>? skins,
  }) {
    final $result = create();
    if (skins != null) {
      $result.skins.addAll(skins);
    }
    return $result;
  }
  MultiSkin._() : super();
  factory MultiSkin.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MultiSkin.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MultiSkin', package: const $pb.PackageName(_omitMessageNames ? '' : 'routes'), createEmptyInstance: create)
    ..pc<Skin>(1, _omitFieldNames ? '' : 'skins', $pb.PbFieldType.PM, subBuilder: Skin.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MultiSkin clone() => MultiSkin()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MultiSkin copyWith(void Function(MultiSkin) updates) => super.copyWith((message) => updates(message as MultiSkin)) as MultiSkin;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MultiSkin create() => MultiSkin._();
  MultiSkin createEmptyInstance() => create();
  static $pb.PbList<MultiSkin> createRepeated() => $pb.PbList<MultiSkin>();
  @$core.pragma('dart2js:noInline')
  static MultiSkin getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MultiSkin>(create);
  static MultiSkin? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Skin> get skins => $_getList(0);
}

class SurveyResponse extends $pb.GeneratedMessage {
  factory SurveyResponse({
    $core.String? email,
    $core.String? question,
    $core.String? answer,
    $core.String? date,
  }) {
    final $result = create();
    if (email != null) {
      $result.email = email;
    }
    if (question != null) {
      $result.question = question;
    }
    if (answer != null) {
      $result.answer = answer;
    }
    if (date != null) {
      $result.date = date;
    }
    return $result;
  }
  SurveyResponse._() : super();
  factory SurveyResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SurveyResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SurveyResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'routes'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'Email', protoName: 'Email')
    ..aOS(2, _omitFieldNames ? '' : 'Question', protoName: 'Question')
    ..aOS(3, _omitFieldNames ? '' : 'Answer', protoName: 'Answer')
    ..aOS(4, _omitFieldNames ? '' : 'Date', protoName: 'Date')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SurveyResponse clone() => SurveyResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SurveyResponse copyWith(void Function(SurveyResponse) updates) => super.copyWith((message) => updates(message as SurveyResponse)) as SurveyResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SurveyResponse create() => SurveyResponse._();
  SurveyResponse createEmptyInstance() => create();
  static $pb.PbList<SurveyResponse> createRepeated() => $pb.PbList<SurveyResponse>();
  @$core.pragma('dart2js:noInline')
  static SurveyResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SurveyResponse>(create);
  static SurveyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get email => $_getSZ(0);
  @$pb.TagNumber(1)
  set email($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasEmail() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmail() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get question => $_getSZ(1);
  @$pb.TagNumber(2)
  set question($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasQuestion() => $_has(1);
  @$pb.TagNumber(2)
  void clearQuestion() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get answer => $_getSZ(2);
  @$pb.TagNumber(3)
  set answer($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAnswer() => $_has(2);
  @$pb.TagNumber(3)
  void clearAnswer() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get date => $_getSZ(3);
  @$pb.TagNumber(4)
  set date($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasDate() => $_has(3);
  @$pb.TagNumber(4)
  void clearDate() => clearField(4);
}

class MultiSurveyResponse extends $pb.GeneratedMessage {
  factory MultiSurveyResponse({
    $core.Iterable<SurveyResponse>? surveyResponses,
  }) {
    final $result = create();
    if (surveyResponses != null) {
      $result.surveyResponses.addAll(surveyResponses);
    }
    return $result;
  }
  MultiSurveyResponse._() : super();
  factory MultiSurveyResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MultiSurveyResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MultiSurveyResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'routes'), createEmptyInstance: create)
    ..pc<SurveyResponse>(1, _omitFieldNames ? '' : 'surveyResponses', $pb.PbFieldType.PM, protoName: 'surveyResponses', subBuilder: SurveyResponse.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MultiSurveyResponse clone() => MultiSurveyResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MultiSurveyResponse copyWith(void Function(MultiSurveyResponse) updates) => super.copyWith((message) => updates(message as MultiSurveyResponse)) as MultiSurveyResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MultiSurveyResponse create() => MultiSurveyResponse._();
  MultiSurveyResponse createEmptyInstance() => create();
  static $pb.PbList<MultiSurveyResponse> createRepeated() => $pb.PbList<MultiSurveyResponse>();
  @$core.pragma('dart2js:noInline')
  static MultiSurveyResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MultiSurveyResponse>(create);
  static MultiSurveyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<SurveyResponse> get surveyResponses => $_getList(0);
}

class OfflineDateTime extends $pb.GeneratedMessage {
  factory OfflineDateTime({
    $core.String? email,
    $core.String? currency,
  }) {
    final $result = create();
    if (email != null) {
      $result.email = email;
    }
    if (currency != null) {
      $result.currency = currency;
    }
    return $result;
  }
  OfflineDateTime._() : super();
  factory OfflineDateTime.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OfflineDateTime.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'OfflineDateTime', package: const $pb.PackageName(_omitMessageNames ? '' : 'routes'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'Email', protoName: 'Email')
    ..aOS(2, _omitFieldNames ? '' : 'Currency', protoName: 'Currency')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OfflineDateTime clone() => OfflineDateTime()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OfflineDateTime copyWith(void Function(OfflineDateTime) updates) => super.copyWith((message) => updates(message as OfflineDateTime)) as OfflineDateTime;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OfflineDateTime create() => OfflineDateTime._();
  OfflineDateTime createEmptyInstance() => create();
  static $pb.PbList<OfflineDateTime> createRepeated() => $pb.PbList<OfflineDateTime>();
  @$core.pragma('dart2js:noInline')
  static OfflineDateTime getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OfflineDateTime>(create);
  static OfflineDateTime? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get email => $_getSZ(0);
  @$pb.TagNumber(1)
  set email($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasEmail() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmail() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get currency => $_getSZ(1);
  @$pb.TagNumber(2)
  set currency($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCurrency() => $_has(1);
  @$pb.TagNumber(2)
  void clearCurrency() => clearField(2);
}

class UpdateEmailRequest extends $pb.GeneratedMessage {
  factory UpdateEmailRequest({
    $core.String? oldEmail,
    $core.String? newEmail,
  }) {
    final $result = create();
    if (oldEmail != null) {
      $result.oldEmail = oldEmail;
    }
    if (newEmail != null) {
      $result.newEmail = newEmail;
    }
    return $result;
  }
  UpdateEmailRequest._() : super();
  factory UpdateEmailRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateEmailRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdateEmailRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'routes'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'oldEmail')
    ..aOS(2, _omitFieldNames ? '' : 'newEmail')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateEmailRequest clone() => UpdateEmailRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateEmailRequest copyWith(void Function(UpdateEmailRequest) updates) => super.copyWith((message) => updates(message as UpdateEmailRequest)) as UpdateEmailRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateEmailRequest create() => UpdateEmailRequest._();
  UpdateEmailRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateEmailRequest> createRepeated() => $pb.PbList<UpdateEmailRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateEmailRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateEmailRequest>(create);
  static UpdateEmailRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get oldEmail => $_getSZ(0);
  @$pb.TagNumber(1)
  set oldEmail($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasOldEmail() => $_has(0);
  @$pb.TagNumber(1)
  void clearOldEmail() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get newEmail => $_getSZ(1);
  @$pb.TagNumber(2)
  set newEmail($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasNewEmail() => $_has(1);
  @$pb.TagNumber(2)
  void clearNewEmail() => clearField(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
