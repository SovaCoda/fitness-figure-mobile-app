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
  static final _$updateUserEmail = $grpc.ClientMethod<$0.UpdateEmailRequest, $0.User>(
      '/routes.Routes/UpdateUserEmail',
      ($0.UpdateEmailRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.User.fromBuffer(value));
  static final _$resetUserStreak = $grpc.ClientMethod<$0.User, $0.User>(
      '/routes.Routes/ResetUserStreak',
      ($0.User value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.User.fromBuffer(value));
  static final _$resetUserWeekComplete = $grpc.ClientMethod<$0.User, $0.User>(
      '/routes.Routes/ResetUserWeekComplete',
      ($0.User value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.User.fromBuffer(value));
  static final _$getDailySnapshot = $grpc.ClientMethod<$0.DailySnapshot, $0.DailySnapshot>(
      '/routes.Routes/GetDailySnapshot',
      ($0.DailySnapshot value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.DailySnapshot.fromBuffer(value));
  static final _$updateDailySnapshot = $grpc.ClientMethod<$0.DailySnapshot, $0.DailySnapshot>(
      '/routes.Routes/UpdateDailySnapshot',
      ($0.DailySnapshot value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.DailySnapshot.fromBuffer(value));
  static final _$createDailySnapshot = $grpc.ClientMethod<$0.DailySnapshot, $0.DailySnapshot>(
      '/routes.Routes/CreateDailySnapshot',
      ($0.DailySnapshot value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.DailySnapshot.fromBuffer(value));
  static final _$deleteDailySnapshot = $grpc.ClientMethod<$0.DailySnapshot, $0.DailySnapshot>(
      '/routes.Routes/DeleteDailySnapshot',
      ($0.DailySnapshot value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.DailySnapshot.fromBuffer(value));
  static final _$getDailySnapshots = $grpc.ClientMethod<$0.DailySnapshot, $0.MultiDailySnapshot>(
      '/routes.Routes/GetDailySnapshots',
      ($0.DailySnapshot value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.MultiDailySnapshot.fromBuffer(value));
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
  static final _$createSubscriptionTimeStamp = $grpc.ClientMethod<$0.SubscriptionTimeStamp, $0.SubscriptionTimeStamp>(
      '/routes.Routes/CreateSubscriptionTimeStamp',
      ($0.SubscriptionTimeStamp value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.SubscriptionTimeStamp.fromBuffer(value));
  static final _$getSubscriptionTimeStamp = $grpc.ClientMethod<$0.SubscriptionTimeStamp, $0.SubscriptionTimeStamp>(
      '/routes.Routes/GetSubscriptionTimeStamp',
      ($0.SubscriptionTimeStamp value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.SubscriptionTimeStamp.fromBuffer(value));
  static final _$updateSubscriptionTimeStamp = $grpc.ClientMethod<$0.SubscriptionTimeStamp, $0.SubscriptionTimeStamp>(
      '/routes.Routes/UpdateSubscriptionTimeStamp',
      ($0.SubscriptionTimeStamp value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.SubscriptionTimeStamp.fromBuffer(value));
  static final _$deleteSubscriptionTimeStamp = $grpc.ClientMethod<$0.SubscriptionTimeStamp, $0.SubscriptionTimeStamp>(
      '/routes.Routes/DeleteSubscriptionTimeStamp',
      ($0.SubscriptionTimeStamp value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.SubscriptionTimeStamp.fromBuffer(value));
  static final _$figureDecay = $grpc.ClientMethod<$0.FigureInstance, $0.GenericStringResponse>(
      '/routes.Routes/FigureDecay',
      ($0.FigureInstance value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.GenericStringResponse.fromBuffer(value));
  static final _$userWeeklyReset = $grpc.ClientMethod<$0.User, $0.GenericStringResponse>(
      '/routes.Routes/UserWeeklyReset',
      ($0.User value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.GenericStringResponse.fromBuffer(value));
  static final _$sendFriendRequest = $grpc.ClientMethod<$0.FriendRequest, $0.Friend>(
      '/routes.Routes/SendFriendRequest',
      ($0.FriendRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Friend.fromBuffer(value));
  static final _$acceptFriendRequest = $grpc.ClientMethod<$0.FriendRequest, $0.Friend>(
      '/routes.Routes/AcceptFriendRequest',
      ($0.FriendRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Friend.fromBuffer(value));
  static final _$rejectFriendRequest = $grpc.ClientMethod<$0.FriendRequest, $0.Friend>(
      '/routes.Routes/RejectFriendRequest',
      ($0.FriendRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Friend.fromBuffer(value));
  static final _$removeFriend = $grpc.ClientMethod<$0.FriendRequest, $0.GenericStringResponse>(
      '/routes.Routes/RemoveFriend',
      ($0.FriendRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.GenericStringResponse.fromBuffer(value));
  static final _$getFriends = $grpc.ClientMethod<$0.FriendListRequest, $0.MultiFriends>(
      '/routes.Routes/GetFriends',
      ($0.FriendListRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.MultiFriends.fromBuffer(value));
  static final _$getPendingRequests = $grpc.ClientMethod<$0.FriendListRequest, $0.MultiFriends>(
      '/routes.Routes/GetPendingRequests',
      ($0.FriendListRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.MultiFriends.fromBuffer(value));
  static final _$checkFriendshipStatus = $grpc.ClientMethod<$0.FriendRequest, $0.Friend>(
      '/routes.Routes/CheckFriendshipStatus',
      ($0.FriendRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Friend.fromBuffer(value));
  static final _$getLeaderboard = $grpc.ClientMethod<$0.LeaderboardRequest, $0.LeaderboardResponse>(
      '/routes.Routes/GetLeaderboard',
      ($0.LeaderboardRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.LeaderboardResponse.fromBuffer(value));
  static final _$getUserStats = $grpc.ClientMethod<$0.User, $0.UserStats>(
      '/routes.Routes/GetUserStats',
      ($0.User value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.UserStats.fromBuffer(value));
  static final _$resetWeeklyStats = $grpc.ClientMethod<$1.Empty, $0.GenericStringResponse>(
      '/routes.Routes/ResetWeeklyStats',
      ($1.Empty value) => value.writeToBuffer(),
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

  $grpc.ResponseFuture<$0.User> updateUserEmail($0.UpdateEmailRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateUserEmail, request, options: options);
  }

  $grpc.ResponseFuture<$0.User> resetUserStreak($0.User request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$resetUserStreak, request, options: options);
  }

  $grpc.ResponseFuture<$0.User> resetUserWeekComplete($0.User request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$resetUserWeekComplete, request, options: options);
  }

  $grpc.ResponseFuture<$0.DailySnapshot> getDailySnapshot($0.DailySnapshot request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getDailySnapshot, request, options: options);
  }

  $grpc.ResponseFuture<$0.DailySnapshot> updateDailySnapshot($0.DailySnapshot request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateDailySnapshot, request, options: options);
  }

  $grpc.ResponseFuture<$0.DailySnapshot> createDailySnapshot($0.DailySnapshot request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createDailySnapshot, request, options: options);
  }

  $grpc.ResponseFuture<$0.DailySnapshot> deleteDailySnapshot($0.DailySnapshot request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$deleteDailySnapshot, request, options: options);
  }

  $grpc.ResponseFuture<$0.MultiDailySnapshot> getDailySnapshots($0.DailySnapshot request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getDailySnapshots, request, options: options);
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

  $grpc.ResponseFuture<$0.SubscriptionTimeStamp> createSubscriptionTimeStamp($0.SubscriptionTimeStamp request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createSubscriptionTimeStamp, request, options: options);
  }

  $grpc.ResponseFuture<$0.SubscriptionTimeStamp> getSubscriptionTimeStamp($0.SubscriptionTimeStamp request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getSubscriptionTimeStamp, request, options: options);
  }

  $grpc.ResponseFuture<$0.SubscriptionTimeStamp> updateSubscriptionTimeStamp($0.SubscriptionTimeStamp request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateSubscriptionTimeStamp, request, options: options);
  }

  $grpc.ResponseFuture<$0.SubscriptionTimeStamp> deleteSubscriptionTimeStamp($0.SubscriptionTimeStamp request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$deleteSubscriptionTimeStamp, request, options: options);
  }

  $grpc.ResponseFuture<$0.GenericStringResponse> figureDecay($0.FigureInstance request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$figureDecay, request, options: options);
  }

  $grpc.ResponseFuture<$0.GenericStringResponse> userWeeklyReset($0.User request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$userWeeklyReset, request, options: options);
  }

  $grpc.ResponseFuture<$0.Friend> sendFriendRequest($0.FriendRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$sendFriendRequest, request, options: options);
  }

  $grpc.ResponseFuture<$0.Friend> acceptFriendRequest($0.FriendRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$acceptFriendRequest, request, options: options);
  }

  $grpc.ResponseFuture<$0.Friend> rejectFriendRequest($0.FriendRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$rejectFriendRequest, request, options: options);
  }

  $grpc.ResponseFuture<$0.GenericStringResponse> removeFriend($0.FriendRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$removeFriend, request, options: options);
  }

  $grpc.ResponseFuture<$0.MultiFriends> getFriends($0.FriendListRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getFriends, request, options: options);
  }

  $grpc.ResponseFuture<$0.MultiFriends> getPendingRequests($0.FriendListRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getPendingRequests, request, options: options);
  }

  $grpc.ResponseFuture<$0.Friend> checkFriendshipStatus($0.FriendRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$checkFriendshipStatus, request, options: options);
  }

  $grpc.ResponseFuture<$0.LeaderboardResponse> getLeaderboard($0.LeaderboardRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getLeaderboard, request, options: options);
  }

  $grpc.ResponseFuture<$0.UserStats> getUserStats($0.User request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getUserStats, request, options: options);
  }

  $grpc.ResponseFuture<$0.GenericStringResponse> resetWeeklyStats($1.Empty request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$resetWeeklyStats, request, options: options);
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
    $addMethod($grpc.ServiceMethod<$0.UpdateEmailRequest, $0.User>(
        'UpdateUserEmail',
        updateUserEmail_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.UpdateEmailRequest.fromBuffer(value),
        ($0.User value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.User, $0.User>(
        'ResetUserStreak',
        resetUserStreak_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.User.fromBuffer(value),
        ($0.User value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.User, $0.User>(
        'ResetUserWeekComplete',
        resetUserWeekComplete_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.User.fromBuffer(value),
        ($0.User value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DailySnapshot, $0.DailySnapshot>(
        'GetDailySnapshot',
        getDailySnapshot_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.DailySnapshot.fromBuffer(value),
        ($0.DailySnapshot value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DailySnapshot, $0.DailySnapshot>(
        'UpdateDailySnapshot',
        updateDailySnapshot_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.DailySnapshot.fromBuffer(value),
        ($0.DailySnapshot value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DailySnapshot, $0.DailySnapshot>(
        'CreateDailySnapshot',
        createDailySnapshot_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.DailySnapshot.fromBuffer(value),
        ($0.DailySnapshot value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DailySnapshot, $0.DailySnapshot>(
        'DeleteDailySnapshot',
        deleteDailySnapshot_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.DailySnapshot.fromBuffer(value),
        ($0.DailySnapshot value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DailySnapshot, $0.MultiDailySnapshot>(
        'GetDailySnapshots',
        getDailySnapshots_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.DailySnapshot.fromBuffer(value),
        ($0.MultiDailySnapshot value) => value.writeToBuffer()));
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
    $addMethod($grpc.ServiceMethod<$0.SubscriptionTimeStamp, $0.SubscriptionTimeStamp>(
        'CreateSubscriptionTimeStamp',
        createSubscriptionTimeStamp_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SubscriptionTimeStamp.fromBuffer(value),
        ($0.SubscriptionTimeStamp value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SubscriptionTimeStamp, $0.SubscriptionTimeStamp>(
        'GetSubscriptionTimeStamp',
        getSubscriptionTimeStamp_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SubscriptionTimeStamp.fromBuffer(value),
        ($0.SubscriptionTimeStamp value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SubscriptionTimeStamp, $0.SubscriptionTimeStamp>(
        'UpdateSubscriptionTimeStamp',
        updateSubscriptionTimeStamp_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SubscriptionTimeStamp.fromBuffer(value),
        ($0.SubscriptionTimeStamp value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SubscriptionTimeStamp, $0.SubscriptionTimeStamp>(
        'DeleteSubscriptionTimeStamp',
        deleteSubscriptionTimeStamp_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SubscriptionTimeStamp.fromBuffer(value),
        ($0.SubscriptionTimeStamp value) => value.writeToBuffer()));
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
    $addMethod($grpc.ServiceMethod<$0.FriendRequest, $0.Friend>(
        'SendFriendRequest',
        sendFriendRequest_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.FriendRequest.fromBuffer(value),
        ($0.Friend value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.FriendRequest, $0.Friend>(
        'AcceptFriendRequest',
        acceptFriendRequest_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.FriendRequest.fromBuffer(value),
        ($0.Friend value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.FriendRequest, $0.Friend>(
        'RejectFriendRequest',
        rejectFriendRequest_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.FriendRequest.fromBuffer(value),
        ($0.Friend value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.FriendRequest, $0.GenericStringResponse>(
        'RemoveFriend',
        removeFriend_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.FriendRequest.fromBuffer(value),
        ($0.GenericStringResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.FriendListRequest, $0.MultiFriends>(
        'GetFriends',
        getFriends_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.FriendListRequest.fromBuffer(value),
        ($0.MultiFriends value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.FriendListRequest, $0.MultiFriends>(
        'GetPendingRequests',
        getPendingRequests_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.FriendListRequest.fromBuffer(value),
        ($0.MultiFriends value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.FriendRequest, $0.Friend>(
        'CheckFriendshipStatus',
        checkFriendshipStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.FriendRequest.fromBuffer(value),
        ($0.Friend value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.LeaderboardRequest, $0.LeaderboardResponse>(
        'GetLeaderboard',
        getLeaderboard_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.LeaderboardRequest.fromBuffer(value),
        ($0.LeaderboardResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.User, $0.UserStats>(
        'GetUserStats',
        getUserStats_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.User.fromBuffer(value),
        ($0.UserStats value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.Empty, $0.GenericStringResponse>(
        'ResetWeeklyStats',
        resetWeeklyStats_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.Empty.fromBuffer(value),
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

  $async.Future<$0.User> updateUserEmail_Pre($grpc.ServiceCall call, $async.Future<$0.UpdateEmailRequest> request) async {
    return updateUserEmail(call, await request);
  }

  $async.Future<$0.User> resetUserStreak_Pre($grpc.ServiceCall call, $async.Future<$0.User> request) async {
    return resetUserStreak(call, await request);
  }

  $async.Future<$0.User> resetUserWeekComplete_Pre($grpc.ServiceCall call, $async.Future<$0.User> request) async {
    return resetUserWeekComplete(call, await request);
  }

  $async.Future<$0.DailySnapshot> getDailySnapshot_Pre($grpc.ServiceCall call, $async.Future<$0.DailySnapshot> request) async {
    return getDailySnapshot(call, await request);
  }

  $async.Future<$0.DailySnapshot> updateDailySnapshot_Pre($grpc.ServiceCall call, $async.Future<$0.DailySnapshot> request) async {
    return updateDailySnapshot(call, await request);
  }

  $async.Future<$0.DailySnapshot> createDailySnapshot_Pre($grpc.ServiceCall call, $async.Future<$0.DailySnapshot> request) async {
    return createDailySnapshot(call, await request);
  }

  $async.Future<$0.DailySnapshot> deleteDailySnapshot_Pre($grpc.ServiceCall call, $async.Future<$0.DailySnapshot> request) async {
    return deleteDailySnapshot(call, await request);
  }

  $async.Future<$0.MultiDailySnapshot> getDailySnapshots_Pre($grpc.ServiceCall call, $async.Future<$0.DailySnapshot> request) async {
    return getDailySnapshots(call, await request);
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

  $async.Future<$0.SubscriptionTimeStamp> createSubscriptionTimeStamp_Pre($grpc.ServiceCall call, $async.Future<$0.SubscriptionTimeStamp> request) async {
    return createSubscriptionTimeStamp(call, await request);
  }

  $async.Future<$0.SubscriptionTimeStamp> getSubscriptionTimeStamp_Pre($grpc.ServiceCall call, $async.Future<$0.SubscriptionTimeStamp> request) async {
    return getSubscriptionTimeStamp(call, await request);
  }

  $async.Future<$0.SubscriptionTimeStamp> updateSubscriptionTimeStamp_Pre($grpc.ServiceCall call, $async.Future<$0.SubscriptionTimeStamp> request) async {
    return updateSubscriptionTimeStamp(call, await request);
  }

  $async.Future<$0.SubscriptionTimeStamp> deleteSubscriptionTimeStamp_Pre($grpc.ServiceCall call, $async.Future<$0.SubscriptionTimeStamp> request) async {
    return deleteSubscriptionTimeStamp(call, await request);
  }

  $async.Future<$0.GenericStringResponse> figureDecay_Pre($grpc.ServiceCall call, $async.Future<$0.FigureInstance> request) async {
    return figureDecay(call, await request);
  }

  $async.Future<$0.GenericStringResponse> userWeeklyReset_Pre($grpc.ServiceCall call, $async.Future<$0.User> request) async {
    return userWeeklyReset(call, await request);
  }

  $async.Future<$0.Friend> sendFriendRequest_Pre($grpc.ServiceCall call, $async.Future<$0.FriendRequest> request) async {
    return sendFriendRequest(call, await request);
  }

  $async.Future<$0.Friend> acceptFriendRequest_Pre($grpc.ServiceCall call, $async.Future<$0.FriendRequest> request) async {
    return acceptFriendRequest(call, await request);
  }

  $async.Future<$0.Friend> rejectFriendRequest_Pre($grpc.ServiceCall call, $async.Future<$0.FriendRequest> request) async {
    return rejectFriendRequest(call, await request);
  }

  $async.Future<$0.GenericStringResponse> removeFriend_Pre($grpc.ServiceCall call, $async.Future<$0.FriendRequest> request) async {
    return removeFriend(call, await request);
  }

  $async.Future<$0.MultiFriends> getFriends_Pre($grpc.ServiceCall call, $async.Future<$0.FriendListRequest> request) async {
    return getFriends(call, await request);
  }

  $async.Future<$0.MultiFriends> getPendingRequests_Pre($grpc.ServiceCall call, $async.Future<$0.FriendListRequest> request) async {
    return getPendingRequests(call, await request);
  }

  $async.Future<$0.Friend> checkFriendshipStatus_Pre($grpc.ServiceCall call, $async.Future<$0.FriendRequest> request) async {
    return checkFriendshipStatus(call, await request);
  }

  $async.Future<$0.LeaderboardResponse> getLeaderboard_Pre($grpc.ServiceCall call, $async.Future<$0.LeaderboardRequest> request) async {
    return getLeaderboard(call, await request);
  }

  $async.Future<$0.UserStats> getUserStats_Pre($grpc.ServiceCall call, $async.Future<$0.User> request) async {
    return getUserStats(call, await request);
  }

  $async.Future<$0.GenericStringResponse> resetWeeklyStats_Pre($grpc.ServiceCall call, $async.Future<$1.Empty> request) async {
    return resetWeeklyStats(call, await request);
  }

  $async.Future<$0.User> getUser($grpc.ServiceCall call, $0.User request);
  $async.Future<$0.User> createUser($grpc.ServiceCall call, $0.User request);
  $async.Future<$0.User> updateUser($grpc.ServiceCall call, $0.User request);
  $async.Future<$0.User> deleteUser($grpc.ServiceCall call, $0.User request);
  $async.Future<$0.User> updateUserEmail($grpc.ServiceCall call, $0.UpdateEmailRequest request);
  $async.Future<$0.User> resetUserStreak($grpc.ServiceCall call, $0.User request);
  $async.Future<$0.User> resetUserWeekComplete($grpc.ServiceCall call, $0.User request);
  $async.Future<$0.DailySnapshot> getDailySnapshot($grpc.ServiceCall call, $0.DailySnapshot request);
  $async.Future<$0.DailySnapshot> updateDailySnapshot($grpc.ServiceCall call, $0.DailySnapshot request);
  $async.Future<$0.DailySnapshot> createDailySnapshot($grpc.ServiceCall call, $0.DailySnapshot request);
  $async.Future<$0.DailySnapshot> deleteDailySnapshot($grpc.ServiceCall call, $0.DailySnapshot request);
  $async.Future<$0.MultiDailySnapshot> getDailySnapshots($grpc.ServiceCall call, $0.DailySnapshot request);
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
  $async.Future<$0.SubscriptionTimeStamp> createSubscriptionTimeStamp($grpc.ServiceCall call, $0.SubscriptionTimeStamp request);
  $async.Future<$0.SubscriptionTimeStamp> getSubscriptionTimeStamp($grpc.ServiceCall call, $0.SubscriptionTimeStamp request);
  $async.Future<$0.SubscriptionTimeStamp> updateSubscriptionTimeStamp($grpc.ServiceCall call, $0.SubscriptionTimeStamp request);
  $async.Future<$0.SubscriptionTimeStamp> deleteSubscriptionTimeStamp($grpc.ServiceCall call, $0.SubscriptionTimeStamp request);
  $async.Future<$0.GenericStringResponse> figureDecay($grpc.ServiceCall call, $0.FigureInstance request);
  $async.Future<$0.GenericStringResponse> userWeeklyReset($grpc.ServiceCall call, $0.User request);
  $async.Future<$0.Friend> sendFriendRequest($grpc.ServiceCall call, $0.FriendRequest request);
  $async.Future<$0.Friend> acceptFriendRequest($grpc.ServiceCall call, $0.FriendRequest request);
  $async.Future<$0.Friend> rejectFriendRequest($grpc.ServiceCall call, $0.FriendRequest request);
  $async.Future<$0.GenericStringResponse> removeFriend($grpc.ServiceCall call, $0.FriendRequest request);
  $async.Future<$0.MultiFriends> getFriends($grpc.ServiceCall call, $0.FriendListRequest request);
  $async.Future<$0.MultiFriends> getPendingRequests($grpc.ServiceCall call, $0.FriendListRequest request);
  $async.Future<$0.Friend> checkFriendshipStatus($grpc.ServiceCall call, $0.FriendRequest request);
  $async.Future<$0.LeaderboardResponse> getLeaderboard($grpc.ServiceCall call, $0.LeaderboardRequest request);
  $async.Future<$0.UserStats> getUserStats($grpc.ServiceCall call, $0.User request);
  $async.Future<$0.GenericStringResponse> resetWeeklyStats($grpc.ServiceCall call, $1.Empty request);
}
