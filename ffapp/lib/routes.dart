import 'package:grpc/grpc.dart';
import 'package:ffapp/services/routes.pbgrpc.dart';

class RoutesService {
  String baseUrl = "localhost";

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
    _routesClient = RoutesClient(channel);
  }
}
