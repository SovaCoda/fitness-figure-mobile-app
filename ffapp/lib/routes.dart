import 'package:ffapp/services/auth.dart';
import 'package:grpc/grpc.dart';
import 'package:ffapp/services/routes.pbgrpc.dart';

class RoutesService {
  //For Cloud Run
  // String baseUrl = "grpcserver-uu2jutxfza-ue.a.run.app";
  // int port = 443;

  //works for android
  String baseUrl = "10.0.2.2";
  int port = 8080;

  // works for ios/macos
  // String baseUrl = "10.0.0.17";
  // int port = 8080;

  //String baseUrl = "127.0.0.1";

  var channel;

  RoutesService._internal();
  static final RoutesService _instance = RoutesService._internal();

  factory RoutesService() => _instance;

  static RoutesService get instance => _instance;

  late RoutesClient _routesClient;

  Future<void> init() async {
    _createChannel();
  }

  RoutesClient get routesClient {
    return _routesClient;
  }

  void _createChannel() {
    final channel = ClientChannel(
      baseUrl,
      port: port,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
    this.channel = channel;
    logger.i(
        "RoutesService channel created with port ${channel.port} and baseUrl $baseUrl");
    _routesClient = RoutesClient(channel);
  }
}