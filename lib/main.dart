import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Talspiegel Rechner',
      theme: ThemeData(
          useMaterial3: false,
          primarySwatch: Colors.blue,
          fontFamily: GoogleFonts.openSans().fontFamily),
      home: const HomeScreen(),
    );
  }
}

// Widgets
class _InputTextBox extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final String name;

  const _InputTextBox(
      {Key? key,
      required this.controller,
      required this.onChanged,
      required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: TextField(
          onChanged: onChanged,
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),
          ], // Only numbers can be entered
          // TODO: text type
          decoration:
              InputDecoration(border: OutlineInputBorder(), labelText: name),
        ),
      ),
    );
  }
}

// Widgets Float
class _InputTextBoxFloat extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final String name;

  const _InputTextBoxFloat(
      {Key? key,
      required this.controller,
      required this.onChanged,
      required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: TextField(
          onChanged: onChanged,
          controller: controller,
          /* decoration: InputDecoration(
            labelText: name, */
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
            TextInputFormatter.withFunction((oldValue, newValue) {
              try {
                final text = newValue.text;
                if (text.isNotEmpty) double.parse(text);
                return newValue;
              } catch (e) {}
              return oldValue;
            }),
          ], // Only numbers can be entered
          // TODO: text type
          decoration:
              InputDecoration(border: OutlineInputBorder(), labelText: name),
        ),
      ),
    );
  }
}

class Medikation {
  String medikation = 'Abilify';
  int halbwertszeit = 75;
  Medikation(this.medikation, this.halbwertszeit);
}

// Screens
class HomeScreen extends StatefulWidget {
  final List<String> dropdownItems;

  const HomeScreen(
      {Key? key,
      this.dropdownItems = const [
        Medikation.medikation,
        'Medikament 2',
        'Medikament 3'
      ]})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController textfield1 = TextEditingController();
  TextEditingController textfield2 = TextEditingController();
  TextEditingController textfield3 = TextEditingController();

  late String dropdownValue;

  @override
  void initState() {
    dropdownValue = widget.dropdownItems.first;
    super.initState();
  }

  double calculate() {
    double ct = double.tryParse(textfield3.text) ?? 0;
    const double e = 2.718281828459045;
    int halbwertszeit = 33;
    double negke = (0.6931471805599453 / halbwertszeit) * -1;
    double tmin = double.tryParse(textfield1.text) ?? 0;
    double t = double.tryParse(textfield2.text) ?? 0;
    return (ct * pow(e, (negke * (tmin - t))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Talspiegel-Rechner')),
        ),
        body: FractionallySizedBox(
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    DropdownButton(
                        value: dropdownValue,
                        items: widget.dropdownItems.map((el) {
                          return DropdownMenuItem(
                            child: Text(el),
                            value: el,
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            dropdownValue = val!;
                          });
                        }),
                    Row(
                      children: [
                        _InputTextBox(
                            controller: textfield1,
                            onChanged: (p0) {
                              setState(() {});
                            },
                            name: 'Max. Talspiegel in h'),
                        _InputTextBox(
                            controller: textfield2,
                            onChanged: (p0) {
                              setState(() {});
                            },
                            name: 'Abnahme Zeitpunkt in h'),
                        _InputTextBoxFloat(
                            controller: textfield3,
                            onChanged: (p0) {
                              setState(() {});
                            },
                            name: 'Konzentration bei Abnahme in ng/ml')
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Text(
                    'Talspiegel: ${calculate().toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )));
  }
}
