import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class MyApp2 extends StatefulWidget {
  @override
  _MyApp2State createState() => _MyApp2State();
}

class _MyApp2State extends State<MyApp2> {
  File pickedImage;
  bool isImageLoaded = false;
  String data;
  Future pickImage() async
  {
    var tempStorage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      pickedImage = tempStorage;
      isImageLoaded = true;
    });
  }
  void parser(String text)
  {
    //text = text + ("\$");
    //print("Text -> "+text);
    RegExp re = RegExp(r'[A-Z]{2}[0-9]{2}[A-Z]{2}[0-9]{4}');
    Iterable allMatches = re.allMatches(text);
    if(allMatches.length >0)
      {
        print('Text -> '+text);
      }

  }
  Future readText() async
  {
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(pickedImage);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);

    for (TextBlock block in readText.blocks)
      {
        for (TextLine line in block.lines)
          {
            print(line.text);
            setState(() {
              data = line.text;
            });
            //parser(line.text);

            /*for(TextElement word in line.elements)
              {
                print(word.text);
              }*/
          }
      }

  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          SizedBox(height: 100,),
          isImageLoaded?Center(
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(pickedImage),
                  fit: BoxFit.cover
                )
              ),
            ),
          ): Container(),
          SizedBox(height: 10,),
          RaisedButton(
            color: Colors.black,
            child: Text('Select image of registration no.',style: TextStyle(color: Colors.yellow),),
              onPressed: pickImage,
          ),
          SizedBox(height: 10,),
          RaisedButton(
            color: Colors.black,
            child: Text('Share image',style: TextStyle(color: Colors.yellow)),
            onPressed: () async {
              await readText();
              //Navigator.pop(context, "Show List Of Nearby Riders");
            },
          ),
          SizedBox(height: 20,),
          Text(
            (data!=null)?data:'',
          ),
        ],

    );
  }
}
