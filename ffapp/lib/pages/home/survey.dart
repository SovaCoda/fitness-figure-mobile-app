import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SurveyWidget extends StatefulWidget {
  const SurveyWidget({Key? key}) : super(key: key);

  @override
  _SurveyWidgetState createState() => _SurveyWidgetState();

}

class _SurveyWidgetState extends State<SurveyWidget> {
  List<int> answers = List.filled(10, 0);

  final List<String> questions = [
    'The figures I buy are cool and fun to collect.',
    'The evolutions are rewarding and diverse.',
    'The rewards are worth the time and effort.',
    'The game is easy to understand and play.',
    'The game is fun and engaging.',
    'The game is fair and balanced.',
    'The game is worth spending money on.',
    'The game is worth spending time on.',
    'The game is worth recommending to friends.',
    'The game is worth coming back to play again.',
  ];

  void setAnswer(int index, int answer) {
    answers[index] = answer;
  }

  void submitSurvey() {
    if (answers.contains(0)) {
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
    print(answers); // Send answers to server
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Thanks'),
            content: const Text('Thanks for taking the survey!'),
            actions: [
              TextButton(
                onPressed: () {
                  context.goNamed('Home');
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
                      Text(questions[index]),
                      OneThroughFiveSelector(question: questions[index], setAnswer: (int answer) => setAnswer(index, answer))
                    ],
                  );
                },
              ),
              
            ),
            SizedBox(height: 100),
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
  int answer;
  final question;
  void Function(int) setAnswer;
  OneThroughFiveSelector({Key? key, required this.question, required this.setAnswer}) : answer = 0, super(key: key);

  @override
  _OneThroughFiveSelectorState createState() => _OneThroughFiveSelectorState();
}

class _OneThroughFiveSelectorState extends State<OneThroughFiveSelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (int i = 1; i <= 5; i++)
            Center(
              child: Opacity(
                opacity: widget.answer == i ? 1 : 0.5,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      widget.answer = i;
                      widget.setAnswer(i);
                    });
                  },
                  child: Text(
                    i == 1 ? 'V. No' :
                    i == 2 ? 'No' :
                    i == 3 ? 'Neutral' :
                    i == 4 ? 'Yes' :
                    'V. Yes',
                   style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.primary),),
                ),
              ),
            ),
        ],
      ),
    );
  }
}