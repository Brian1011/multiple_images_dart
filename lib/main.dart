import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_images/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    sendMultipleImages();
  }

  sendMultipleImages() async {
    List<MultipartFile> images = [];

    // get images from assets folder and add to images list
    File file = await getImageFileFromAssets('la_city.jpeg');
    File file2 = await getImageFileFromAssets('nairobi_city.jpeg');

    MultipartFile multipartFile1 =
        MultipartFile.fromFileSync(file.path, filename: "image1");
    MultipartFile multipartFile2 =
        MultipartFile.fromFileSync(file2.path, filename: "image2");

    print('**********************images*****************');
    print(images);

    UserData userOne = UserData(
      id: 1,
      name: "John Doe",
      images: [multipartFile1],
    );
    UserData userTwo =
        UserData(id: 1, name: "Jane Doe", images: [multipartFile2]);

    List<UserData> users = [userOne, userTwo];
    print('**********************user*****************');
    print(userOne.toJson());

    var data = {"data": 1, "entries": userOne.toJson()};

    var data2 = {'data': 2, "entries": userTwo.toJson()};

    var data3 = {
      'images': [data, data2],
    };

    FormData formData = FormData.fromMap(data3);

    print('**********************formData*****************');
    print(data3);
    print(formData.fields);
    print(formData.files);

    // send data to server using dio
    Dio dio = Dio();
    await dio
        .post("http://localhost:8000/api/upload", data: formData)
        .then((response) {
      print('**********************response*****************');
      print(response.data);
    }).catchError((error) {
      print('**********************error*****************');
      print(error.toString());
    });
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            // asset image
            Image.asset(
              'assets/la_city.jpeg',
              width: 100,
              height: 100,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
