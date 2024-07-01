import 'package:ffapp/main.dart';
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/routes.pb.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SurveyWidget extends StatefulWidget {
  const SurveyWidget({super.key});

  @override
  _SurveyWidgetState createState() => _SurveyWidgetState();

}

class _SurveyWidgetState extends State<SurveyWidget> {
  late AuthService auth;

  final Map<String, String> questions = {
    'The figures I buy are cool and fun to collect.': '',
    'The evolutions are meaningful and rewarding.': '',
    'My figure and the app keep me coming back to workout.': '',
    'The app is easy to use and navigate.': '',
    'The app is visually appealing.': '',
    'Currency is rewarding': '',
  };

  @override
  void initState() {
    super.initState();
    auth = Provider.of<AuthService>(context, listen: false);
  }

  // Function that takes in a map of Strings to Strings and stores them as survey responses
  bool storeSurveyAnswers(Map<String, String> answers) {
    List<SurveyResponse> responses = [];
    answers.forEach((key, value) {
      SurveyResponse response = SurveyResponse();
      response.question = key;
      response.answer = value;
      response.email = Provider.of<UserModel>(context, listen: false).user?.email ?? '';
      response.date = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      responses.add(response);
    });
    MultiSurveyResponse response = MultiSurveyResponse(surveyResponses: responses);
    auth.createSurveyResponseMulti(response);
    return false;
  }

  void setAnswer(String question, String answer) {
    questions[question] = answer;
  }

  void submitSurvey() {
    if (questions.containsValue('')) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Survey'),
            content: const Text('Please answer all questions before submitting.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
      return;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Thanks'),
            content: const Text('Thanks for taking the survey!'),
            actions: [
              TextButton(
                onPressed: () async {
                  storeSurveyAnswers(questions);
                  context.goNamed('Home');
                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setBool('hasSurveyed', true);
                },
                child: const Text('Back'),
              ),
            ],
          );
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Survey'),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center( // Add Center widget here
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Text(questions.keys.elementAt(index)),
                      OneThroughFiveSelector(question: questions[index], setAnswer: (String answer) => setAnswer(questions.keys.elementAt(index), answer))
                    ],
                  );
                },
              ),
              
            ),
            const SizedBox(height: 100),
            ElevatedButton(
              onPressed: submitSurvey,
              child: const Text('Submit'),
            ),
          ],
          
        ),
      ),
    );
  }
}

class OneThroughFiveSelector extends StatefulWidget {
  String answer;
  int _answer;
  final question;
  void Function(String) setAnswer;
  bool columned;
  OneThroughFiveSelector({Key? key, required this.question, required this.setAnswer}) : _answer = 0, answer = '', columned=false, super(key: key);

  @override
  _OneThroughFiveSelectorState createState() => _OneThroughFiveSelectorState();
}

class _OneThroughFiveSelectorState extends State<OneThroughFiveSelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.columned ? Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (int i = 1; i <= 5; i++)
            Center(
              child: Opacity(
                opacity: widget._answer == i ? 1 : 0.5,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      widget._answer = i;
                      widget.setAnswer(i.toString());
                    });
                  },
                  child: Text(
                    i == 1 ? 'V. No' :
                    i == 2 ? 'No' :
                    i == 3 ? 'Neutral' :
                    i == 4 ? 'Yes' :
                    'V. Yes',
                   style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Theme.of(context).colorScheme.primary),),
                ),
              ),
            ),
        ],
      ) : 
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (int i = 1; i <= 5; i++)
            Center(
              child: Opacity(
                opacity: widget._answer == i ? 1 : 0.5,
                child: ElevatedButton(
                  
                  onPressed: () {
                    setState(() {
                      widget._answer = i;
                      widget.setAnswer(i.toString());
                    });
                  },
                  child: Text(
                    i == 1 ? 'V. No' :
                    i == 2 ? 'No' :
                    i == 3 ? 'Neutral' :
                    i == 4 ? 'Yes' :
                    'V. Yes',
                   style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Theme.of(context).colorScheme.primary),),
                ),
              ),
            ),
        ],
      ),
    );
  }
}