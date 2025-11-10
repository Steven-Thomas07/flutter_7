import 'package:flutter/material.dart';

void main() {
  runApp(const BMICalculatorApp());
}

class BMICalculatorApp extends StatelessWidget {
  const BMICalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BMI Calculator',
      home: BMICalculatorScreen(),
    );
  }
}

class BMICalculatorScreen extends StatefulWidget {
  const BMICalculatorScreen({super.key});

  @override
  State<BMICalculatorScreen> createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _ageController = TextEditingController();

 // Removed dropdown gender
  double? _bmi;
  String? _bmiStatus;
  int? _age;
  String? _gender;

  void _calculateBMI() {
    if (_formKey.currentState!.validate()) {
      double height = double.parse(_heightController.text);
      double weight = double.parse(_weightController.text);
      int age = int.parse(_ageController.text);
      String gender = _gender ?? "";
 
      double bmi = weight / ((height / 100) * (height / 100));
      String status;
      if (bmi < 18.5) {
        status = "Underweight";
      } else if (bmi < 25) {
        status = "Normal weight";
      } else if (bmi < 30) {
        status = "Overweight";
      } else {
        status = "Obese";
      }

      setState(() {
        _bmi = bmi;
        _bmiStatus = status;
        _age = age;
        _gender = gender;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BMI Calculator"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _heightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Height (cm)",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter height";
                      }
                      if (double.tryParse(value) == null ||
                          double.parse(value) <= 0) {
                        return "Enter valid height > 0";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Weight (kg)",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter weight";
                      }
                      if (double.tryParse(value) == null ||
                          double.parse(value) <= 0) {
                        return "Enter valid weight > 0";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Age",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter age";
                      }
                      if (int.tryParse(value) == null ||
                          int.parse(value) <= 0) {
                        return "Enter valid age > 0";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Gender",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter gender";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _calculateBMI,
                    child: const Text("Calculate BMI"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (_bmi != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        "Age: $_age",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Gender: $_gender",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "BMI: ${_bmi!.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        "Status: $_bmiStatus",
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}