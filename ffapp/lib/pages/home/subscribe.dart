import 'dart:async';
import 'dart:io';
import 'package:ffapp/components/robot_image_holder.dart';
import 'package:ffapp/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ffapp/services/auth.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:ffapp/services/routes.pb.dart' as Routes;
import 'package:fixnum/fixnum.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';


class SubscribePage extends StatelessWidget {
  const SubscribePage({super.key});
  @override
  Widget build(BuildContext context) {
      return _SubscribePageContent();
  }
}

class _SubscribePageContent extends StatefulWidget {
  const _SubscribePageContent();

  @override
  State<_SubscribePageContent> createState() => _SubscribePageState();
}

class _SubscribePageState extends State<_SubscribePageContent> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = <String>[];
  List<ProductDetails> _products = <ProductDetails>[];
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  List<String> _consumables = <String>[];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;
  List<ProductDetails> products = [];


  final List<String> _kProductIds = <String>['ffigure'];

  @override
  void initState() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (Object error) {
      // handle error here.
    },);
    initStoreInfo();
    
    super.initState();

  }

  @override
  void dispose() {
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _subscription.cancel();
    super.dispose();
  }

  Future<void> initStoreInfo() async {
    //InAppPurchase.instance.restorePurchases();
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = <ProductDetails>[];
        _purchases = <PurchaseDetails>[];
        _notFoundIds = <String>[];
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }
    
    final paymentWrapper = SKPaymentQueueWrapper();
    final transactions = await paymentWrapper.transactions();
    transactions.forEach((transaction) async {
        await paymentWrapper.finishTransaction(transaction);
    });

    const Set<String> _kIds = <String>{'ffigure'};
    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(_kIds);
    if (response.notFoundIDs.isNotEmpty) {
      logger.i("Could not retrieve product ID's");
    }
    products = response.productDetails;
    AppStoreProductDetails appStoreProduct = products[0] as AppStoreProductDetails;
    appStoreProduct.skProduct.subscriptionPeriod.toString();
    logger.i("Retreived ${products.length} product codes");

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      //await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    final ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error!.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }
    

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    setState(() {
      _loading = false;
    });
  }
  

    Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
        AuthService auth = Provider.of<AuthService>(context, listen:false);
        Routes.User user = Provider.of<UserModel>(context, listen: false).user!;
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        print("pending purchase");
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          final bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            Routes.SubscriptionTimeStamp subscription = Routes.SubscriptionTimeStamp(email: user.email);
            try {
              subscription = await auth.getSubscriptionTimeStamp(subscription);
            } catch (err) {
              DateTime now = DateTime.now();
              DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
              int daysRemaning = lastDayOfMonth.difference(now).inDays;
              DateTime expiraryDate = now.add(Duration(days: daysRemaning));
              subscription = await auth.createSubscriptionTimeStamp(Routes.SubscriptionTimeStamp(email: user.email, subscribedOn: now.toUtc().toString(), expiresOn: expiraryDate.toUtc().toString(), transactionId: purchaseDetails.purchaseID));
            }
            DateTime transactionDate = DateTime.fromMillisecondsSinceEpoch(int.parse(purchaseDetails.transactionDate!));
            if(DateTime.parse(subscription.expiresOn!).isAfter(transactionDate) ){
              logger.e("User transaction date is before the expirary date!");
            } else {
              DateTime now = transactionDate;
              DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
              int daysRemaning = lastDayOfMonth.difference(now).inDays;
              DateTime expiraryDate = now.add(Duration(days: daysRemaning));
              subscription = await auth.createSubscriptionTimeStamp(Routes.SubscriptionTimeStamp(email: user.email, subscribedOn: now.toUtc().toString(), expiresOn: expiraryDate.toUtc().toString(), transactionId: purchaseDetails.purchaseID));
            }
            
            unawaited(deliverProduct(purchaseDetails));
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  Future<void> _initiateAppStorePurchase () async {
    if (Provider.of<UserModel>(context, listen: false).user!.premium == Int64(1)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You are already subscribed!')),
      );
      return;
    }

    // final paymentWrapper = SKPaymentQueueWrapper();
    // final transactions = await paymentWrapper.transactions();
    // transactions.forEach((transaction) async {
    //     await paymentWrapper.finishTransaction(transaction);
    // });
    
    try {
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: products[0]);
      await InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      logger.e('Error: $e');
    }
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
  // IMPORTANT!! Always verify purchase details before delivering the product.
  if (purchaseDetails.productID == 'ffigure') {
    AuthService auth = Provider.of<AuthService>(context, listen: false);
    Routes.User user = Provider.of<UserModel>(context,listen: false).user!;
    user.premium = Int64.ONE;
    auth.updateUserDBInfo(user);
    
    setState(() {
      _purchasePending = false;
    });
  } else {
    setState(() {
      _purchases.add(purchaseDetails);
    });
  }
}

