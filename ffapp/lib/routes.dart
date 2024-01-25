import 'package:ffapp/services/auth.dart';
import 'package:grpc/grpc.dart';
import 'package:ffapp/services/routes.pbgrpc.dart';

class RoutesService {

  //works for android
  String baseUrl = "10.0.2.2";

  //works for ios/macos
  // String baseUrl = "0.0.0.0";
  
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
      port: 8080,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
    this.channel = channel;
    logger.i("RoutesService channel created with port " +
        channel.port.toString() +
        " and baseUrl " +
        baseUrl);
    _routesClient = RoutesClient(channel);
  }
}
