// import 'package:ffapp/components/robot_image_holder.dart';
import 'package:ffapp/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SubscribePage extends StatefulWidget {
  const SubscribePage({super.key});

  @override
  SubscribePageState createState() => SubscribePageState();
}

class SubscribePageState extends State<SubscribePage> {
  Map<String, dynamic>? paymentIntent;
  bool _isMounted = true;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  void _safeSetState(VoidCallback callback) {
    if (_isMounted) {
      setState(callback);
    }
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      elevation: 0, // Remove shadow
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Match background color
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary),
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
      actions: [
        // Add a dummy action to balance the leading icon
        SizedBox(width: 48),
      ],
      centerTitle: true,
    ),
    body: Consumer<UserModel>(
      builder: (context, userModel, child) {
        // Uncomment this when ready to differentiate between subscribed and non-subscribed users
        /*
        if (userModel.user?.premium ?? false) {
          return _buildSubscribedContent(context);
        } else {
          return _buildSubscriptionOptions(context);
        }
        */
        return _buildSubscriptionOptions(context);
      },
    ),
  );
}
Widget _buildSubscriptionOptions(BuildContext context) {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Upgrade to Fitness Figure Plus!",
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildFeatureItem(context, Icons.bolt, "+10% Charge Rate", Theme.of(context).colorScheme.primary),
                  _buildFeatureItem(context, Icons.trending_up, "+50% EVO Gain", Theme.of(context).colorScheme.tertiary),
                  _buildFeatureItem(context, Icons.monetization_on, "+100% Currency Gain", Theme.of(context).colorScheme.secondary),
                  _buildFeatureItem(context, Icons.style, "Exclusive Figure Cosmetics", Theme.of(context).colorScheme.primary),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => makePayment(),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              "Subscribe Now - \$1.99/month",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () => context.goNamed("Home"),
            child: Text(
              "Maybe Later",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildFeatureItem(BuildContext context, IconData icon, String text, Color color) {
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
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "You're already subscribed to Fitness Figure Plus!",
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Text(
          "Enjoy your premium benefits!",
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () => context.goNamed("Home"),
          child: const Text("Return to Home"),
        ),
      ],
    ),
  );
}


  Future<void> makePayment() async {
     if (!_isMounted) return;

    try {
      paymentIntent = await createPaymentIntent('1.99', 'USD');
      /*
      final userModel = Provider.of<UserModel>(context, listen: false);
      
      if (userModel.user?.premium ?? false) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You are already subscribed!')),
        );
        return;
      }
      */
      await stripe.Stripe.instance.initPaymentSheet(
        paymentSheetParameters: stripe.SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          style: ThemeMode.dark,
          merchantDisplayName: 'Fitness Figure Plus',
        ),
      );
    if(_isMounted) {
      displayPaymentSheet();
    }
    } catch (e) {
      print('Error: $e');
    }
  }
// To simulate a purchase, use the card number 4242 4242 4242 4242 and any future expiration date and CVC
  Future<void> displayPaymentSheet() async {
    try {
      await stripe.Stripe.instance.presentPaymentSheet();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment successful')),
      );
      // Here you would typically update the user's subscription status but not working right now
      // Provider.of<UserModel>(context, listen: false).updateUserPremium(true);
      if (!_isMounted) return;
    } on stripe.StripeException catch (e) {
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
    catch (e) {
      print('Unexpected error: $e');
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(String amount, String currency) async {
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

  String calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount)) * 100;
    return calculatedAmount.toString();
  }
}

