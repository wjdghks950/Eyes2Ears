import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

import 'detector_painters.dart';
import 'utils.dart';

class OCRPage extends StatefulWidget {
  @override
  _OCRPageState createState() => _OCRPageState();
}

class _OCRPageState extends State<OCRPage> {
  dynamic _scanResults;
  CameraController _camera;

  bool _isTranslate = false;
  final _translator = GoogleTranslator(); // Translator using Google Translator via translator.dart package
  String _translation;

  Detector _currentDetector = Detector.text;
  bool _isDetecting = false;
  CameraLensDirection _direction = CameraLensDirection.back;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    CameraDescription description = await getCamera(_direction);
    ImageRotation rotation = rotationIntToImageRotation(
      description.sensorOrientation,
    );

    _camera = CameraController(
      description,
      defaultTargetPlatform == TargetPlatform.iOS
          ? ResolutionPreset.low
          : ResolutionPreset.medium,
    );
    await _camera.initialize();

    _camera.startImageStream((CameraImage image) {
      if (_isDetecting) return;

      _isDetecting = true;

      detect(image, _getDetectionMethod(), rotation).then(
        (dynamic result) {
          setState(() {
            _scanResults = result;
            print("[ Detected ] : " + _scanResults.text);
            if(_isTranslate){
              _buildTranslation(_scanResults.text);
            }
          });
          _isDetecting = false;
        },
      ).catchError(
        (_) {
          _isDetecting = false;
        },
      );
    });
  }

  HandleDetection _getDetectionMethod() {
    final FirebaseVision mlVision = FirebaseVision.instance;

    switch (_currentDetector) {
      case Detector.text:
        return mlVision.textRecognizer().processImage;
      case Detector.barcode:
        return mlVision.barcodeDetector().detectInImage;
      // case Detector.label:
      //   return mlVision.labelDetector().detectInImage;
      // case Detector.cloudLabel:
      //   return mlVision.cloudLabelDetector().detectInImage;
      default:
        assert(_currentDetector == Detector.face);
        return mlVision.faceDetector().processImage;
    }
  }
  void _buildTranslation(String text) {
    _translator.translate(text, from: 'en', to: 'ko').then((s){
      setState((){
        _translation = s;
        print('[ Translation ]:' + _translation);
      });
    });
  }

  Widget _buildResults() {
    const Text noResultsText = const Text('No results!');

    if (_scanResults == null ||
        _camera == null ||
        !_camera.value.isInitialized) {
      return noResultsText;
    }

    CustomPainter painter;

    final Size imageSize = Size(
      _camera.value.previewSize.height,
      _camera.value.previewSize.width,
    );

    switch (_currentDetector) {
      case Detector.barcode:
        if (_scanResults is! List<Barcode>) return noResultsText;
        painter = BarcodeDetectorPainter(imageSize, _scanResults);
        break;
      case Detector.face:
        if (_scanResults is! List<Face>) return noResultsText;
        painter = FaceDetectorPainter(imageSize, _scanResults);
        break;
      case Detector.label:
        if (_scanResults is! List<ImageLabel>) return noResultsText;
        painter = LabelDetectorPainter(imageSize, _scanResults);
        break;
      case Detector.cloudLabel:
        if (_scanResults is! List<ImageLabel>) return noResultsText;
        painter = LabelDetectorPainter(imageSize, _scanResults);
        break;
      default:
        assert(_currentDetector == Detector.text);
        if (_scanResults is! VisionText) return noResultsText;
        painter = TextDetectorPainter(imageSize, _scanResults);
    }

    return CustomPaint(
      painter: painter,
    );
  }

  Widget _buildImage() {

    return Container(
      constraints: const BoxConstraints.expand(),
      child: _camera == null
          ? const Center(
              child: Text(
                'Initializing Camera...',
                style: TextStyle(
                fontSize: 30.0,
                fontFamily: "SF-Pro-Text-Regular",
                fontWeight:FontWeight.bold,
                color: Color(0xFF2d3447))
              ),
            )
          : Stack(
              fit: StackFit.expand,
              children: <Widget>[
                CameraPreview(_camera),
                _buildResults(),

                Positioned(
                  top: MediaQuery.of(context).size.height / 7.0,
                  left: MediaQuery.of(context).size.width / 1.7,
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color(0xFF2d3447).withOpacity(0.7),
                    ),
                    child: Text(_isTranslate ? "Translate: ON" : "Translate: Off",
                              style: TextStyle(
                                color: _isTranslate ? Colors.green : Colors.red,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              )),
                  )
                ),

                Positioned(
                  top: MediaQuery.of(context).size.height/2.0,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20.0,0,0,0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Color(0xFF2d3447).withOpacity(0.7),                     
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height/2,
                    child: Text( !_isTranslate ? _scanResults.text ?? ' ' : _translation ?? ' ',
                           style: TextStyle(
                             color: Colors.white,
                             fontSize: 20.0,
                             fontWeight: FontWeight.bold,
                             ),
                          ),
                  ),
                ),
              ],
            ),
    );
  }

  void _toggleCameraDirection() async {
    if (_direction == CameraLensDirection.back) {
      _direction = CameraLensDirection.front;
    } else {
      _direction = CameraLensDirection.back;
    }

    await _camera.stopImageStream();
    await _camera.dispose();

    setState(() {
      _camera = null;
    });

    _initializeCamera();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2d3447),
        title: const Text('Read the text', 
                style: TextStyle(
                fontSize: 30.0,
                fontFamily: "SF-Pro-Text-Regular",
                fontWeight:FontWeight.bold,
                color: Colors.white),
              ),
        actions: <Widget>[
          PopupMenuButton<Detector>(
            onSelected: (Detector result) {
              _currentDetector = result;
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Detector>>[
                  const PopupMenuItem<Detector>(
                    child: Text('Detect Barcode'),
                    value: Detector.barcode,
                  ),
                  const PopupMenuItem<Detector>(
                    child: Text('Detect Face'),
                    value: Detector.face,
                  ),
                  const PopupMenuItem<Detector>(
                    child: Text('Detect Label'),
                    value: Detector.label,
                  ),
                  const PopupMenuItem<Detector>(
                    child: Text('Detect Cloud Label'),
                    value: Detector.cloudLabel,
                  ),
                  const PopupMenuItem<Detector>(
                    child: Text('Detect Text'),
                    value: Detector.text,
                  ),
                ],
          ),
        ],
      ),
      body: _buildImage(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: (){
          if(!_isTranslate){
            _isTranslate = true;
            //_buildTranslation(_scanResults.text);
          }
          else{
            _isTranslate = false;
          }
        },
        child: _isTranslate ? const Icon(Icons.cancel, color: Colors.red) : const Icon(Icons.translate, color: Colors.green),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.white,
      //   onPressed: _toggleCameraDirection,
      //   child: _direction == CameraLensDirection.back
      //       ? const Icon(Icons.camera_front, color: Color(0xFF2d3447))
      //       : const Icon(Icons.camera_rear, color: Color(0xFF2d3447)),
      // ),
    );
  }
}