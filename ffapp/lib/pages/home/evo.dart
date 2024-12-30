import 'package:ffapp/components/animated_button.dart';
import 'package:ffapp/components/button_themes.dart';
import 'package:ffapp/components/resuables/gradiented_container.dart';
import 'package:ffapp/components/robot_image_holder.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/routes.pb.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ffapp/pages/home/survey.dart';
import 'package:ffapp/components/evolution_item.dart';
import 'package:ffapp/assets/data/figure_ev_data.dart';

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
  late Animation<double> _opacityAnimation;

  late AnimationController _flashController;
  late Animation<double> _flashAnimation;

  late FigureModel figure = FigureModel();
  int _evolutionCost = 0;
  bool _isAnimating = false;
  bool _showNewBenefits = false;
  bool _isEvolved = false;
  bool _disabledButtons = false;
  late AppBarAndBottomNavigationBarModel appBarAndBottomNavigationBar;

  @override
  void initState() {
    super.initState();
    auth = Provider.of<AuthService>(context, listen: false);
    figure = Provider.of<FigureModel>(context, listen: false);
    _evolutionCost = figure1.evCutoffs[figure.EVLevel];
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
      _evolutionCost = figure1.evCutoffs[figure.EVLevel];
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

  Future<bool> subtractEVPoints() async {
    FigureModel userFigure = Provider.of<FigureModel>(context, listen: false);
    int currentEVPoints = userFigure.figure!.evPoints;
    int updatedEVPoints = currentEVPoints - _evolutionCost;
    logger.i(
        "Attempting to make transaction of cost $_evolutionCost on current points $currentEVPoints");
    if (updatedEVPoints < 0) {
      logger.i("Not enough EV Points to complete transaction.");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Not enough EV Points to complete this purchase!")),
        );
        return false;
      }
    }
    userFigure.figure!.evPoints = updatedEVPoints;
    await auth.updateFigureInstance(userFigure.figure!);
    if (mounted) {
      Provider.of<CurrencyModel>(context, listen: false)
          .setCurrency(updatedEVPoints.toString());
    }
    return true;
  }

  double? usableScreenHeight;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onError.withOpacity(0.3),
      body: Stack(alignment: Alignment.center, children: [
        Center(child: Consumer<FigureModel>(
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
                            border: const Border(
                                bottom:
                                    BorderSide(color: Colors.white, width: 1)),
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
                                : MediaQuery.of(context).size.height * 0.4,
                            width: MediaQuery.of(context).size.width),
                      ),
                      _showNewBenefits
                          ? Center(
                              child: GradientedContainer(
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
                                      upgrades: figure1.figureEvUpgrades[figure
                                          .EVLevel], // Replace benefits with a variable list that contains the benefits of each evolution (figure_ev_data.dart?)
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Row(
                              children: [
                                EvolutionItem(
                                  title: 'EVO ${figure.EVLevel + 1}',
                                  upgrades: figure1.figureEvUpgrades[figure
                                      .EVLevel], // Replace benefits with a variable list that contains the benefits of each evolution (figure_ev_data.dart?)
                                ),
                                EvolutionItem(
                                  title: 'EVO ${figure.EVLevel + 2}',
                                  upgrades: figure1
                                      .figureEvUpgrades[figure.EVLevel + 1],
                                  isUnlocked:
                                      false, // Adds lock icon to next line
                                ),
                                // Add more EvolutionItem widgets as needed
                              ],
                            ),
                      Opacity(
                        opacity: _opacityAnimation.value ?? 0,
                        child: !_isEvolved
                            ? FFAppButton(
                                height: 75.0,
                                size: MediaQuery.sizeOf(context).width * 0.8,
                                text: "Evolve",
                                onPressed: () {
                                  setState(() {
                                    _isAnimating = true;
                                    _disabledButtons ? () : evolveFigure();
                                  });
                                })
                            : FFAppButton(
                                height: 75.0,
                                size: MediaQuery.sizeOf(context).width * 0.8,
                                text: "Evolve",
                                onPressed: () {
                                  setState(() {
                                    _showNewBenefits = false;
                                  });
                                  _disabledButtons ? () : viewRewards();
                                }),
                      ),
                    ],
                  );
                });
          },
        ))
      ]),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
