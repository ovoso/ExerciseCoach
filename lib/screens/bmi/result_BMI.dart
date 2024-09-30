import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ResultBMI extends StatefulWidget {
  const ResultBMI(
      {Key? key, required this.result, required this.isMale, required this.age})
      : super(key: key);

  final double result;
  final bool isMale;
  final int age;

  @override
  _ResultBMIState createState() => _ResultBMIState();
}

class _ResultBMIState extends State<ResultBMI> {
  late FlutterTts flutterTts;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _speakResult();
    });
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  Future<void> _speak(String message) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(message);
  }

  String get resultphrase {
    String resultText = '';
    if (widget.result >= 30) {
      resultText = 'Obese';
    } else if (widget.result > 25 && widget.result < 30) {
      resultText = 'Overweight';
    } else if (widget.result >= 18.5 && widget.result <= 24.5) {
      resultText = 'Normal';
    } else {
      resultText = 'Thin';
    }
    return resultText;
  }

  Color get resultColor {
    if (widget.result >= 30) {
      return Colors.red;
    } else if (widget.result > 25 && widget.result < 30) {
      return Colors.orange;
    } else if (widget.result >= 18.5 && widget.result <= 24.5) {
      return Colors.green;
    } else {
      return Colors.yellow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'RESULT',
          style: TextStyle(color: Color(0xFF40D876)),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        widget.isMale ? Icons.male : Icons.female,
                        color: Color(0xFF40D876),
                        size: 100,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Gender: ${widget.isMale ? 'Male' : 'Female'}',
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Result: ${widget.result.toStringAsFixed(1)}',
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Healthiness: $resultphrase',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: resultColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Age: ${widget.age}',
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF40D876),
                    onPrimary: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Recalculate',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _speakResult() {
    String resultText = '';
    String recommendation = '';

    if (widget.result >= 30) {
      resultText = 'Obese';
      recommendation =
      'Your BMI indicates that you are obese. It is recommended to consult a healthcare provider for a suitable weight loss plan.';
    } else if (widget.result > 25 && widget.result < 30) {
      resultText = 'Overweight';
      recommendation =
      'Your BMI indicates that you are overweight. Consider a healthy diet and regular exercise to lose weight.';
    } else if (widget.result >= 18.5 && widget.result <= 24.5) {
      resultText = 'Normal';
      recommendation =
      'Your BMI is in the normal range. Maintain your current lifestyle to keep a healthy weight.';
    } else {
      resultText = 'Thin';
      recommendation =
      'Your BMI indicates that you are underweight. You might need to gain some weight. Consider a balanced diet and consult with a healthcare provider.';
    }

    String message =
        'Your BMI result is ${widget.result.toStringAsFixed(1)}, which is considered $resultText. $recommendation';
    _speak(message);
  }
}
