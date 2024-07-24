//
//  Generated code. Do not modify.
//  source: routes.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'google/protobuf/empty.pb.dart' as $1;
import 'routes.pb.dart' as $0;

export 'routes.pb.dart';

@$pb.GrpcServiceName('routes.Routes')
class RoutesClient extends $grpc.Client {
  static final _$getUser = $grpc.ClientMethod<$0.User, $0.User>(
      '/routes.Routes/GetUser',
      ($0.User value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.User.fromBuffer(value));
  static final _$createUser = $grpc.ClientMethod<$0.User, $0.User>(
      '/routes.Routes/CreateUser',
      ($0.User value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.User.fromBuffer(value));
  static final _$updateUser = $grpc.ClientMethod<$0.User, $0.User>(
      '/routes.Routes/UpdateUser',
      ($0.User value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.User.fromBuffer(value));
  static final _$deleteUser = $grpc.ClientMethod<$0.User, $0.User>(
      '/routes.Routes/DeleteUser',
      ($0.User value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.User.fromBuffer(value));
  static final _$getWorkouts = $grpc.ClientMethod<$0.User, $0.MultiWorkout>(
      '/routes.Routes/GetWorkouts',
      ($0.User value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.MultiWorkout.fromBuffer(value));
  static final _$getWorkout = $grpc.ClientMethod<$0.Workout, $0.Workout>(
      '/routes.Routes/GetWorkout',
      ($0.Workout value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Workout.fromBuffer(value));
  static final _$createWorkout = $grpc.ClientMethod<$0.Workout, $0.Workout>(
      '/routes.Routes/CreateWorkout',
      ($0.Workout value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Workout.fromBuffer(value));
  static final _$updateWorkout = $grpc.ClientMethod<$0.Workout, $0.Workout>(
      '/routes.Routes/UpdateWorkout',
      ($0.Workout value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Workout.fromBuffer(value));
  static final _$deleteWorkout = $grpc.ClientMethod<$0.Workout, $0.Workout>(
      '/routes.Routes/DeleteWorkout',
      ($0.Workout value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Workout.fromBuffer(value));
  static final _$getFigureInstance = $grpc.ClientMethod<$0.FigureInstance, $0.FigureInstance>(
      '/routes.Routes/GetFigureInstance',
      ($0.FigureInstance value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.FigureInstance.fromBuffer(value));
  static final _$updateFigureInstance = $grpc.ClientMethod<$0.FigureInstance, $0.FigureInstance>(
      '/routes.Routes/UpdateFigureInstance',
      ($0.FigureInstance value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.FigureInstance.fromBuffer(value));
  static final _$createFigureInstance = $grpc.ClientMethod<$0.FigureInstance, $0.FigureInstance>(
      '/routes.Routes/CreateFigureInstance',
      ($0.FigureInstance value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.FigureInstance.fromBuffer(value));
  static final _$deleteFigureInstance = $grpc.ClientMethod<$0.FigureInstance, $0.FigureInstance>(
      '/routes.Routes/DeleteFigureInstance',
      ($0.FigureInstance value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.FigureInstance.fromBuffer(value));
  static final _$getFigureInstances = $grpc.ClientMethod<$0.User, $0.MultiFigureInstance>(
      '/routes.Routes/GetFigureInstances',
      ($0.User value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.MultiFigureInstance.fromBuffer(value));
  static final _$getFigure = $grpc.ClientMethod<$0.Figure, $0.Figure>(
      '/routes.Routes/GetFigure',
      ($0.Figure value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Figure.fromBuffer(value));
  static final _$updateFigure = $grpc.ClientMethod<$0.Figure, $0.Figure>(
      '/routes.Routes/UpdateFigure',
      ($0.Figure value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Figure.fromBuffer(value));
  static final _$createFigure = $grpc.ClientMethod<$0.Figure, $0.Figure>(
      '/routes.Routes/CreateFigure',
      ($0.Figure value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Figure.fromBuffer(value));
  static final _$deleteFigure = $grpc.ClientMethod<$0.Figure, $0.Figure>(
      '/routes.Routes/DeleteFigure',
      ($0.Figure value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Figure.fromBuffer(value));
  static final _$getFigures = $grpc.ClientMethod<$1.Empty, $0.MultiFigure>(
      '/routes.Routes/GetFigures',
      ($1.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.MultiFigure.fromBuffer(value));
  static final _$getSkinInstance = $grpc.ClientMethod<$0.SkinInstance, $0.SkinInstance>(
      '/routes.Routes/GetSkinInstance',
      ($0.SkinInstance value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.SkinInstance.fromBuffer(value));
  static final _$updateSkinInstance = $grpc.ClientMethod<$0.SkinInstance, $0.SkinInstance>(
      '/routes.Routes/UpdateSkinInstance',
      ($0.SkinInstance value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.SkinInstance.fromBuffer(value));
  static final _$createSkinInstance = $grpc.ClientMethod<$0.SkinInstance, $0.SkinInstance>(
      '/routes.Routes/CreateSkinInstance',
      ($0.SkinInstance value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.SkinInstance.fromBuffer(value));
  static final _$deleteSkinInstance = $grpc.ClientMethod<$0.SkinInstance, $0.SkinInstance>(
      '/routes.Routes/DeleteSkinInstance',
      ($0.SkinInstance value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.SkinInstance.fromBuffer(value));
  static final _$getSkinInstances = $grpc.ClientMethod<$0.User, $0.MultiSkinInstance>(
      '/routes.Routes/GetSkinInstances',
      ($0.User value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.MultiSkinInstance.fromBuffer(value));
  static final _$getSkin = $grpc.ClientMethod<$0.Skin, $0.Skin>(
      '/routes.Routes/GetSkin',
      ($0.Skin value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Skin.fromBuffer(value));
  static final _$updateSkin = $grpc.ClientMethod<$0.Skin, $0.Skin>(
      '/routes.Routes/UpdateSkin',
      ($0.Skin value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Skin.fromBuffer(value));
  static final _$createSkin = $grpc.ClientMethod<$0.Skin, $0.Skin>(
      '/routes.Routes/CreateSkin',
      ($0.Skin value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Skin.fromBuffer(value));
  static final _$deleteSkin = $grpc.ClientMethod<$0.Skin, $0.Skin>(
      '/routes.Routes/DeleteSkin',
      ($0.Skin value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Skin.fromBuffer(value));
  static final _$getSkins = $grpc.ClientMethod<$1.Empty, $0.MultiSkin>(
      '/routes.Routes/GetSkins',
      ($1.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.MultiSkin.fromBuffer(value));
  static final _$getSurveyResponse = $grpc.ClientMethod<$0.SurveyResponse, $0.SurveyResponse>(
      '/routes.Routes/GetSurveyResponse',
      ($0.SurveyResponse value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.SurveyResponse.fromBuffer(value));
  static final _$updateSurveyResponse = $grpc.ClientMethod<$0.SurveyResponse, $0.SurveyResponse>(
      '/routes.Routes/UpdateSurveyResponse',
      ($0.SurveyResponse value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.SurveyResponse.fromBuffer(value));
  static final _$createSurveyResponse = $grpc.ClientMethod<$0.SurveyResponse, $0.SurveyResponse>(
      '/routes.Routes/CreateSurveyResponse',
      ($0.SurveyResponse value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.SurveyResponse.fromBuffer(value));
  static final _$deleteSurveyResponse = $grpc.ClientMethod<$0.SurveyResponse, $0.SurveyResponse>(
      '/routes.Routes/DeleteSurveyResponse',
      ($0.SurveyResponse value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.SurveyResponse.fromBuffer(value));
  static final _$getSurveyResponses = $grpc.ClientMethod<$0.User, $0.MultiSurveyResponse>(
      '/routes.Routes/GetSurveyResponses',
      ($0.User value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.MultiSurveyResponse.fromBuffer(value));
  static final _$createSurveyResponseMulti = $grpc.ClientMethod<$0.MultiSurveyResponse, $0.MultiSurveyResponse>(
      '/routes.Routes/CreateSurveyResponseMulti',
      ($0.MultiSurveyResponse value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.MultiSurveyResponse.fromBuffer(value));
  static final _$getOfflineDateTime = $grpc.ClientMethod<$0.OfflineDateTime, $0.OfflineDateTime>(
      '/routes.Routes/GetOfflineDateTime',
      ($0.OfflineDateTime value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.OfflineDateTime.fromBuffer(value));
  static final _$updateOfflineDateTime = $grpc.ClientMethod<$0.OfflineDateTime, $0.OfflineDateTime>(
      '/routes.Routes/UpdateOfflineDateTime',
      ($0.OfflineDateTime value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.OfflineDateTime.fromBuffer(value));
  static final _$deleteOfflineDateTime = $grpc.ClientMethod<$0.OfflineDateTime, $0.OfflineDateTime>(
      '/routes.Routes/DeleteOfflineDateTime',
      ($0.OfflineDateTime value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.OfflineDateTime.fromBuffer(value));
  static final _$figureDecay = $grpc.ClientMethod<$0.FigureInstance, $0.GenericStringResponse>(
      '/routes.Routes/FigureDecay',
      ($0.FigureInstance value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.GenericStringResponse.fromBuffer(value));
  static final _$userWeeklyReset = $grpc.ClientMethod<$0.User, $0.GenericStringResponse>(
      '/routes.Routes/UserWeeklyReset',
      ($0.User value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.GenericStringResponse.fromBuffer(value));

  RoutesClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.User> getUser($0.User request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getUser, request, options: options);
  }

  $grpc.ResponseFuture<$0.User> createUser($0.User request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createUser, request, options: options);
  }

  $grpc.ResponseFuture<$0.User> updateUser($0.User request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateUser, request, options: options);
  }

  $grpc.ResponseFuture<$0.User> deleteUser($0.User request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$deleteUser, request, options: options);
  }

  $grpc.ResponseFuture<$0.MultiWorkout> getWorkouts($0.User request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getWorkouts, request, options: options);
  }

  $grpc.ResponseFuture<$0.Workout> getWorkout($0.Workout request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getWorkout, request, options: options);
  }

  $grpc.ResponseFuture<$0.Workout> createWorkout($0.Workout request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createWorkout, request, options: options);
  }

  $grpc.ResponseFuture<$0.Workout> updateWorkout($0.Workout request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateWorkout, request, options: options);
  }

  $grpc.ResponseFuture<$0.Workout> deleteWorkout($0.Workout request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$deleteWorkout, request, options: options);
  }

  $grpc.ResponseFuture<$0.FigureInstance> getFigureInstance($0.FigureInstance request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getFigureInstance, request, options: options);
  }

  $grpc.ResponseFuture<$0.FigureInstance> updateFigureInstance($0.FigureInstance request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateFigureInstance, request, options: options);
  }

  $grpc.ResponseFuture<$0.FigureInstance> createFigureInstance($0.FigureInstance request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createFigureInstance, request, options: options);
  }

  $grpc.ResponseFuture<$0.FigureInstance> deleteFigureInstance($0.FigureInstance request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$deleteFigureInstance, request, options: options);
  }

  $grpc.ResponseFuture<$0.MultiFigureInstance> getFigureInstances($0.User request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getFigureInstances, request, options: options);
  }

  $grpc.ResponseFuture<$0.Figure> getFigure($0.Figure request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getFigure, request, options: options);
  }

  $grpc.ResponseFuture<$0.Figure> updateFigure($0.Figure request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateFigure, request, options: options);
  }

  $grpc.ResponseFuture<$0.Figure> createFigure($0.Figure request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createFigure, request, options: options);
  }

  $grpc.ResponseFuture<$0.Figure> deleteFigure($0.Figure request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$deleteFigure, request, options: options);
  }

  $grpc.ResponseFuture<$0.MultiFigure> getFigures($1.Empty request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getFigures, request, options: options);
  }

  $grpc.ResponseFuture<$0.SkinInstance> getSkinInstance($0.SkinInstance request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getSkinInstance, request, options: options);
  }

  $grpc.ResponseFuture<$0.SkinInstance> updateSkinInstance($0.SkinInstance request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateSkinInstance, request, options: options);
  }

  $grpc.ResponseFuture<$0.SkinInstance> createSkinInstance($0.SkinInstance request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createSkinInstance, request, options: options);
  }

  $grpc.ResponseFuture<$0.SkinInstance> deleteSkinInstance($0.SkinInstance request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$deleteSkinInstance, request, options: options);
  }

  $grpc.ResponseFuture<$0.MultiSkinInstance> getSkinInstances($0.User request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getSkinInstances, request, options: options);
  }

  $grpc.ResponseFuture<$0.Skin> getSkin($0.Skin request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getSkin, request, options: options);
  }

  $grpc.ResponseFuture<$0.Skin> updateSkin($0.Skin request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateSkin, request, options: options);
  }

  $grpc.ResponseFuture<$0.Skin> createSkin($0.Skin request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createSkin, request, options: options);
  }

  $grpc.ResponseFuture<$0.Skin> deleteSkin($0.Skin request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$deleteSkin, request, options: options);
  }

  $grpc.ResponseFuture<$0.MultiSkin> getSkins($1.Empty request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getSkins, request, options: options);
  }

  $grpc.ResponseFuture<$0.SurveyResponse> getSurveyResponse($0.SurveyResponse request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getSurveyResponse, request, options: options);
  }

  $grpc.ResponseFuture<$0.SurveyResponse> updateSurveyResponse($0.SurveyResponse request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateSurveyResponse, request, options: options);
  }

  $grpc.ResponseFuture<$0.SurveyResponse> createSurveyResponse($0.SurveyResponse request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createSurveyResponse, request, options: options);
  }

  $grpc.ResponseFuture<$0.SurveyResponse> deleteSurveyResponse($0.SurveyResponse request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$deleteSurveyResponse, request, options: options);
  }

  $grpc.ResponseFuture<$0.MultiSurveyResponse> getSurveyResponses($0.User request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getSurveyResponses, request, options: options);
  }

  $grpc.ResponseFuture<$0.MultiSurveyResponse> createSurveyResponseMulti($0.MultiSurveyResponse request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createSurveyResponseMulti, request, options: options);
  }

  $grpc.ResponseFuture<$0.OfflineDateTime> getOfflineDateTime($0.OfflineDateTime request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getOfflineDateTime, request, options: options);
  }

  $grpc.ResponseFuture<$0.OfflineDateTime> updateOfflineDateTime($0.OfflineDateTime request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateOfflineDateTime, request, options: options);
  }

  $grpc.ResponseFuture<$0.OfflineDateTime> deleteOfflineDateTime($0.OfflineDateTime request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$deleteOfflineDateTime, request, options: options);
  }

  $grpc.ResponseFuture<$0.GenericStringResponse> figureDecay($0.FigureInstance request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$figureDecay, request, options: options);
  }

  $grpc.ResponseFuture<$0.GenericStringResponse> userWeeklyReset($0.User request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$userWeeklyReset, request, options: options);
  }
}

