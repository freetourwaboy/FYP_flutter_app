import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp/barcode/barcode.dart';
import 'package:fyp/utilty/barcode_painter.dart';
import 'package:fyp/utilty/downloader.dart';
import 'package:provider/provider.dart';

import 'model/button_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ButtonModel(),
      child: MaterialApp(
        title: 'Barcode Generator',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Barcode Generator'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final JavascriptRuntime jsRunTime = getJavascriptRuntime();
  final _textController = TextEditingController();
  final _heightField = TextEditingController(text: "117");
  final _widthField = TextEditingController(text: "214");
  final GlobalKey<_MyHomePageState> _paintKey = GlobalKey();

  String raw = '';
  String? dropdownValue = 'QR Code';
  String? _selectedDegree = '0';
  List<String> options = ['QR Code', 'Code128', 'Code39', 'EAN13', 'UPC'];
  List<String> degress = ['0', '90', '180', '270'];
  Size size = Size.infinite;
  Color barPickerColor = Colors.black; // initial color
  Color barCurrentColor = Colors.black; // upda
  Color bgPickerColor = Colors.white; // initial color
  Color bgCurrentColor = Colors.white; // upda

  @override
  Widget build(BuildContext context) {
    final buttonModel = Provider.of<ButtonModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF3498DB),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
          height: MediaQuery.of(context).size.height * .9,
          width: MediaQuery.of(context).size.width * .9,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  child: const Text(
                    'Barcode Generator',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8, left: 8),
                  child: const Text(
                    'Select barcode type to create barcode',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  child: Row(
                    children: [
                      Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: const Text('Barcode Type:')),
                      DropdownButton<String>(
                        value: dropdownValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        items: options
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: const TextStyle(fontSize: 13)),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                ),
                Container(
                    margin: const EdgeInsets.only(left: 8),
                    child: Row(children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Text('Rotation:'),
                      ),
                      DropdownButton<String>(
                        value: _selectedDegree,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedDegree = value;
                          });
                        },
                        items: degress
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text("$value°",
                                style: const TextStyle(fontSize: 13)),
                          );
                        }).toList(),
                      )
                    ])),
                Container(
                  margin: const EdgeInsets.only(top: 16, left: 8),
                  child: Row(
                    children: [
                      const Text('Scale (width * height): '),
                      Container(
                        margin: const EdgeInsets.only(right: 5),
                        height: 32,
                        width: 50,
                        child: TextField(
                          style: const TextStyle(fontSize: 13),
                          textAlignVertical: TextAlignVertical.center,
                          controller: _widthField,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 32,
                        width: 50,
                        child: TextField(
                          style: const TextStyle(fontSize: 13),
                          controller: _heightField,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 16, left: 8),
                  child: Row(
                    children: [
                      const Text('Color:'),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize: Size(10, 20),
                                backgroundColor: barCurrentColor),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Pick a color!'),
                                    content: SingleChildScrollView(
                                      child: ColorPicker(
                                        pickerColor: barPickerColor,
                                        onColorChanged: (Color color) {
                                          setState(() {
                                            barPickerColor = color;
                                          });
                                        },
                                        pickerAreaHeightPercent: 0.8,
                                      ),
                                    ),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        child: const Text('CANCEL'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      ElevatedButton(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          setState(() {
                                            barCurrentColor = barPickerColor;
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text('')),
                      ),
                      const Text('Back: '),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize: const Size(10.0, 20.0),
                                backgroundColor: bgCurrentColor),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Pick a color!'),
                                    content: SingleChildScrollView(
                                      child: ColorPicker(
                                        pickerColor: bgPickerColor,
                                        onColorChanged: (Color color) {
                                          setState(() {
                                            bgPickerColor = color;
                                          });
                                        },
                                        pickerAreaHeightPercent: 0.8,
                                      ),
                                    ),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        child: const Text('CANCEL'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      ElevatedButton(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          setState(() {
                                            bgCurrentColor = bgPickerColor;
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text('')),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 12, left: 8),
                  child: SizedBox(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    child: TextField(
                      controller: _textController,
                      textAlignVertical: TextAlignVertical.bottom,
                      decoration: const InputDecoration(
                        hintText: 'Enter text or url',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 12, left: 8, bottom: 20),
                  child: SizedBox(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          raw = _textController.text;
                          size = Size(double.parse(_widthField.text),
                              double.parse(_heightField.text));
                        });
                      },
                      child: const Text('Generate Barcode'),
                    ),
                  ),
                ),
                raw != ''
                    ? Center(
                        child: Container(
                          decoration: BoxDecoration(
                              color: bgCurrentColor,
                              border: Border.all(width: 1, color: Colors.grey),
                              borderRadius: BorderRadius.circular(3)),
                          margin: const EdgeInsets.only(top: 5, left: 8),
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 25, bottom: 36),
                          height: 220,
                          width: 300,
                          child: FutureBuilder(
                            future: BarCode.encode(
                                context, jsRunTime, dropdownValue!, raw),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<String>> snapshot) {
                              if (snapshot.hasData &&
                                  !snapshot.data![0]
                                      .split('\n')[0]
                                      .startsWith('Error')) {
                                return RepaintBoundary(
                                  key: _paintKey,
                                  child: Transform.rotate(
                                    angle: double.parse(_selectedDegree!) *
                                        pi /
                                        180,
                                    child: BarcodePainter(snapshot.data ?? [''],
                                        size, barCurrentColor),
                                  ),
                                );
                              } else if (snapshot.hasData &&
                                  snapshot.data![0]
                                      .split('\n')[0]
                                      .startsWith('Error')) {
                                return Center(
                                    child: Text(
                                  snapshot.data![0].split('\n')[0],
                                  style: const TextStyle(color: Colors.red),
                                ));
                              }
                              return const Text('Text');
                            },
                          ),
                        ),
                      )
                    : Container(),
                buttonModel.haveCode
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10, left: 8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            captureCanvas(_paintKey);
                            Fluttertoast.showToast(
                              msg: "Download sucessful!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.grey[600],
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          },
                          child: const Text('Download'),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
