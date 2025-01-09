import 'package:ffapp/main.dart';
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/flutterUser.dart';
import "package:ffapp/services/routes.pb.dart" as routes;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../components/ff_app_button.dart';
import '../../components/resuables/gradiented_container.dart';

class AvatarSelection extends StatefulWidget {
  const AvatarSelection({super.key});

  @override
  State<AvatarSelection> createState() => _AvatarSelectionState();
}

class _AvatarSelectionState extends State<AvatarSelection> {
  FlutterUser user = FlutterUser();
  late AuthService auth;
  String curEmail = "Loading...";
  int selectedFigure = -1;

  @override
  void initState() {
    super.initState();
    auth = Provider.of<AuthService>(context, listen: false);
    initialize();
  }

  Future<void> initialize() async {
    await user.initAuthService();
    await user.checkUser();
    curEmail = await user.getEmail();
    setState(() {});
    logger.i(user);
  }

  Future<void> submitFigure(String figureUrl) async {
    user.updateUser(
      routes.User(
        email: curEmail,
        curFigure: figureUrl,
      ),
    );

    await auth.createFigureInstance(routes.FigureInstance(
        figureName: figureUrl,
        userEmail: curEmail,
        curSkin: "0",
        evPoints: 0,
        charge: 70,
        lastReset: '2001-09-04 19:21:00'));
    await auth.createSkinInstance(routes.SkinInstance(
        skinName: '0', userEmail: curEmail, figureName: figureUrl));
    if (mounted) {
      Provider.of<FigureModel>(context, listen: false).setFigure(
          routes.FigureInstance(
              figureName: figureUrl,
              userEmail: curEmail,
              curSkin: "0",
              evPoints: 0,
              charge: 70,
              lastReset: '2001-09-04 19:21:00'));
    }
    if (mounted) {
      context.goNamed('WorkoutFrequencySelection');
    }
  }

  Widget _buildFigureOption(int index, String assetPath, String label) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double size =
            constraints.maxWidth < 600 ? constraints.maxWidth * 0.4 : 260.0;
        return Stack(children: [
          GestureDetector(
            onTap: () {
              setState(() {
                selectedFigure = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: selectedFigure == index
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: Center(
                      child: Image.asset(
                        assetPath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      OverflowBox(
          maxWidth: MediaQuery.sizeOf(context).width + 200,
          maxHeight: MediaQuery.sizeOf(context).height + 200,
          child: Image.asset(
            'lib/assets/art/ff_background.png',
            width: MediaQuery.sizeOf(context).width + 200,
            height: MediaQuery.sizeOf(context).height + 400,
          )),
      Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return _buildWideLayout();
              } else {
                return _buildNarrowLayout();
              }
            },
          ),
        ),
      ),
    ]);
  }

  Widget _buildWideLayout() {
    return Row(
      children: [
        Expanded(
          child: _buildInstructions(),
        ),
        Expanded(
          flex: 2,
          child: _buildFigureSelection(),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildInstructions(),
          _buildFigureSelection(),
        ],
      ),
    );
  }

  Widget _buildInstructions() {
    return GradientedContainerWidget(
      width: MediaQuery.of(context).size.width * 1,
      height: MediaQuery.of(context).size.height * 0.2,
      showTopRectangle: true,
      title: Column(
        children: [
          Text(
            "Choose Your",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            "Fitness Companion",
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
      description: Text(
        "Select your virtual fitness buddy to guide and motivate you throughout your workout journey.",
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }

  Widget _buildFigureSelection() {
    return Container(
        padding: const EdgeInsets.only(
          left: 20,
          top: 10,
          right: 14,
        ),
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color.fromRGBO(51, 133, 162, 1),
            ),
          ),
          gradient: LinearGradient(
            colors: <Color>[
              Color.fromRGBO(28, 109, 189, 0.29),
              Color.fromRGBO(0, 164, 123, 0.29),
            ],
          ),
        ),
        height: MediaQuery.of(context).size.height * 0.75,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Wrap(
                spacing: 24,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: [
                  _buildFigureOption(
                      0,
                      'lib/assets/robot1/robot1_skin0_evo0_cropped_happy.gif',
                      'Robot 1'),
                  _buildFigureOption(
                      1,
                      'lib/assets/robot2/robot2_skin0_evo0_cropped_happy.gif',
                      'Robot 2'),
                ],
              ),
              const SizedBox(height: 40),
              // ElevatedButton(
              //   onPressed: selectedFigure != -1
              //       ? () => submitFigure("robot${selectedFigure + 1}")
              //       : null,
              //   style: ElevatedButton.styleFrom(
              //     padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(30),
              //     ),
              //     backgroundColor: Theme.of(context).colorScheme.primary,
              //     foregroundColor: Theme.of(context).colorScheme.onPrimary,
              //   ),
              //   child: Text(
              //     "Let's Get Started!",
              //     style: Theme.of(context).textTheme.titleLarge!.copyWith(
              //       color: Theme.of(context).colorScheme.onPrimary,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
              FFAppButton(
                text: "LET'S GET STARTED",
                fontSize: 20,
                size: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.08,
                onPressed: selectedFigure != -1
                    ? () => submitFigure("robot${selectedFigure + 1}")
                    : null,
              )
            ],
          ),
        ));
  }
}
