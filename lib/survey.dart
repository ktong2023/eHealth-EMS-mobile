import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'completion_page.dart';
import 'package:survey_kit/survey_kit.dart';

class SurveyPage extends StatefulWidget {
  final String name;
  const SurveyPage({Key? key, required this.name}) : super(key: key);

  @override
  _SurveyPageState createState() => _SurveyPageState(this.name);
}

class _SurveyPageState extends State<SurveyPage> {

  final String name;
  _SurveyPageState(this.name);

  Map<int, Color> color =
  {
    50:Color.fromRGBO(11,57,84, .1),
    100:Color.fromRGBO(11,57,84, .2),
    200:Color.fromRGBO(11,57,84, .3),
    300:Color.fromRGBO(11,57,84, .4),
    400:Color.fromRGBO(11,57,84, .5),
    500:Color.fromRGBO(11,57,84, .6),
    600:Color.fromRGBO(11,57,84, .7),
    700:Color.fromRGBO(11,57,84, .8),
    800:Color.fromRGBO(11,57,84, .9),
    900:Color.fromRGBO(11,57,84, 1),
  };

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Align(
          alignment: Alignment.center,
          child: FutureBuilder<Task>(
              future: getSurvey(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done
                    && snapshot.hasData && snapshot.data != null) {
                  final task = snapshot.data!;
                  return SurveyKit(
                    onResult: (SurveyResult result) {
                      List<List<String>> temp = [];
                      int score = 0;
                      String needs = '';
                      var res = result.results;
                      for (StepResult x in res) {
                        //print('x: $x');
                        var y = x.results;
                        for (QuestionResult<dynamic> z in y) {
                          //print("z: ${z.result}");
                          String work = z.valueIdentifier.toString();
                          List<String> list = work.split(',');
                          temp.add(list);
                          print(list);
                          for (String l in list) {
                            if (l.compareTo('5') == 0) score += 5;
                            if (l.compareTo('-5') == 0) score -= 5;
                            if (l.compareTo('10') == 0) score += 10;
                            if (l.compareTo('1') == 0) needs = 'A phone call';
                            if (l.compareTo('2') == 0) needs = 'A visit';
                            if (l.compareTo('3') == 0) needs = 'None';

                            if (l.compareTo('Aching all over') == 0) score += 5;
                            if (l.compareTo('A headache') == 0) score += 5;
                            if (l.compareTo('Nausea') == 0) score += 5;
                            if (l.compareTo('A new concern or problem that came back') == 0) score += 5;

                          }
                        }
                      }
                      print('score: $score');
                      print('needs: $needs');
                      print(temp);
                      Map<String, String> x = Map();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CompletionPage(score: score, needs: needs, name: this.name, quizResult: x),
                        ),
                      );
                    },
                    task: task,
                    showProgress: true,
                    localizations: {
                      'cancel': 'Cancel',
                      'next': 'Next',
                    },
                    themeData: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.fromSwatch(
                        primarySwatch: Colors.cyan,
                      ).copyWith(
                        onPrimary: Colors.white,
                      ),
                      primaryColor: Colors.cyan,
                      backgroundColor: Colors.white,
                      appBarTheme: const AppBarTheme(
                        color: Colors.white,
                        iconTheme: IconThemeData(
                          color: Colors.cyan,
                        ),
                        titleTextStyle: TextStyle(
                          color: Colors.cyan,
                        ),
                      ),
                      iconTheme: const IconThemeData(
                        color: Colors.cyan,
                      ),
                      textSelectionTheme: TextSelectionThemeData(
                        cursorColor: Colors.cyan,
                        selectionColor: Colors.cyan,
                        selectionHandleColor: Colors.cyan,
                      ),
                      cupertinoOverrideTheme: CupertinoThemeData(
                        primaryColor: Colors.cyan,
                      ),
                      outlinedButtonTheme: OutlinedButtonThemeData(
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(
                            Size(150.0, 60.0),
                          ),
                          side: MaterialStateProperty.resolveWith(
                                (Set<MaterialState> state) {
                              if (state.contains(MaterialState.disabled)) {
                                return BorderSide(
                                  color: Colors.grey,
                                );
                              }
                              return BorderSide(
                                color: Colors.cyan,
                              );
                            },
                          ),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          ),
                          textStyle: MaterialStateProperty.resolveWith(
                                  (Set<MaterialState> state) {
                                if (state.contains(MaterialState.disabled)) {
                                  return Theme.of(context).textTheme.button?.copyWith(
                                    color: Colors.grey,
                                  );
                                }
                                return Theme.of(context).textTheme.button?.copyWith(
                                  color: Colors.cyan,
                                );
                              }
                          ),
                        ),
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: ButtonStyle(
                          textStyle: MaterialStateProperty.all(
                            Theme.of(context).textTheme.button?.copyWith(
                              color: Colors.cyan,
                            ),
                          ),
                        ),
                      ),
                      textTheme: TextTheme(
                        headline2: TextStyle(
                          fontSize: 28.0,
                          color: Colors.black,
                        ),
                        headline5: TextStyle(
                          fontSize: 24.0,
                          color: Colors.black,
                        ),
                        bodyText2: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                        ),
                        subtitle1: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                        ),
                      ),
                      inputDecorationTheme: InputDecorationTheme(
                          labelStyle: TextStyle(
                            color: Colors.black,
                          )
                      ),
                    ),
                    surveyProgressbarConfiguration: SurveyProgressConfiguration(
                      backgroundColor: Colors.white,
                    ),
                  );
                } else {
                  return Text("You have done your survey.");
                }
                return Text("Done");
              },
            ),
          ),
        ),
    );
  }

  List<TextChoice> tc = [
    TextChoice(text: 'I am breathing well', value: '0'),
    TextChoice(text: 'I run out of breath when walking', value: '5'),
    TextChoice(text: 'I run out of breath when talking', value: '10'),
  ];
  int tcIdx = 0;
  int surveyIdx = 0;

  InstructionStep intro = InstructionStep(
    title: 'Welcome to the survey!',
    text: 'This will only take 5 minutes.',
    buttonText: 'Start',
  );


  Future<Task> getSurvey() {

    var task = NavigableTask(
      id: TaskIdentifier(),
      steps: [
        intro,
        QuestionStep(
            stepIdentifier: StepIdentifier(),
            title: 'How is your breathing?',
            text: 'Choose one option.',
            isOptional: false,
            answerFormat: SingleChoiceAnswerFormat(
              textChoices: tc,
              defaultSelection: tc[tcIdx],
            ),
            buttonText: 'Next'
        ),
        QuestionStep(
          stepIdentifier: StepIdentifier(),
            title: 'And this is:',
            text: 'Compare your breathing to yesterday.',
            isOptional: false,
            answerFormat: SingleChoiceAnswerFormat(
                textChoices: [
                  TextChoice(text: 'Better than yesterday', value: 'better'),
                  TextChoice(text: 'Same as yesterday', value: 'same'),
                  TextChoice(text: 'Worse than yesterday', value: 'worse'),
                ]
            )
        ),
        QuestionStep(
            title: 'How is your heart?',
            text: 'Choose one option.',
            isOptional: false,
            answerFormat: SingleChoiceAnswerFormat(
                textChoices: [
                  TextChoice(text: 'I feel great', value: '0'),
                  TextChoice(text: 'My heart is racing', value: '5'),
                  TextChoice(text: 'I have chest pain', value: '10'),
                ]
            )
        ),
        QuestionStep(
            title: 'How did you sleep last night?',
            text: 'Choose one option.',
            isOptional: false,
            answerFormat: SingleChoiceAnswerFormat(
                textChoices: [
                  TextChoice(text: 'I slept well last night', value: '0'),
                  TextChoice(text: 'My sleep was restless', value: '5'),
                  TextChoice(text: 'I had to use pillows to sit up in bed', value: '10'),
                ]
            ),
        ),
        QuestionStep(
            title: 'And this is:',
            text: 'Compare your sleep to yesterday.',
            isOptional: false,
            answerFormat: SingleChoiceAnswerFormat(
                textChoices: [
                  TextChoice(text: 'Better than yesterday', value: 'better'),
                  TextChoice(text: 'Same as yesterday', value: 'same'),
                  TextChoice(text: 'Worse than yesterday', value: 'worse'),
                ]
            )
        ),
        QuestionStep(
            title: 'How do you weigh today?',
            text: 'Choose one option.',
            isOptional: false,
            answerFormat: SingleChoiceAnswerFormat(
                textChoices: [
                  TextChoice(text: 'My weight went up 2 or more pounds since yesterday', value: '10'),
                  TextChoice(text: 'My clothes and shoes feel tight', value: '5'),
                  TextChoice(text: 'I can see swelling in my ankles', value: '5'),
                  TextChoice(text: 'My weight is the same or less than yesterday', value: '0'),
                ]
            )
        ),
        QuestionStep(
            title: 'And this is:',
            text: 'Compare your weight to yesterday.',
            isOptional: false,
            answerFormat: SingleChoiceAnswerFormat(
                textChoices: [
                  TextChoice(text: 'More than yesterday', value: 'better'),
                  TextChoice(text: 'Same as yesterday', value: 'same'),
                  TextChoice(text: 'Less than yesterday', value: 'worse'),
                ],
            )
        ),
        QuestionStep(
            title: 'I have:',
            text: 'Choose all that apply.',
            isOptional: false,
            answerFormat: MultipleChoiceAnswerFormat(
                textChoices: [
                  TextChoice(text: 'Aching all over', value: 'Aching all over'),
                  TextChoice(text: 'A headache', value: 'A headache'),
                  TextChoice(text: 'Nausea', value: 'Nausea'),
                  TextChoice(text: 'A new concern or problem that came back', value: 'A new concern or problem that came back'),
                  TextChoice(text: 'None of the above', value: 'None of the above'),
                ]
            )
        ),
        QuestionStep(
            title: 'Energy Level:',
            text: 'Choose one option.',
            isOptional: false,
            answerFormat: SingleChoiceAnswerFormat(
                textChoices: [
                  TextChoice(text: 'Better than yesterday', value: '-5'),
                  TextChoice(text: 'Same as yesterday', value: '0'),
                  TextChoice(text: 'Worse than yesterday', value: '5'),
                ]
            )
        ),
        QuestionStep(
            title: 'I feel like I need:',
            text: 'Choose one option.',
            isOptional: false,
            answerFormat: SingleChoiceAnswerFormat(
                textChoices: [
                  TextChoice(text: 'A phone call', value: '1'),
                  TextChoice(text: 'A visit', value: '2'),
                  TextChoice(text: 'Nothing! I\'m good today :)', value: '3'),
                ]
            )
        ),
        CompletionStep(
          stepIdentifier: StepIdentifier(id: '321'),
          text: 'Thank you',
          title: 'Done!',
          buttonText: 'Submit Survey',
        ),
      ],
    );

    task.addNavigationRule(
      forTriggerStepIdentifier: task.steps[1].stepIdentifier,
      navigationRule: ConditionalNavigationRule(
        resultToStepIdentifierMapper: (input) {
          String res = input.toString();
          print('input: $input');
          if (res.compareTo('0') == 0) {
            setState(() {
              tcIdx = 0;
            });
          }
          if (res.compareTo('5') == 0) {
            setState(() {
              tcIdx = 1;
            });
          }
          if (res.compareTo('10') == 0) {
            setState(() {
              tcIdx = 2;
            });
          }

          surveyIdx++;
          return task.steps[2].stepIdentifier;
        },
      ),
    );
    return Future.value(task);
  }
}

