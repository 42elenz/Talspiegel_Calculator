// Packages
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

// Models
import 'models.dart';

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
        useMaterial3: true,
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromRGBO(142, 202, 230, 1.0)
        ),
        colorScheme: ColorScheme.fromSwatch(
          backgroundColor: const Color.fromRGBO(142, 202, 230, 1.0)
        ),
        fontFamily: GoogleFonts.openSans().fontFamily
      ),
      home: const HomeScreen(),
    );
  }
}

// Widgets
class _InputTextBox extends StatelessWidget {
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final String? unit;
  final String name;

  const _InputTextBox({Key? key, required this.controller, required this.onChanged, required this.name, this.inputFormatters, this.unit, this.keyboardType = TextInputType.number}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: TextField(
        onChanged: onChanged,
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          border: const OutlineInputBorder(), 
          labelText: name,
          suffixText: unit
        ),
      ),
    );
  }
}

// Screens
class HomeScreen extends StatefulWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController textfield1 = TextEditingController();
  TextEditingController textfield2 = TextEditingController();
  TextEditingController textfield3 = TextEditingController();
  TextEditingController textfield4 = TextEditingController();

  List<Medication?> dropdownItems = [
    null,
    Medication(
      name: 'Abilify',
      value: 10
    ),
    Medication(
      name: 'Risperidon',
      value: 11
    ),
    Medication(
      name: 'Olanzapin',
      value: 12
    )
  ];
  Medication? dropdownValue;

  @override
  void initState() {
    super.initState();
  }

  double calculate() {
    int halflife = int.tryParse(textfield4.text) ?? 33;
    double t = double.tryParse(textfield2.text) ?? 0;
    double ct = double.tryParse(textfield3.text.replaceAll(',', '.')) ?? 0;
    double tmin = double.tryParse(textfield1.text) ?? 0;
    double negke = (ln2 / halflife) * -1;
    return (ct * pow(e, (negke * (tmin - t))));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.findAncestorWidgetOfExactType<Title>()?.title ?? "Talspiegel-Rechner"),
          actions: [
            // About Page
            CupertinoButton(
              padding: const EdgeInsets.all(13.0),
              child: const Icon(Icons.info_outline_rounded),
              onPressed: () => showAboutDialog(
                context: context,
                // applicationIcon: ,
                applicationVersion: "V1.0",
                applicationLegalese: "This app is free to use"
              )
            )
          ],
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
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Medikament:", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 13),
                        DropdownButton(
                          underline: Container(),
                          borderRadius: BorderRadius.circular(12),
                          menuMaxHeight: 300,
                          value: dropdownValue,
                          // hint: const Text("Medikament auswählen"),
                          items: dropdownItems.map((Medication? medication) {
                            return DropdownMenuItem(
                              value: medication,
                              child: medication != null ? Text('${medication.name} - ${medication.value}') : const Text("Standard")
                            );
                          }).toList(),
                          onChanged: (Medication? val) {
                            setState(() {
                              textfield4.text = '${val?.value ?? ""}';
                              dropdownValue = val;
                            });
                          }
                        ),
                        Expanded(
                          child: _InputTextBox(
                            controller: textfield4,
                            onChanged: (p0) => setState(() {
                              dropdownValue = null;
                            }),
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[0-9]"))],
                            name: 'Halbwertszeit',
                            unit: 'h'
                          ),
                        ),
                      ]
                    )
                  ),
                  _InputTextBox(
                    controller: textfield1,
                    onChanged: (p0) => setState(() {}),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[0-9]"))],
                    name: 'Max. Talspiegel',
                    unit: 'h'
                  ),
                  _InputTextBox(
                    controller: textfield2,
                    onChanged: (p0) => setState(() {}),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[0-9]"))],
                    name: 'Abnahme Zeitpunkt',
                    unit: 'h'
                  ),
                  _InputTextBox(
                    controller: textfield3,
                    onChanged: (p0) => setState(() {}),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'(^\d*\,?\d*)'))],
                    name: 'Konzentration bei Abnahme',
                    unit: 'ng/ml'
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(
                  'Talspiegel: ${calculate().toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              )
            ],
          )
        )
      ),
    );
  }
}
