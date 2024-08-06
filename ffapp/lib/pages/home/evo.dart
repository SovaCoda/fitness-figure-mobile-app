import 'package:ffapp/components/robot_image_holder.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/routes.pb.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ffapp/pages/home/survey.dart';
import 'package:ffapp/pages/home/home.dart';
import 'package:ffapp/components/evolution_item.dart';

class EvolutionPage extends StatefulWidget {
  const EvolutionPage({super.key});

  @override
  State<EvolutionPage> createState() => _EvolutionPageState();
}

class _EvolutionPageState extends State<EvolutionPage>
    with TickerProviderStateMixin {
  late AuthService auth;
  late AnimationController _controller;

  late Animation<Color?> _colorAnimation;
  late Animation<double> _sizeAnimation;
  late Animation<double> _opacityAnimation;

  late AnimationController _flashController;
  late Animation<double> _flashAnimation;

  late AnimationController _figureFadeController;
  late Animation<double> _figureFadeAnimation;

  bool _isAnimating = false;
  bool _showNewBenefits = false;
  bool _isEvolved = false;
  bool _disabledButtons = false;
  late AppBarAndBottomNavigationBarModel appBarAndBottomNavigationBar;

  @override
  void initState() {
    super.initState();
    auth = Provider.of<AuthService>(context, listen: false);

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _flashController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _flashAnimation = Tween<double>(begin: 0, end: 1).animate(_flashController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _flashController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _flashController.reset();
          _flashController.stop();
        }
      });

    _colorAnimation = ColorTween(
      begin: Colors.transparent,
      end: Colors.green,
    ).animate(_controller);

    _sizeAnimation = Tween<double>(begin: 400, end: 600).animate(_controller);

    _opacityAnimation = Tween<double>(begin: 1, end: 0).animate(_controller);
    appBarAndBottomNavigationBar =
        Provider.of<AppBarAndBottomNavigationBarModel>(context, listen: false);
  }

  void evolveFigure() async {
    setState(() {
      _disabledButtons = true;
    });
    await _controller.forward(from: 0);
    await _controller.status == AnimationStatus.completed;
    await _flashController.forward(from: 0);
    await Future.delayed(Duration(seconds: 1));
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      Provider.of<FigureModel>(context, listen: false).setFigureLevel(
          Provider.of<FigureModel>(context, listen: false).figure!.evLevel + 1);
      _isEvolved = true;
      auth.updateFigureInstance(
          Provider.of<FigureModel>(context, listen: false).figure!);
    });
    await Future.delayed(Duration(seconds: 1));
    await _controller.reverse();
    await _flashController.reverse();
    setState(() {
      _disabledButtons = false;
      _isAnimating = false;
      _showNewBenefits = true;
    });
  }

  Map<String, String> evoQuestions = {
    'Do you think that this evolution is significant enough visually?': ''
  };

  void setAnswer(String question, String answer) {
    evoQuestions[question] = answer;
  }

  bool storeSurveyAnswers(Map<String, String> answers) {
    List<SurveyResponse> responses = [];
    answers.forEach((key, value) {
      SurveyResponse response = SurveyResponse();
      response.question = key;
      response.answer = value;
      response.email =
          Provider.of<UserModel>(context, listen: false).user?.email ?? '';
      response.date = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      responses.add(response);
    });
    MultiSurveyResponse response =
        MultiSurveyResponse(surveyResponses: responses);
    auth.createSurveyResponseMulti(response);
    return false;
  }

  void viewRewards() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Survey'),
          content: Container(
            width: 400,
            height: 500,
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: evoQuestions.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Text(evoQuestions.keys.elementAt(index)),
                        OneThroughFiveSelector(
                            question: evoQuestions.keys.elementAt(index),
                            setAnswer: (String answer) => setAnswer(
                                evoQuestions.keys.elementAt(index), answer))
                      ],
                    );
                  },
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                storeSurveyAnswers(evoQuestions);
                context.goNamed('Home');
                Navigator.of(context).pop();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  double? usableScreenHeight;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appBarHeight =
          appBarAndBottomNavigationBar.appBarKey.currentContext?.size?.height;
      final bottomNavBarHeight = appBarAndBottomNavigationBar
          .bottomNavBarKey.currentContext?.size?.height;
      final screenheight = MediaQuery.sizeOf(context).height;
      setState(() {
        Provider.of<AppBarAndBottomNavigationBarModel>(context, listen: false)
            .setUsableScreenHeight(
                screenheight - (appBarHeight ?? 0) - (bottomNavBarHeight ?? 0));
        usableScreenHeight =
            screenheight - (appBarHeight ?? 0) - (bottomNavBarHeight ?? 0);
      });
    });
    return Scaffold(
        appBar: AppBar(
            backgroundColor:
                Theme.of(context).colorScheme.surface.withAlpha(127),
            title: Text("Evolution",
                style: Theme.of(context).textTheme.displayMedium),
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  context.goNamed('Home');
                })),
        backgroundColor: Colors.black,
        body: Stack(alignment: Alignment.center, children: [
          Container(
              padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 5),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(13)),
                gradient: RadialGradient(
                  center: Alignment.center,
                  focalRadius: 0.1,
                  colors: [
                    Theme.of(context).colorScheme.onPrimary.withOpacity(0),
                    Theme.of(context).colorScheme.surface.withOpacity(0.45),
                  ],
                ),
                border: Border.all(
                  color: Theme.of(context).colorScheme.surface,
                  width: 3,
                ),
              ),
              child: Center(child: Consumer<FigureModel>(
                builder: (context, figure, child) {
                  return AnimatedBuilder(
                      animation: _colorAnimation,
                      builder: (context, child) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 350,
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.white, width: 1)),
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                      _flashAnimation.value * 10 ?? 0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _colorAnimation.value!,
                                      spreadRadius: _flashAnimation.value * 100,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ]),
                              child: RobotImageHolder(
                                  url: (figure.figure != null)
                                      ? ("${figure.figure!.figureName}/${figure.figure!.figureName}_skin${figure.figure!.curSkin}_evo${(figure.EVLevel != null) ? figure.EVLevel : 0}_cropped_happy")
                                      : "robot1/robot1_skin0_evo0_cropped_happy",
                                  height: _isAnimating
                                      ? usableScreenHeight! - 182
                                      : MediaQuery.of(context).size.height *
                                          0.4,
                                  width: MediaQuery.of(context).size.width),
                            ),
                            _showNewBenefits
                                ? Center(
                                    child: SizedBox(
                                      width: 200,
                                      child: GridView.count(
                                        crossAxisCount: 1,
                                        padding: const EdgeInsets.all(16),
                                        mainAxisSpacing: 16,
                                        crossAxisSpacing: 16,
                                        shrinkWrap: true,
                                        children: [
                                          EvolutionItem(
                                            title: 'EVO ${figure.EVLevel + 1}',
                                            upgrades: [
                                              '\$0.25/Sec',
                                              'Research Unlocked'
                                            ], // Replace benefits with a variable list that contains the benefits of each evolution (figure_ev_data.dart?)
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Expanded(
                                    child: GridView.count(
                                      crossAxisCount: 2,
                                      padding: const EdgeInsets.all(16),
                                      mainAxisSpacing: 16,
                                      crossAxisSpacing: 16,
                                      children: [
                                        EvolutionItem(
                                          title: 'EVO ${figure.EVLevel}',
                                          upgrades: [
                                            '\$0.05/Sec'
                                          ], // Replace benefits with a variable list that contains the benefits of each evolution (figure_ev_data.dart?)
                                        ),
                                        EvolutionItem(
                                          title: 'EVO ${figure.EVLevel + 1}',
                                          upgrades: [
                                            '\$0.25/Sec',
                                            'Research Unlocked'
                                          ],
                                          isUnlocked:
                                              false, // Adds lock icon to next line
                                        ),
                                        // Add more EvolutionItem widgets as needed
                                      ],
                                    ),
                                  ),
                            Opacity(
                              opacity: _opacityAnimation.value ?? 0,
                              child: !_isEvolved
                                  ? Container(
                                      width: MediaQuery.of(context).size.width -
                                          40,
                                      margin: const EdgeInsets.only(bottom: 10),
                                      height: 45.0,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _isAnimating = true;
                                          });
                                          _disabledButtons
                                              ? ()
                                              : evolveFigure();
                                        },
                                        child: Text('EVOLVE',
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium),
                                      ))
                                  : Container(
                                      width: MediaQuery.of(context).size.width -
                                          40,
                                      height: 45.0,
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _showNewBenefits = false;
                                            });
                                            _disabledButtons
                                                ? ()
                                                : viewRewards();
                                          },
                                          child: Text('Awesome!',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayMedium))),
                            ),
                          ],
                        );
                      });
                },
              )))
        ]));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
