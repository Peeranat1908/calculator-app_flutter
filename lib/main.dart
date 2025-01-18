import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = "0"; // แสดงผลลัพธ์
  String _currentInput = "0"; // ค่าอินพุตปัจจุบัน
  String? _operator; // เก็บเครื่องหมายคำนวณ
  double? _firstOperand; // ตัวเลขตัวแรก

  // กดปุ่มคำนวณ
  void _buttonPressed(String value) {
    setState(() {
      if (value == "AC") {
        _output = "0";
        _currentInput = "0";
        _operator = null;
        _firstOperand = null;
      } else if (value == "⌫") {
        _currentInput = _currentInput.length > 1
            ? _currentInput.substring(0, _currentInput.length - 1)
            : "0";
        _output = _currentInput;
      } else if (value == "+" || value == "-" || value == "×" || value == "÷" || value == "%") {
        _firstOperand = double.tryParse(_currentInput) ?? 0.0;
        _operator = value;
        _currentInput = "0";
      } else if (value == "=") {
        if (_operator != null && _firstOperand != null) {
          double secondOperand = double.tryParse(_currentInput) ?? 0.0;
          double result = 0.0;
          switch (_operator) {
            case "+":
              result = _firstOperand! + secondOperand;
              break;
            case "-":
              result = _firstOperand! - secondOperand;
              break;
            case "×":
              result = _firstOperand! * secondOperand;
              break;
            case "÷":
              result = secondOperand != 0
                  ? _firstOperand! / secondOperand
                  : double.nan; // ห้ามหารด้วย 0
              break;
            case "%":
              result = _firstOperand! % secondOperand;
              break;
          }
          _output = result.toStringAsFixed(2).replaceAll(RegExp(r'\.00$'), '');
          _currentInput = _output;
          _operator = null;
          _firstOperand = null;
        }
      } else {
        if (_currentInput == "0") {
          _currentInput = value;
        } else {
          _currentInput += value;
        }
        _output = _currentInput;
      }
    });
  }

  // สร้างปุ่มใน UI
  Widget _buildButton(String value, Color color) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(20.0),
            backgroundColor: color,
          ),
          onPressed: () => _buttonPressed(value),
          child: Text(
            value,
            style: const TextStyle(fontSize: 24.0, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
            child: Text(
              _output,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  _buildButton("AC", Colors.grey),
                  _buildButton("⌫", Colors.grey),
                  _buildButton("%", Colors.grey),
                  _buildButton("÷", Colors.orange),
                ],
              ),
              Row(
                children: [
                  _buildButton("7", Colors.grey[850]!),
                  _buildButton("8", Colors.grey[850]!),
                  _buildButton("9", Colors.grey[850]!),
                  _buildButton("×", Colors.orange),
                ],
              ),
              Row(
                children: [
                  _buildButton("4", Colors.grey[850]!),
                  _buildButton("5", Colors.grey[850]!),
                  _buildButton("6", Colors.grey[850]!),
                  _buildButton("-", Colors.orange),
                ],
              ),
              Row(
                children: [
                  _buildButton("1", Colors.grey[850]!),
                  _buildButton("2", Colors.grey[850]!),
                  _buildButton("3", Colors.grey[850]!),
                  _buildButton("+", Colors.orange),
                ],
              ),
              Row(
                children: [
                  _buildButton("00", Colors.grey[850]!),
                  _buildButton("0", Colors.grey[850]!),
                  _buildButton(".", Colors.grey[850]!),
                  _buildButton("=", Colors.orange),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
