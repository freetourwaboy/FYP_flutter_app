import 'package:flutter/material.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:fyp/barcode/barcode.dart';
import 'package:fyp/utilty/barcode_painter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barcode Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Barcode Generator'),
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
  String raw = '';
  String? dropdownValue = 'QR Code';
  List<String> options = ['QR Code', 'Code128', 'Code39', 'EAN13', 'UPC'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3498DB),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
          height: MediaQuery.of(context).size.height * .85,
          width: MediaQuery.of(context).size.width * .9,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8, left: 8),
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
                  child: const Text('Rotation:'),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 16, left: 8),
                  child: const Text('Scale (width * height)'),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 16, left: 8),
                  child: const Text('Color:'),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 12, left: 8),
                  child: SizedBox(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    child: TextField(
                      controller: _textController,
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
                              border: Border.all(width: 1, color: Colors.grey),
                              borderRadius: BorderRadius.circular(3)),
                          margin: const EdgeInsets.only(top: 5, left: 8),
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 25, bottom: 36),
                          height: 180,
                          width: 300,
                          child: FutureBuilder(
                            future:
                                BarCode.encode(jsRunTime, dropdownValue!, raw),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<String>> snapshot) {
                              if (snapshot.hasData &&
                                  !snapshot.data![0]
                                      .split('\n')[0]
                                      .startsWith('Error')) {
                                return BarcodePainter(snapshot.data ?? ['']);
                              } else if (snapshot.hasData &&
                                  snapshot.data![0]
                                      .split('\n')[0]
                                      .startsWith('Error')) {
                                return Text(snapshot.data![0].split('\n')[0]);
                              }
                              return const Text('Text');
                            },
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
