import 'package:exercisecoach/screens/bmi/result_bmi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class BMI extends StatefulWidget {
  const BMI({Key? key}) : super(key: key);

  @override
  State<BMI> createState() => _BMIState();
}

class _BMIState extends State<BMI> {
  bool isMale = true;
  double heightVal = 170;
  bool isCm = true;
  int weight = 55;
  int age = 18;

  double get heightInFeet => heightVal * 0.0328084;
  double get heightInCm => heightVal * 30.48;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'BMI CALCULATOR',
          style: TextStyle(
            color: Color(0xFF40D876),
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    m1Expanded('male'),
                    const SizedBox(
                      width: 15,
                    ),
                    m1Expanded('female'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF40D876), Color(0xFF28A745)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Height',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isCm
                                ? heightVal.toStringAsFixed(1)
                                : heightInFeet.toStringAsFixed(1),
                            style: const TextStyle(
                                fontSize: 45,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const Text(
                            ' ',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            isCm ? 'cm' : 'ft',
                            style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      Slider(
                        activeColor: Colors.white,
                        inactiveColor: Colors.white30,
                        min: isCm ? 90 : 3,
                        max: isCm ? 220 : 7.2,
                        value: isCm ? heightVal : heightInFeet,
                        onChanged: (newValue) {
                          setState(() {
                            if (isCm) {
                              heightVal = newValue;
                            } else {
                              heightVal = newValue / 0.0328084;
                            }
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'cm',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Switch(
                            value: isCm,
                            onChanged: (value) {
                              setState(() {
                                isCm = value;
                              });
                            },
                            activeColor: Colors.white,
                          ),
                          const Text(
                            'ft',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            'Weight',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          GestureDetector(
                            onTap: () {
                              _showPicker(context, 'weight');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF40D876), Color(0xFF28A745)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '$weight kg',
                                style: const TextStyle(
                                    fontSize: 45,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            'Age',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          GestureDetector(
                            onTap: () {
                              _showPicker(context, 'age');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF40D876), Color(0xFF28A745)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '$age',
                                style: const TextStyle(
                                    fontSize: 45,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF40D876), Color(0xFF28A745)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 16,
                child: TextButton(
                  onPressed: () {
                    var result = weight / pow(heightVal / 100, 2);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return ResultBMI(
                          age: age,
                          isMale: isMale,
                          result: result,
                        );
                      }),
                    );
                  },
                  child: const Text(
                    'Calculate',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20), // Add some bottom spacing
            ],
          ),
        ),
      ),
    );
  }

  Expanded m1Expanded(String gender) {
    return Expanded(
        child: GestureDetector(
        onTap: () {
      setState(() {
        isMale = gender == 'male' ? true : false;
      });
    },
    child: AnimatedContainer(
    duration: const Duration(milliseconds: 200),
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    gradient: (isMale && gender == 'male') || (!isMale && gender == 'female')
    ? const LinearGradient(
    colors: [Color(0xFF40D876), Color(0xFF28A745)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    )
    : LinearGradient(
    colors: [                    Colors.white24, Colors.white24],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3),
        ),
      ],
    ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            gender == 'male' ? Icons.male : Icons.female,
            color: Colors.white,
            size: 90,
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            gender == 'male' ? 'Male' : 'Female',
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
        ),
    );
  }

  Future<void> _showPicker(BuildContext context, String type) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.black,
          child: CupertinoPicker(
            backgroundColor: Colors.black,
            itemExtent: 32,
            onSelectedItemChanged: (int value) {
              setState(() {
                if (type == 'weight') {
                  weight = value + 30;
                } else {
                  age = value + 10;
                }
              });
            },
            children: List<Widget>.generate(
              100,
                  (int index) {
                return Text(
                  type == 'weight' ? '${index + 30} kg' : '${index + 10}',
                  style: const TextStyle(color: Colors.white),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Expanded m2Expanded(String type) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            type == 'age' ? 'Age' : 'Weight',
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            type == 'age' ? '$age' : '$weight',
            style: const TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                heroTag: type == 'age' ? 'age--' : 'weight--',
                onPressed: () => setState(() {
                  if (type == 'age') {
                    age = max(10, age - 1);
                  } else {
                    weight = max(30, weight - 1);
                  }
                }),
                mini: true,
                backgroundColor: const Color(0xFF40D876),
                child: const Icon(Icons.remove),
              ),
              const SizedBox(
                width: 10,
              ),
              FloatingActionButton(
                heroTag: type == 'age' ? 'age++' : 'weight++',
                onPressed: () => setState(() {
                  if (type == 'age') {
                    age++;
                  } else {
                    weight++;
                  }
                }),
                mini: true,
                backgroundColor: const Color(0xFF40D876),
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