Future<void> revokeProduct() async {
  AuthService auth = Provider.of<AuthService>(context, listen: false);
  Routes.User user = Provider.of<UserModel>(context,listen: false).user!;
  user.premium = Int64(-1);
  auth.updateUserDBInfo(user);
}

void handleError(IAPError error) {
  setState(() {
    _purchasePending = false;
  });
}


Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
  // IMPORTANT!! Always verify a purchase before delivering the product.
  // For the purpose of an example, we directly return true.
  return Future<bool>.value(true);
}

void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
  // handle invalid purchase here if  _verifyPurchase` failed.
}

  Future<Routes.User?> refreshUserData() async {
    _loading = true;
    Routes.User? user;

    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      user = await auth.getUserDBInfo();
      logger.i('Refreshed user data: ${user?.toString()}');
      return user;
    } catch (e) {
      logger.e('Error fetching user data: $e');
      return null;
    } finally {
      _loading = false;
      if(user != null) {Provider.of<UserModel>(context, listen: false).setUser(user);}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
      builder: (_, user, __) {
      return Scaffold(
        appBar: _buildAppBar(context),
        body: _loading
            ? _buildSkeletonLoader()
            : user.user!.premium == Int64(1)
                ? _buildSubscribedContent(context)
                : _buildSubscriptionOptions(context),
      );}
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
      BuildContext context) {
    final FigureModel figure = Provider.of<FigureModel>(context, listen: false);
    return Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(color: Colors.grey[900]),
        child: RefreshIndicator(
          onRefresh: refreshUserData,
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
                        ? ("${figure.figure!.figureName}/${figure.figure!.figureName}_skin0_evo${figure.figure!.evLevel}_cropped_happy")
                        : "robot1/robot1_skin0_evo0_cropped_happy",
                    height: MediaQuery.of(context).size.height * 0.30,
                    width: 500,
                  ),
                  _buildFeatureCard(context),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: ElevatedButton(
                        onPressed: _initiateAppStorePurchase,
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
                  //_buildTogglePremiumButton(context)
                ],
              ),
            ),
          ),
        ));
  }

  // Debugging button to toggle premium status
  Widget _buildTogglePremiumButton(BuildContext context, {bool debugging = true}) {
    return debugging ? ElevatedButton(
      onPressed: () {
        //Provider.of<SubscribePageModel>(context, listen: false).togglePremium();
      },
      child: Text(
        "Toggle Premium Status",
        style: Theme.of(context).textTheme.displayMedium,
      ),
    ) : Container();
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
              //_buildTogglePremiumButton(context)
            ],
          ),
        ));
  }
}

// class SubscribePageModel with ChangeNotifier {
//   final BuildContext context;
//   User? user;
//   bool isLoading = true;
//   Map<String, dynamic>? paymentIntent;
//   List<ProductDetails> products = [];

//   SubscribePageModel(this.context) {
//     _init();
//   }

//   Future<void> _init() async {
//         final paymentWrapper = SKPaymentQueueWrapper();
//     final transactions = await paymentWrapper.transactions();
//     transactions.forEach((transaction) async {
//         await paymentWrapper.finishTransaction(transaction);
//     });

