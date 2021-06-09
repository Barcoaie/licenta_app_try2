import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

var dictionary = {
  0: 'Background without leaves',
  1: 'Corn affected by Cercospora leaf spot/Gray leaf spot',
  2: 'Corn affected by Common rust',
  3: 'Corn affected by Northern Leaf Blight',
  4: 'Healthy corn',
  5: 'Healthy soybean',
  6: 'Squash affected by Powdery mildew',
  7: 'Tomato affected by Bacterial spot',
  8: 'Tomato affected by Early blight',
  9: 'Tomato affected by Late blight',
  10: 'Tomato affected by Leaf Mold',
  11: 'Tomato affected by Septoria leaf spot',
  12: 'Tomato affected by Spider mites/Two-spotted spider mite',
  13: 'Tomato affected by Target Spot',
  14: 'Tomato affected by Tomato Yellow Leaf Curl Virus',
  15: 'Tomato affected by mosaic virus',
  16: 'Healthy tomato',
};

String getLabel(List outputs) {
  return dictionary[outputs[0]['index']];
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LeafVerdict',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: MyHomePage(title: 'Main Activity Screen'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List _outputs;
  File _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/saved_model_30.tflite",
        labels: "assets/saved_labels2.txt");
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        imageStd: 255.0,
        threshold: 0.2,
        numResults: 2,
        imageMean: 0.0);
    print("predict = $output");
    setState(() {
      _outputs = output;
    });
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  Future getImage() async {
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      }
    });
    classifyImage(_image);
  }

  Future takeImage() async {
    final pickedImage = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      }
    });
    classifyImage(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: _image == null
                  ? Text('No image selected yet!')
                  : Image.file(_image),
              height: 300,
            ),
            SizedBox(
              height: 50,
              child: _image == null
                  ? Text('')
                  : Text(_outputs == null
                      ? ' '
                      : 'Picture detected is a ' +
                          getLabel(_outputs) +
                          ' with a confidence of ' +
                          _outputs[0]['confidence'].toString().substring(0, 5)),
            ),
            ElevatedButton(
              onPressed: takeImage,
              child: Text('Take a photo'),
            ),
            ElevatedButton(
              onPressed: getImage,
              child: Text('Pick from the gallery'),
            ),
          ],
        ),
      ),
    );
  }
}
