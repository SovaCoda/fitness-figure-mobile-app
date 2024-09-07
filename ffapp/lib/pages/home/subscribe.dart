import 'package:ffapp/components/robot_image_holder.dart';
import 'package:ffapp/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ffapp/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:ffapp/services/routes.pb.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:fixnum/fixnum.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SubscribePage extends StatelessWidget {
  const SubscribePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SubscribePageModel(context),
      child: const _SubscribePageContent(),
    );
  }
}

class _SubscribePageContent extends StatelessWidget {
  const _SubscribePageContent();

  

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<SubscribePageModel>(context);

    return Scaffold(
      appBar: _buildAppBar(context),
      body: model.isLoading
          ? _buildSkeletonLoader()
          : model.user?.premium == Int64(1)
              ? _buildSubscribedContent(context)
              : _buildSubscriptionOptions(context, model),
    );
  }

  

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.grey[900],
      leading: IconButton(
        icon: Icon(Icons.arrow_back,
            color: Theme.of(context).colorScheme.primary),
        onPressed: () => context.goNamed("Home"),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'FF',
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontStyle: FontStyle.italic,
                ),
          ),
          Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
        ],
      ),
      actions: const [SizedBox(width: 48)],
      centerTitle: true,
    );
  }

  Widget _buildSkeletonLoader() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildSubscriptionOptions(
      BuildContext context, SubscribePageModel model) {
    final FigureModel figure = Provider.of<FigureModel>(context, listen: false);
    return Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(color: Colors.grey[900]),
        child: RefreshIndicator(
          onRefresh: model.refreshUserData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Upgrade to Fitness Figure Plus!",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  RobotImageHolder(
                    // Replace this with some custom skin that the user needs premium for
                    url: (figure.figure != null)
                        ? ("${figure.figure!.figureName}/${figure.figure!.figureName}_skin${figure.figure!.curSkin}_evo${figure.figure!.evLevel}_cropped_happy")
                        : "robot1/robot1_skin0_evo0_cropped_happy",
                    height: MediaQuery.of(context).size.height * 0.30,
                    width: 500,
                  ),
                  _buildFeatureCard(context),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: ElevatedButton(
                        onPressed: model.makePayment,
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary),
                        child: Text(
                          "Subscribe Now - \$1.99/month",
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      )),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => context.goNamed("Home"),
                    child: Text(
                      "Maybe Later",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                  ),
                  _buildTogglePremiumButton(context: context)
                ],
              ),
            ),
          ),
        ));
  }

  // Debugging button to toggle premium status
  Widget _buildTogglePremiumButton({required BuildContext context}) {
    return ElevatedButton(
      onPressed: () {
        Provider.of<SubscribePageModel>(context, listen: false).togglePremium();
      },
      child: Text(
        "Toggle Premium Status",
        style: Theme.of(context).textTheme.displayMedium,
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildFeatureItem(context, Icons.bolt, "+10% Charge Rate",
                Theme.of(context).colorScheme.primary),
            _buildFeatureItem(context, Icons.trending_up, "+50% EVO Gain",
                Theme.of(context).colorScheme.secondary),
            _buildFeatureItem(context, Icons.monetization_on,
                "+100% Currency Gain", Theme.of(context).colorScheme.tertiary),
            _buildFeatureItem(
                context,
                Icons.auto_graph,
                "Track Progress, Boost Performance",
                Theme.of(context).colorScheme.error),
            _buildFeatureItem(context, Icons.chat, "Your AI Fitness Coach",
                Theme.of(context).colorScheme.primary),
            _buildFeatureItem(
                context,
                Icons.style,
                "Exclusive Figure Cosmetics",
                Theme.of(context).colorScheme.secondary),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
      BuildContext context, IconData icon, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscribedContent(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: Colors.grey[900]),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Text(
                    "You're already subscribed to Fitness Figure Plus!",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                    textAlign: TextAlign.center,
                  )),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Text(
                  "Enjoy your premium benefits!",
                  style: Theme.of(context).textTheme.displayMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: _buildFeatureCard(context)),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => context.goNamed("Home"),
                child: Text(
                  "Return to Home",
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
              _buildTogglePremiumButton(context: context)
            ],
          ),
        ));
  }
}

class SubscribePageModel with ChangeNotifier {
  final BuildContext context;
  User? user;
  bool isLoading = true;
  Map<String, dynamic>? paymentIntent;

  SubscribePageModel(this.context) {
    _init();
  }

  Future<void> _init() async {
    await refreshUserData();
  }

  Future<void> refreshUserData() async {
    isLoading = true;
    notifyListeners();

    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      user = await auth.getUserDBInfo();
    } catch (e) {
      logger.e('Error fetching user data: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> makePayment() async {
    if (user?.premium == Int64(1)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You are already subscribed!')),
      );
      return;
    }

    try {
      paymentIntent = await createPaymentIntent('1.99', 'USD');
      await stripe.Stripe.instance.initPaymentSheet(
        paymentSheetParameters: stripe.SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          style: ThemeMode.dark,
          merchantDisplayName: 'Fitness Figure Plus',
        ),
      );
      await displayPaymentSheet();
    } catch (e) {
      logger.e('Error: $e');
    }
  }

  Future<void> displayPaymentSheet() async {
    try {
      await stripe.Stripe.instance.presentPaymentSheet();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment successful')),
      );

      final userModel = Provider.of<UserModel>(context, listen: false);
      userModel.setPremium(Int64(1));
      await Provider.of<AuthService>(context, listen: false)
          .updateUserDBInfo(userModel.user!);
      await refreshUserData();
    } on stripe.StripeException catch (e) {
      _handleStripeError(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
    }
  }

  void _handleStripeError(stripe.StripeException e) {
    String displayMessage;
    if (e.error.code == stripe.FailureCode.Canceled) {
      displayMessage = 'Payment canceled';
    } else if (e.error.localizedMessage != null) {
      displayMessage = e.error.localizedMessage!;
    } else if (e.error.message != null) {
      displayMessage = e.error.message!;
    } else {
      displayMessage = 'An error occurred during payment';
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(displayMessage)),
    );
  }

  Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      int amountInSmallestUnit = (double.parse(amount) * 100).round();

      Map<String, dynamic> body = {
        'amount': amountInSmallestUnit.toString(),
        'currency': currency,
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET_KEY']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  
  // Toggles premium status for debugging purposes
  void togglePremium() {
    final userModel = Provider.of<UserModel>(context, listen: false);
    userModel.setPremium(user?.premium == Int64(1) ? Int64(0) : Int64(1));
    Provider.of<AuthService>(context, listen: false).updateUserDBInfo(userModel.user!);
    refreshUserData();
  }

  
}
