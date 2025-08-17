import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class ModeScreen extends StatefulWidget {
  const ModeScreen({super.key});

  @override
  State<ModeScreen> createState() => _ModeScreenState();
}

class _ModeScreenState extends State<ModeScreen> {
  bool showCalculator = false;
  String expression = '';
  String result = '';

  void numClick(String text) {
    setState(() {
      if (text == '⌫') {
        if (expression.isNotEmpty) {
          expression = expression.substring(0, expression.length - 1);
        }
      } else if (text == '%') {
        expression += '/100';
      } else {
        expression += text;
      }
    });
  }

  void clear() {
    setState(() {
      expression = '';
      result = '';
    });
  }

  void calculate() {
    try {
      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      setState(() {
        result = eval % 1 == 0 ? eval.toInt().toString() : eval.toString();
      });
    } catch (e) {
      setState(() {
        result = 'Error';
      });
    }
  }

  Widget buildButton(String text,
      {Color bgColor = const Color(0xFF00BCD4),
        Color textColor = Colors.white,
        VoidCallback? onTap}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: SizedBox(
          height: 60,
          child: ElevatedButton(
            onPressed: onTap ?? () => numClick(text),
            style: ElevatedButton.styleFrom(
              backgroundColor: bgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(text, style: TextStyle(fontSize: 20, color: textColor)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // <- removes back button
      ),
      body: showCalculator
          ? Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(result,
                      style: const TextStyle(
                          fontSize: 42,
                          color: Colors.cyan,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(expression,
                      style: const TextStyle(
                          fontSize: 28, color: Colors.white)),


                ],
              ),
            ),
          ),
          Column(
            children: [
              Row(children: [
                buildButton('AC', bgColor: Colors.cyan, onTap: clear),
                buildButton('⌫', bgColor: Colors.cyan),
                buildButton('%'),
                buildButton('/'),
              ]),
              Row(children: [
                buildButton('7'),
                buildButton('8'),
                buildButton('9'),
                buildButton('*'),
              ]),
              Row(children: [
                buildButton('4'),
                buildButton('5'),
                buildButton('6'),
                buildButton('-'),
              ]),
              Row(children: [
                buildButton('1'),
                buildButton('2'),
                buildButton('3'),
                buildButton('+'),
              ]),
              Row(children: [
                buildButton('0'),
                buildButton('.'),
                buildButton('('),
                buildButton(')'),
              ]),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: ElevatedButton(
                        onPressed: clear,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        child: const Text('CLEAR',
                            style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: ElevatedButton(
                        onPressed: calculate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('=',
                            style: TextStyle(fontSize: 15)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: themeProvider.themeMode == ThemeMode.dark,
              onChanged: (_) => themeProvider.toggleTheme(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showCalculator = true;
                });
              },
              child: const Text('Open Calculator'),
            ),
          ],
        ),
      ),
    );
  }
}
