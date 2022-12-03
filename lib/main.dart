// Packages
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

// Models
import 'models.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [const Locale('de')],
      title: 'Talspiegel Rechner',
      theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
              backgroundColor: Color.fromRGBO(142, 202, 230, 1.0)),
          colorScheme: ColorScheme.fromSwatch(
              backgroundColor: const Color.fromRGBO(142, 202, 230, 1.0)),
          fontFamily: GoogleFonts.openSans().fontFamily),
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
  final EdgeInsetsGeometry padding;
  final String? unit;
  final String name;
  final int maxlength;

  const _InputTextBox(
      {Key? key,
      required this.controller,
      required this.onChanged,
      required this.name,
      this.inputFormatters,
      this.unit,
      required this.maxlength,
      this.keyboardType = TextInputType.number,
      this.padding = const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextField(
        maxLength: maxlength,
        onChanged: onChanged,
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            counterText: "",
            suffixText: unit,
            label: Text(name,
                style: const TextStyle(fontSize: 16, color: Colors.blueGrey))),
      ),
    );
  }
}

/* class _InputDateBox extends StatelessWidget {
  final void Function(DateTime)? onSelected;
  final String name;

  const _InputDateBox({
    Key? key,
    required this.onSelected,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
        child: DateTimeFormField(
            use24hFormat: true,
            decoration: const InputDecoration(
              hintStyle: TextStyle(color: Colors.black45),
              errorStyle: TextStyle(color: Colors.redAccent),
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.event_note),
              labelText: 'Med.-Verabreichung',
            ),
            mode: DateTimeFieldPickerMode.dateAndTime,
            autovalidateMode: AutovalidateMode.always,
            validator: (e) =>
                (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
            onDateSelected: onSelected));
  }
} */

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
  TextEditingController spiegelabn = TextEditingController();
  DateTime gabe = DateTime.now();
  DateTime abnahme = DateTime.now();

  List<Medication?> dropdownItems = [
    null,
    Medication(name: 'Amisulprid', mintal: 24, hlf: 15),
    Medication(name: 'Aripiprazol-oral', mintal: 24, hlf: 70),
    Medication(name: 'Aripiprazol-i.m.', mintal: 24, hlf: 38),
    Medication(name: 'Asenapin', mintal: 24, hlf: 20),
    Medication(name: 'Benperidol', mintal: 24, hlf: 5),
    Medication(name: 'Chlorprothixen', mintal: 24, hlf: 10),
    Medication(name: 'Clozapin', mintal: 24, hlf: 12),
    Medication(name: 'Flupentixol', mintal: 24, hlf: 30),
    Medication(name: 'Fluphenazin-oral', mintal: 24, hlf: 16),
    Medication(name: 'Fluspirilen', mintal: 24, hlf: 192),
    Medication(name: 'Haloperidol-oral', mintal: 24, hlf: 17),
    Medication(name: 'Haloperidol-depot', mintal: 24, hlf: 504),
    Medication(name: 'Levomepromazin', mintal: 24, hlf: 24),
    Medication(name: 'Loxapin', mintal: 24, hlf: 7),
    Medication(name: 'Lurasidon', mintal: 24, hlf: 25),
    Medication(name: 'Melperon', mintal: 24, hlf: 5),
    Medication(name: 'Olanzapin-', mintal: 24, hlf: 33),
    Medication(name: 'Paliperidon', mintal: 24, hlf: 720),
    Medication(name: 'Perazin', mintal: 24, hlf: 12),
    Medication(name: 'Pipamperon', mintal: 24, hlf: 19),
    Medication(name: 'Prothipendyl', mintal: 24, hlf: 2),
    Medication(name: 'Quetiapin', mintal: 24, hlf: 8),
    Medication(name: 'Risperidon', mintal: 24, hlf: 3),
    Medication(name: 'Sertindol', mintal: 24, hlf: 70),
    Medication(name: 'Ziprasidon', mintal: 24, hlf: 6),
  ];
  Medication? dropdownValue;

  @override
  void initState() {
    super.initState();
  }

  String calculate() {
    Duration diff = abnahme.difference(gabe);
    int t = diff.inHours < 0 ? -1 : diff.inHours;
    if (t == -1) return ('Zeiten kontrollieren');
    int halflife = int.tryParse(textfield4.text) ?? 1;
    double ct = double.tryParse(textfield3.text.replaceAll(',', '.')) ?? 0;
    double tmin = double.tryParse(textfield1.text) ?? 0;
    double negke = (ln2 / halflife) * -1;
    double result = ct * pow(e, (negke * (tmin - t)));
    if (result > 99999) return ("out of bound");
    return (result.toStringAsFixed(2) + 'ng/ml');
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
            title: Text(context.findAncestorWidgetOfExactType<Title>()?.title ??
                "Talspiegel-Rechner"),
            actions: [
              // About Page
              CupertinoButton(
                  padding: const EdgeInsets.all(13.0),
                  child: const Icon(Icons.info_outline_rounded),
                  onPressed: () => showAboutDialog(
                      context: context,
                      // applicationIcon: ,
                      applicationVersion: "V1.0",
                      applicationLegalese: "This app is free to use"))
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
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Medikament:",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                      borderRadius: BorderRadius.circular(12),
                                      menuMaxHeight: 300,
                                      value: dropdownValue,
                                      selectedItemBuilder:
                                          (BuildContext context) {
                                        return dropdownItems
                                            .map((Medication? medication) {
                                          return Container(
                                              width: 90,
                                              margin: const EdgeInsets.only(
                                                  left: 13),
                                              alignment: Alignment.center,
                                              child: medication != null
                                                  ? Text(medication.name,
                                                      overflow:
                                                          TextOverflow.ellipsis)
                                                  : const Text("Standard",
                                                      overflow: TextOverflow
                                                          .ellipsis));
                                        }).toList();
                                      },
                                      items: dropdownItems
                                          .map((Medication? medication) {
                                        return DropdownMenuItem(
                                            value: medication,
                                            child: medication != null
                                                ? Text(medication.name,
                                                    overflow:
                                                        TextOverflow.visible)
                                                : const Text("Standard",
                                                    overflow:
                                                        TextOverflow.ellipsis));
                                      }).toList(),
                                      onChanged: (Medication? val) {
                                        setState(() {
                                          textfield4.text = '${val?.hlf ?? ""}';
                                          textfield1.text =
                                              '${val?.mintal ?? ""}';
                                          dropdownValue = val;
                                        });
                                      }),
                                ),
                                Expanded(
                                  child: _InputTextBox(
                                    controller: textfield4,
                                    maxlength: 3,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    onChanged: (p0) => setState(() {
                                      dropdownValue = null;
                                    }),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r"[0-9]"))
                                    ],
                                    name: 'HWZ',
                                    unit: 'h',
                                  ),
                                ),
                              ])),
                      Row(
                        children: [
                          Expanded(
                            child: _InputTextBox(
                                controller: textfield1,
                                maxlength: 3,
                                onChanged: (p0) => setState(() {}),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r"[0-9]"))
                                ],
                                name: 'Min. Talspiegel in h',
                                unit: 'h'),
                          ),
                          Expanded(
                            child: _InputTextBox(
                                controller: textfield3,
                                maxlength: 5,
                                onChanged: (p0) => setState(() {}),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'(^\d*(\,|\.)?\d*)'))
                                ],
                                name: 'Konzentration bei Abnahme',
                                unit: 'ng/ml'),
                          ),
                        ],
                      ),
                      Row(children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 10.0),
                            child: TextField(
                                controller: textfield2,
                                keyboardType: TextInputType.none,
                                onChanged: (p0) => setState(() {}),
                                onTap: () {
                                  DatePicker.showDateTimePicker(context,
                                      showTitleActions: true,
                                      theme: const DatePickerTheme(
                                          headerColor: Colors.blue,
                                          backgroundColor: Colors.blue,
                                          itemStyle: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                          doneStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16)),
                                      onConfirm: (date) => setState(() {
                                            gabe = date;
                                            if (date.compareTo(abnahme) > 0) {
                                              textfield2.text = 'kontrollieren';
                                              return;
                                            }
                                            textfield2.text =
                                                DateFormat('dd/MM/yyyy–kk:mm')
                                                    .format(date);
                                            spiegelabn.text =
                                                DateFormat('dd/MM/yyyy–kk:mm')
                                                    .format(abnahme);
                                          }),
                                      currentTime: DateTime.now(),
                                      locale: LocaleType.de);
                                },
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    label: Text('Med.-Gabe'))),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 10.0),
                            child: TextField(
                                controller: spiegelabn,
                                keyboardType: TextInputType.none,
                                onChanged: (p0) => setState(() {}),
                                onTap: () {
                                  DatePicker.showDateTimePicker(context,
                                      showTitleActions: true,
                                      theme: const DatePickerTheme(
                                          headerColor: Colors.blue,
                                          backgroundColor: Colors.blue,
                                          itemStyle: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                          doneStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16)),
                                      onConfirm: (date) => setState(() {
                                        abnahme = date;
                                        if (gabe.compareTo(date) > 0) {
                                              spiegelabn.text = 'kontrollieren';
                                              return;
                                            }
                                        textfield2.text =
                                                DateFormat('dd/MM/yyyy–kk:mm')
                                                    .format(gabe);
                                            spiegelabn.text =
                                                DateFormat('dd/MM/yyyy–kk:mm')
                                                    .format(date);

                                          }),
                                      currentTime: DateTime.now(),
                                      locale: LocaleType.de);
                                },
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    label: Text('Spiegel-Abnahme'))),
                          ),
                        ),
                      ])
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: Text(
                      'Talspiegel: ${calculate()}',
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ))),
    );
  }
}
