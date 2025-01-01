import 'package:ffapp/components/ff_alert_dialog.dart';
import 'package:ffapp/icons/fitness_icon.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/services/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class FfAppBar extends StatelessWidget {
  const FfAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size(MediaQuery.sizeOf(context).width, 40),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          OverflowBox(
            maxHeight: 165,
            maxWidth: MediaQuery.sizeOf(context).width,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SvgPicture.asset(
                fit: BoxFit.fill,
                'lib/assets/art/panel_top_bg.svg',
                width: MediaQuery.sizeOf(context).width,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              // Top app bar row for all the icons (QuestionMark, Currrency, FF+)
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Expanded to force logo to left while right aligning all other elements
                Expanded(
                  child: GestureDetector(
                    // Send user back to home page
                    onTap: () =>
                        Provider.of<HomeIndexProvider>(context, listen: false)
                            .setIndex(0),
                    child: const Align(
                      alignment: Alignment.bottomLeft,
                      child: FitnessIcon(
                        type: FitnessIconType.logo_white,
                        size: 40 -
                            0, // Logo icon is 10 pixels bigger than others for some reason
                      ),
                    ),
                  ),
                ),

                // Store button
                InkWell(
                  onTap: () =>
                      Provider.of<HomeIndexProvider>(context, listen: false)
                          .setIndex(7),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Consumer<CurrencyModel>(
                        builder: (context, currencyModel, child) {
                          return Text(currencyModel.currency,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ));
                        },
                      ),
                      const FitnessIcon(
                        type: FitnessIconType.currency_exchange,
                        size: 40,
                      )
                    ],
                  ),
                ),

                // Help Button
                InkWell(
                    onTap: () => {
                          showFFDialog(
                              "Questions/Concerns",
                              "Feel free to email us at fitnessfigure01@gmail.com with any feedback or questions, we'd love to hear from you!",
                              true,
                              context)
                        },
                    child: const Row(
                      children: [
                        FitnessIcon(
                          type: FitnessIconType.button_help,
                          size: 40,
                        ),
                      ],
                    )),

                // Removed for now until I move subscription logic to a seperate util file
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                //   child: InkWell(
                //     onTap: () async {
                //       try {
                //         CustomerInfo customerInfo =
                //             await Purchases.getCustomerInfo();
                //         // access latest customerInfo
                //         if (customerInfo
                //                 .entitlements.active['ff_plus'] !=
                //             null) {
                //           DateTime expiraryDate = DateTime.parse(
                //                   customerInfo
                //                       .entitlements
                //                       .active['ff_plus']!
                //                       .expirationDate!)
                //               .toLocal();
                //           DateFormat displayFormat =
                //               DateFormat("MM/dd/yyyy hh:mm a");
                //           showFFDialogWithChildren(
                //               "Youre Subscribed!",
                //               [
                //                 Column(
                //                   children: [
                //                     Text(
                //                         'Your benefits last until ${displayFormat.format(expiraryDate)}')
                //                   ],
                //                 )
                //               ],
                //               true,
                //               FfButton(
                //                   text: "Awesome!",
                //                   textColor: Theme.of(context)
                //                       .colorScheme
                //                       .onPrimary,
                //                   backgroundColor: Theme.of(context)
                //                       .colorScheme
                //                       .primary,
                //                   onPressed: () =>
                //                       Navigator.of(context).pop()),
                //               context);
                //         } else {
                //           final offers = await Purchases.getOfferings();
                //           final offer =
                //               offers.getOffering('ffigure_offering');
                //           final paywallresult =
                //               await RevenueCatUI.presentPaywall(
                //                   offering: offer,
                //                   displayCloseButton: true);
                //           logger.i('Paywall Result $paywallresult');
                //           if (paywallresult ==
                //                   PaywallResult.purchased ||
                //               paywallresult == PaywallResult.restored) {
                //             Provider.of<UserModel>(context,
                //                     listen: false)
                //                 .setPremium(Int64.ONE);
                //           }
                //         }
                //       } on PlatformException catch (e) {
                //         // Error fetching customer info
                //       }
                //     },
                //     child: Row(
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         const SizedBox(width: 10.0),
                //         Text(
                //           'FF',
                //           style: Theme.of(context)
                //               .textTheme
                //               .headlineLarge!
                //               .copyWith(
                //                 color: Theme.of(context)
                //                     .colorScheme
                //                     .secondary,
                //               ),
                //         ),
                //         Icon(
                //           Icons.add,
                //           color:
                //               Theme.of(context).colorScheme.secondary,
                //         ),
                //       ],
                //     ),
                //   ),
                // ),

                //question mark area that displays an alert on tap
              ],
            ),
          )
        ],
      ),
    );
  }
}