@$pb.GrpcServiceName('routes.Routes')
abstract class RoutesServiceBase extends $grpc.Service {
  $core.String get $name => 'routes.Routes';

  RoutesServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.User, $0.User>(
        'GetUser',
        getUser_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.User.fromBuffer(value),
        ($0.User value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.User, $0.User>(
        'CreateUser',
        createUser_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.User.fromBuffer(value),
        ($0.User value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.User, $0.User>(
        'UpdateUser',
        updateUser_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.User.fromBuffer(value),
        ($0.User value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.User, $0.User>(
        'DeleteUser',
        deleteUser_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.User.fromBuffer(value),
        ($0.User value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.User, $0.MultiWorkout>(
        'GetWorkouts',
        getWorkouts_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.User.fromBuffer(value),
        ($0.MultiWorkout value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Workout, $0.Workout>(
        'GetWorkout',
        getWorkout_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Workout.fromBuffer(value),
        ($0.Workout value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Workout, $0.Workout>(
        'CreateWorkout',
        createWorkout_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Workout.fromBuffer(value),
        ($0.Workout value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Workout, $0.Workout>(
        'UpdateWorkout',
        updateWorkout_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Workout.fromBuffer(value),
        ($0.Workout value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Workout, $0.Workout>(
        'DeleteWorkout',
        deleteWorkout_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Workout.fromBuffer(value),
        ($0.Workout value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.FigureInstance, $0.FigureInstance>(
        'GetFigureInstance',
        getFigureInstance_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.FigureInstance.fromBuffer(value),
        ($0.FigureInstance value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.FigureInstance, $0.FigureInstance>(
        'UpdateFigureInstance',
        updateFigureInstance_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.FigureInstance.fromBuffer(value),
        ($0.FigureInstance value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.FigureInstance, $0.FigureInstance>(
        'CreateFigureInstance',
        createFigureInstance_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.FigureInstance.fromBuffer(value),
        ($0.FigureInstance value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.FigureInstance, $0.FigureInstance>(
        'DeleteFigureInstance',
        deleteFigureInstance_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.FigureInstance.fromBuffer(value),
        ($0.FigureInstance value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.User, $0.MultiFigureInstance>(
        'GetFigureInstances',
        getFigureInstances_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.User.fromBuffer(value),
        ($0.MultiFigureInstance value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Figure, $0.Figure>(
        'GetFigure',
        getFigure_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Figure.fromBuffer(value),
        ($0.Figure value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Figure, $0.Figure>(
        'UpdateFigure',
        updateFigure_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Figure.fromBuffer(value),
        ($0.Figure value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Figure, $0.Figure>(
        'CreateFigure',
        createFigure_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Figure.fromBuffer(value),
        ($0.Figure value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Figure, $0.Figure>(
        'DeleteFigure',
        deleteFigure_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Figure.fromBuffer(value),
        ($0.Figure value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.Empty, $0.MultiFigure>(
        'GetFigures',
        getFigures_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.Empty.fromBuffer(value),
        ($0.MultiFigure value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SkinInstance, $0.SkinInstance>(
        'GetSkinInstance',
        getSkinInstance_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SkinInstance.fromBuffer(value),
        ($0.SkinInstance value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SkinInstance, $0.SkinInstance>(
        'UpdateSkinInstance',
        updateSkinInstance_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SkinInstance.fromBuffer(value),
        ($0.SkinInstance value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SkinInstance, $0.SkinInstance>(
        'CreateSkinInstance',
        createSkinInstance_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SkinInstance.fromBuffer(value),
        ($0.SkinInstance value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SkinInstance, $0.SkinInstance>(
        'DeleteSkinInstance',
        deleteSkinInstance_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SkinInstance.fromBuffer(value),
        ($0.SkinInstance value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.User, $0.MultiSkinInstance>(
        'GetSkinInstances',
        getSkinInstances_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.User.fromBuffer(value),
        ($0.MultiSkinInstance value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Skin, $0.Skin>(
        'GetSkin',
        getSkin_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Skin.fromBuffer(value),
        ($0.Skin value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Skin, $0.Skin>(
        'UpdateSkin',
        updateSkin_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Skin.fromBuffer(value),
        ($0.Skin value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Skin, $0.Skin>(
        'CreateSkin',
        createSkin_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Skin.fromBuffer(value),
        ($0.Skin value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Skin, $0.Skin>(
        'DeleteSkin',
        deleteSkin_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Skin.fromBuffer(value),
        ($0.Skin value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.Empty, $0.MultiSkin>(
        'GetSkins',
        getSkins_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.Empty.fromBuffer(value),
        ($0.MultiSkin value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SurveyResponse, $0.SurveyResponse>(
        'GetSurveyResponse',
        getSurveyResponse_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SurveyResponse.fromBuffer(value),
        ($0.SurveyResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SurveyResponse, $0.SurveyResponse>(
        'UpdateSurveyResponse',
        updateSurveyResponse_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SurveyResponse.fromBuffer(value),
        ($0.SurveyResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SurveyResponse, $0.SurveyResponse>(
        'CreateSurveyResponse',
        createSurveyResponse_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SurveyResponse.fromBuffer(value),
        ($0.SurveyResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SurveyResponse, $0.SurveyResponse>(
        'DeleteSurveyResponse',
        deleteSurveyResponse_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SurveyResponse.fromBuffer(value),
        ($0.SurveyResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.User, $0.MultiSurveyResponse>(
        'GetSurveyResponses',
        getSurveyResponses_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.User.fromBuffer(value),
        ($0.MultiSurveyResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.MultiSurveyResponse, $0.MultiSurveyResponse>(
        'CreateSurveyResponseMulti',
        createSurveyResponseMulti_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.MultiSurveyResponse.fromBuffer(value),
        ($0.MultiSurveyResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OfflineDateTime, $0.OfflineDateTime>(
        'GetOfflineDateTime',
        getOfflineDateTime_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.OfflineDateTime.fromBuffer(value),
        ($0.OfflineDateTime value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OfflineDateTime, $0.OfflineDateTime>(
        'UpdateOfflineDateTime',
        updateOfflineDateTime_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.OfflineDateTime.fromBuffer(value),
        ($0.OfflineDateTime value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OfflineDateTime, $0.OfflineDateTime>(
        'DeleteOfflineDateTime',
        deleteOfflineDateTime_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.OfflineDateTime.fromBuffer(value),
        ($0.OfflineDateTime value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.FigureInstance, $0.GenericStringResponse>(
        'FigureDecay',
        figureDecay_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.FigureInstance.fromBuffer(value),
        ($0.GenericStringResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.User, $0.GenericStringResponse>(
        'UserWeeklyReset',
        userWeeklyReset_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.User.fromBuffer(value),
        ($0.GenericStringResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.User> getUser_Pre($grpc.ServiceCall call, $async.Future<$0.User> request) async {
    return getUser(call, await request);
  }

  $async.Future<$0.User> createUser_Pre($grpc.ServiceCall call, $async.Future<$0.User> request) async {
    return createUser(call, await request);
  }

  $async.Future<$0.User> updateUser_Pre($grpc.ServiceCall call, $async.Future<$0.User> request) async {
    return updateUser(call, await request);
  }

  $async.Future<$0.User> deleteUser_Pre($grpc.ServiceCall call, $async.Future<$0.User> request) async {
    return deleteUser(call, await request);
  }

  $async.Future<$0.MultiWorkout> getWorkouts_Pre($grpc.ServiceCall call, $async.Future<$0.User> request) async {
    return getWorkouts(call, await request);
  }

  $async.Future<$0.Workout> getWorkout_Pre($grpc.ServiceCall call, $async.Future<$0.Workout> request) async {
    return getWorkout(call, await request);
  }

  $async.Future<$0.Workout> createWorkout_Pre($grpc.ServiceCall call, $async.Future<$0.Workout> request) async {
    return createWorkout(call, await request);
  }

  $async.Future<$0.Workout> updateWorkout_Pre($grpc.ServiceCall call, $async.Future<$0.Workout> request) async {
    return updateWorkout(call, await request);
  }

  $async.Future<$0.Workout> deleteWorkout_Pre($grpc.ServiceCall call, $async.Future<$0.Workout> request) async {
    return deleteWorkout(call, await request);
  }

  $async.Future<$0.FigureInstance> getFigureInstance_Pre($grpc.ServiceCall call, $async.Future<$0.FigureInstance> request) async {
    return getFigureInstance(call, await request);
  }

  $async.Future<$0.FigureInstance> updateFigureInstance_Pre($grpc.ServiceCall call, $async.Future<$0.FigureInstance> request) async {
    return updateFigureInstance(call, await request);
  }

  $async.Future<$0.FigureInstance> createFigureInstance_Pre($grpc.ServiceCall call, $async.Future<$0.FigureInstance> request) async {
    return createFigureInstance(call, await request);
  }

  $async.Future<$0.FigureInstance> deleteFigureInstance_Pre($grpc.ServiceCall call, $async.Future<$0.FigureInstance> request) async {
    return deleteFigureInstance(call, await request);
  }

  $async.Future<$0.MultiFigureInstance> getFigureInstances_Pre($grpc.ServiceCall call, $async.Future<$0.User> request) async {
    return getFigureInstances(call, await request);
  }

  $async.Future<$0.Figure> getFigure_Pre($grpc.ServiceCall call, $async.Future<$0.Figure> request) async {
    return getFigure(call, await request);
  }

  $async.Future<$0.Figure> updateFigure_Pre($grpc.ServiceCall call, $async.Future<$0.Figure> request) async {
    return updateFigure(call, await request);
  }

  $async.Future<$0.Figure> createFigure_Pre($grpc.ServiceCall call, $async.Future<$0.Figure> request) async {
    return createFigure(call, await request);
  }

  $async.Future<$0.Figure> deleteFigure_Pre($grpc.ServiceCall call, $async.Future<$0.Figure> request) async {
    return deleteFigure(call, await request);
  }

  $async.Future<$0.MultiFigure> getFigures_Pre($grpc.ServiceCall call, $async.Future<$1.Empty> request) async {
    return getFigures(call, await request);
  }

  $async.Future<$0.SkinInstance> getSkinInstance_Pre($grpc.ServiceCall call, $async.Future<$0.SkinInstance> request) async {
    return getSkinInstance(call, await request);
  }

  $async.Future<$0.SkinInstance> updateSkinInstance_Pre($grpc.ServiceCall call, $async.Future<$0.SkinInstance> request) async {
    return updateSkinInstance(call, await request);
  }

  $async.Future<$0.SkinInstance> createSkinInstance_Pre($grpc.ServiceCall call, $async.Future<$0.SkinInstance> request) async {
    return createSkinInstance(call, await request);
  }

  $async.Future<$0.SkinInstance> deleteSkinInstance_Pre($grpc.ServiceCall call, $async.Future<$0.SkinInstance> request) async {
    return deleteSkinInstance(call, await request);
  }

  $async.Future<$0.MultiSkinInstance> getSkinInstances_Pre($grpc.ServiceCall call, $async.Future<$0.User> request) async {
    return getSkinInstances(call, await request);
  }

  $async.Future<$0.Skin> getSkin_Pre($grpc.ServiceCall call, $async.Future<$0.Skin> request) async {
    return getSkin(call, await request);
  }

  $async.Future<$0.Skin> updateSkin_Pre($grpc.ServiceCall call, $async.Future<$0.Skin> request) async {
    return updateSkin(call, await request);
  }

  $async.Future<$0.Skin> createSkin_Pre($grpc.ServiceCall call, $async.Future<$0.Skin> request) async {
    return createSkin(call, await request);
  }

  $async.Future<$0.Skin> deleteSkin_Pre($grpc.ServiceCall call, $async.Future<$0.Skin> request) async {
    return deleteSkin(call, await request);
  }

  $async.Future<$0.MultiSkin> getSkins_Pre($grpc.ServiceCall call, $async.Future<$1.Empty> request) async {
    return getSkins(call, await request);
  }

  $async.Future<$0.SurveyResponse> getSurveyResponse_Pre($grpc.ServiceCall call, $async.Future<$0.SurveyResponse> request) async {
    return getSurveyResponse(call, await request);
  }

  $async.Future<$0.SurveyResponse> updateSurveyResponse_Pre($grpc.ServiceCall call, $async.Future<$0.SurveyResponse> request) async {
    return updateSurveyResponse(call, await request);
  }

  $async.Future<$0.SurveyResponse> createSurveyResponse_Pre($grpc.ServiceCall call, $async.Future<$0.SurveyResponse> request) async {
    return createSurveyResponse(call, await request);
  }

  $async.Future<$0.SurveyResponse> deleteSurveyResponse_Pre($grpc.ServiceCall call, $async.Future<$0.SurveyResponse> request) async {
    return deleteSurveyResponse(call, await request);
  }

  $async.Future<$0.MultiSurveyResponse> getSurveyResponses_Pre($grpc.ServiceCall call, $async.Future<$0.User> request) async {
    return getSurveyResponses(call, await request);
  }

  $async.Future<$0.MultiSurveyResponse> createSurveyResponseMulti_Pre($grpc.ServiceCall call, $async.Future<$0.MultiSurveyResponse> request) async {
    return createSurveyResponseMulti(call, await request);
  }

  $async.Future<$0.OfflineDateTime> getOfflineDateTime_Pre($grpc.ServiceCall call, $async.Future<$0.OfflineDateTime> request) async {
    return getOfflineDateTime(call, await request);
  }

  $async.Future<$0.OfflineDateTime> updateOfflineDateTime_Pre($grpc.ServiceCall call, $async.Future<$0.OfflineDateTime> request) async {
    return updateOfflineDateTime(call, await request);
  }

  $async.Future<$0.OfflineDateTime> deleteOfflineDateTime_Pre($grpc.ServiceCall call, $async.Future<$0.OfflineDateTime> request) async {
    return deleteOfflineDateTime(call, await request);
  }

  $async.Future<$0.GenericStringResponse> figureDecay_Pre($grpc.ServiceCall call, $async.Future<$0.FigureInstance> request) async {
    return figureDecay(call, await request);
  }

  $async.Future<$0.GenericStringResponse> userWeeklyReset_Pre($grpc.ServiceCall call, $async.Future<$0.User> request) async {
    return userWeeklyReset(call, await request);
  }

  $async.Future<$0.User> getUser($grpc.ServiceCall call, $0.User request);
  $async.Future<$0.User> createUser($grpc.ServiceCall call, $0.User request);
  $async.Future<$0.User> updateUser($grpc.ServiceCall call, $0.User request);
  $async.Future<$0.User> deleteUser($grpc.ServiceCall call, $0.User request);
  $async.Future<$0.MultiWorkout> getWorkouts($grpc.ServiceCall call, $0.User request);
  $async.Future<$0.Workout> getWorkout($grpc.ServiceCall call, $0.Workout request);
  $async.Future<$0.Workout> createWorkout($grpc.ServiceCall call, $0.Workout request);
  $async.Future<$0.Workout> updateWorkout($grpc.ServiceCall call, $0.Workout request);
  $async.Future<$0.Workout> deleteWorkout($grpc.ServiceCall call, $0.Workout request);
  $async.Future<$0.FigureInstance> getFigureInstance($grpc.ServiceCall call, $0.FigureInstance request);
  $async.Future<$0.FigureInstance> updateFigureInstance($grpc.ServiceCall call, $0.FigureInstance request);
  $async.Future<$0.FigureInstance> createFigureInstance($grpc.ServiceCall call, $0.FigureInstance request);
  $async.Future<$0.FigureInstance> deleteFigureInstance($grpc.ServiceCall call, $0.FigureInstance request);
  $async.Future<$0.MultiFigureInstance> getFigureInstances($grpc.ServiceCall call, $0.User request);
  $async.Future<$0.Figure> getFigure($grpc.ServiceCall call, $0.Figure request);
  $async.Future<$0.Figure> updateFigure($grpc.ServiceCall call, $0.Figure request);
  $async.Future<$0.Figure> createFigure($grpc.ServiceCall call, $0.Figure request);
  $async.Future<$0.Figure> deleteFigure($grpc.ServiceCall call, $0.Figure request);
  $async.Future<$0.MultiFigure> getFigures($grpc.ServiceCall call, $1.Empty request);
  $async.Future<$0.SkinInstance> getSkinInstance($grpc.ServiceCall call, $0.SkinInstance request);
  $async.Future<$0.SkinInstance> updateSkinInstance($grpc.ServiceCall call, $0.SkinInstance request);
  $async.Future<$0.SkinInstance> createSkinInstance($grpc.ServiceCall call, $0.SkinInstance request);
  $async.Future<$0.SkinInstance> deleteSkinInstance($grpc.ServiceCall call, $0.SkinInstance request);
  $async.Future<$0.MultiSkinInstance> getSkinInstances($grpc.ServiceCall call, $0.User request);
  $async.Future<$0.Skin> getSkin($grpc.ServiceCall call, $0.Skin request);
  $async.Future<$0.Skin> updateSkin($grpc.ServiceCall call, $0.Skin request);
  $async.Future<$0.Skin> createSkin($grpc.ServiceCall call, $0.Skin request);
  $async.Future<$0.Skin> deleteSkin($grpc.ServiceCall call, $0.Skin request);
  $async.Future<$0.MultiSkin> getSkins($grpc.ServiceCall call, $1.Empty request);
  $async.Future<$0.SurveyResponse> getSurveyResponse($grpc.ServiceCall call, $0.SurveyResponse request);
  $async.Future<$0.SurveyResponse> updateSurveyResponse($grpc.ServiceCall call, $0.SurveyResponse request);
  $async.Future<$0.SurveyResponse> createSurveyResponse($grpc.ServiceCall call, $0.SurveyResponse request);
  $async.Future<$0.SurveyResponse> deleteSurveyResponse($grpc.ServiceCall call, $0.SurveyResponse request);
  $async.Future<$0.MultiSurveyResponse> getSurveyResponses($grpc.ServiceCall call, $0.User request);
  $async.Future<$0.MultiSurveyResponse> createSurveyResponseMulti($grpc.ServiceCall call, $0.MultiSurveyResponse request);
  $async.Future<$0.OfflineDateTime> getOfflineDateTime($grpc.ServiceCall call, $0.OfflineDateTime request);
  $async.Future<$0.OfflineDateTime> updateOfflineDateTime($grpc.ServiceCall call, $0.OfflineDateTime request);
  $async.Future<$0.OfflineDateTime> deleteOfflineDateTime($grpc.ServiceCall call, $0.OfflineDateTime request);
  $async.Future<$0.GenericStringResponse> figureDecay($grpc.ServiceCall call, $0.FigureInstance request);
  $async.Future<$0.GenericStringResponse> userWeeklyReset($grpc.ServiceCall call, $0.User request);
}