//     final bool available = await InAppPurchase.instance.isAvailable();
//     if (!available) {
//       //Store could not be accessed for some reason 
//       showFFDialog("Oops", "Something is currently wrong with the store right now, check back later", true, context);
//     }
//     const Set<String> _kIds = <String>{'ffigure'};
//     final ProductDetailsResponse response =
//         await InAppPurchase.instance.queryProductDetails(_kIds);
//     if (response.notFoundIDs.isNotEmpty) {
//       logger.e("Could not retrieve product ID's");
//     }
//     products = response.productDetails;
//     logger.i("Retreived ${products.length} product codes");
//     User? user = await refreshUserData();
//     //await InAppPurchase.instance.restorePurchases(applicationUserName: user!.email);
//     // Maybe restore purchases? not sure if this restores all purchases or just ones that need to be restored to the user.
//   }

//   Future<User?> refreshUserData() async {
//     isLoading = true;
//     notifyListeners();

//     try {
//       final auth = Provider.of<AuthService>(context, listen: false);
//       user = await auth.getUserDBInfo();
//       logger.i('Refreshed user data: ${user?.toString()}');
//       return user;
//     } catch (e) {
//       logger.e('Error fetching user data: $e');
//       return null;
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> makePayment() async {
//     if (user?.premium == Int64(1)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('You are already subscribed!')),
//       );
//       return;
//     }

//     // final paymentWrapper = SKPaymentQueueWrapper();
//     // final transactions = await paymentWrapper.transactions();
//     // transactions.forEach((transaction) async {
//     //     await paymentWrapper.finishTransaction(transaction);
//     // });

//     try {
//       final PurchaseParam purchaseParam = PurchaseParam(productDetails: products[0]);
//       await InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
//     } catch (e) {
//       logger.e('Error: $e');
//     }
//   }

//   Future<void> displayPaymentSheet() async {
//     try {
//       await stripe.Stripe.instance.presentPaymentSheet();
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Payment successful')),
//       );

//       final userModel = Provider.of<UserModel>(context, listen: false);
//       userModel.setPremium(Int64(1));
//       await Provider.of<AuthService>(context, listen: false)
//           .updateUserDBInfo(userModel.user!);
//       await refreshUserData();
//     } on stripe.StripeException catch (e) {
//       _handleStripeError(e);
//     } catch (e) {
//       logger.e('Unexpected error: $e');
//     }
//   }

//   void _handleStripeError(stripe.StripeException e) {
//     String displayMessage;
//     if (e.error.code == stripe.FailureCode.Canceled) {
//       displayMessage = 'Payment canceled';
//     } else if (e.error.localizedMessage != null) {
//       displayMessage = e.error.localizedMessage!;
//     } else if (e.error.message != null) {
//       displayMessage = e.error.message!;
//     } else {
//       displayMessage = 'An error occurred during payment';
//     }
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(displayMessage)),
//     );
//   }

//   Future<Map<String, dynamic>> createPaymentIntent(
//       String amount, String currency) async {
//     try {
//       int amountInSmallestUnit = (double.parse(amount) * 100).round();

//       Map<String, dynamic> body = {
//         'amount': amountInSmallestUnit.toString(),
//         'currency': currency,
//       };

//       var response = await http.post(
//         Uri.parse('https://api.stripe.com/v1/payment_intents'),
//         headers: {
//           'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET_KEY']}',
//           'Content-Type': 'application/x-www-form-urlencoded'
//         },
//         body: body,
//       );
//       return json.decode(response.body);
//     } catch (err) {
//       throw Exception(err.toString());
//     }
//   }

//   // Toggles premium status for debugging purposes
//   void togglePremium() async {
//     if (user == null) {
//       logger.e('Cannot toggle premium: user is null');
//       return;
//     }

//     final authService = Provider.of<AuthService>(context, listen: false);

//     // Toggle the premium status
//     Int64 newPremiumValue = user!.premium == Int64(1) ? Int64(-1) : Int64(1);
//     logger.i('Toggling premium from ${user!.premium} to $newPremiumValue');
//     User updatedUser = User(
//       email: user!.email,
//       premium: newPremiumValue,
//     );
//     logger.i('Updating user in database: ${updatedUser.toString()}');
//     try {
//       await authService.updateUserDBInfo(updatedUser);
//       Provider.of<UserModel>(context, listen: false).setPremium(newPremiumValue == Int64(-1) ? Int64(0) : Int64(1));
//     } catch (e) {
//       logger.e('Error updating user in database: $e'); 
//       return;
//     }
//     await refreshUserData();
//     notifyListeners();
//   }

// }
