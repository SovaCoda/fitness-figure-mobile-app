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

  $async.Future<$0.User> getUser($grpc.ServiceCall call, $0.User request);
  $async.Future<$0.User> createUser($grpc.ServiceCall call, $0.User request);
  $async.Future<$0.User> updateUser($grpc.ServiceCall call, $0.User request);
  $async.Future<$0.User> deleteUser($grpc.ServiceCall call, $0.User request);
}
