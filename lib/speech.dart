//https://github.com/ZaynJarvis/Flutter-Speech-Recognition
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'recognizer.dart';

class Task {
  int taskId;
  String label;
  bool complete;

  Task({this.taskId, this.label, this.complete = false});
}

class TaskWidget extends StatelessWidget {
  final String label;
  final VoidCallback onDelete;
  final VoidCallback onComplete;

  TaskWidget({this.label, this.onDelete, this.onComplete});

  Widget _buildDissmissibleBackground(
      {
        Color color,
        IconData icon,
        FractionalOffset align = FractionalOffset.centerLeft}) =>
      new Container(
        height: 42.0,
        color: color,
        child: new Icon(icon, color: Colors.white70),
        alignment: align,
      );

  @override
  Widget build(BuildContext context) {
    return new Container(
        height: 42.0,
        child: new Dismissible(
            direction: DismissDirection.horizontal,
            child: new Align(
                alignment: FractionalOffset.centerLeft,
                child: new Padding(
                    padding: new EdgeInsets.all(10.0), child: new Text(label))),
            key: new Key(label),
            background: _buildDissmissibleBackground(
                color: Colors.lime, icon: Icons.check),
            secondaryBackground: _buildDissmissibleBackground(
                color: Colors.red,
                icon: Icons.delete,
                align: FractionalOffset.centerRight),
            onDismissed: (direction) => direction == DismissDirection.startToEnd
                ? onComplete()
                : onDelete()));
  }
}

class TranscriptorWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  _TranscriptorAppState createState() => new _TranscriptorAppState();
}

class _TranscriptorAppState extends State<TranscriptorWidget> {
  String transcription = '';

  bool authorized = false;

  bool isListening = false;

  List<Task> todos = [];

  bool get isNotEmpty => transcription != '';

  get numArchived => todos.where((t) => t.complete).length;
  Iterable<Task> get incompleteTasks => todos.where((t) => !t.complete);

  @override
  void initState() {
    super.initState();
    SpeechRecognizer.setMethodCallHandler(_platformCallHandler);
    _activateRecognition();
  }

  @override
  void dispose() {
    super.dispose();
    if (isListening) _cancelRecognitionHandler();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // List<Widget> blocks = [
    //   _buildButtonBar(),
    // ];
    if (isListening || transcription != ''){
      _buildTranscriptionBox(
          text: transcription,
          onCancel: _cancelRecognitionHandler,
          width: size.width);
    }
    return Scaffold(
      key: widget._scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Color(0xFF2d3447),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
                  isListening ? _buildTranscriptionBox(
                    text: transcription,
                    onCancel: _cancelRecognitionHandler,
                    width: size.width) : _buildTranscriptionBox(
                    text: "Press the mic to listen...",
                    onCancel: _cancelRecognitionHandler,
                    width: size.width),
                  _buildButtonBar(),
          ],
        ),
      ),
    );
  }

  void _saveTranscription() {
    if (transcription.isEmpty) return;
    setState(() {
      todos.add(new Task(
          taskId: new DateTime.now().millisecondsSinceEpoch,//minute로 바꾸기?
          label: transcription));
      transcription = '';
    });
    _cancelRecognitionHandler();
  }

  Future _startRecognition() async {
    final res = await SpeechRecognizer.start('en_US');
    if (!res)
      showDialog(
          context: context,
          child: new SimpleDialog(title: new Text("Error"), children: [
            new Padding(
                padding: new EdgeInsets.all(12.0),
                child: const Text('Recognition not started'))
          ]));
  }

  Future _cancelRecognitionHandler() async {
    final res = await SpeechRecognizer.cancel();

    setState(() {
      transcription = '';
      isListening = res;
    });
  }

  Future _activateRecognition() async {
    final res = await SpeechRecognizer.activate();
    setState(() => authorized = res);
  }

  Future _copyTranscription() async {
    Clipboard.setData(ClipboardData(text: transcription));
    Clipboard.getData('text/plain').then((content){
      print(content.text);
      widget._scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("[ " + content.text + " ]" + " is copied to your clipboard!",
                                                                          style: TextStyle(fontWeight: FontWeight.bold,))));
    });
  }

  Future _platformCallHandler(MethodCall call) async {
    switch (call.method) {
      case "onSpeechAvailability":
        setState(() => isListening = call.arguments);
        break;
      case "onSpeech":
        if (todos.isNotEmpty) if (transcription == todos.last.label) return;
        setState(() => transcription = call.arguments);
        break;
      case "onRecognitionStarted":
        setState(() => isListening = true);
        break;
      case "onRecognitionComplete":
        setState(() {
          if (todos.isEmpty) {
            transcription = call.arguments;
          } else if (call.arguments == todos.last?.label)
            // on ios user can have correct partial recognition
            // => if user add it before complete recognition just clear the transcription
            transcription = '';
          else
            transcription = call.arguments;
        });
        break;
      default:
        print('Unknowm method ${call.method} ');
    }
  }

  Widget _buildButtonBar() {
    List<Widget> buttons = [
      !isListening
          ? _buildIconButton(authorized ? Icons.mic : Icons.mic_off,
          authorized ? _startRecognition : null,
          color: Colors.white, fab: true)
          : _buildIconButton(Icons.close, isListening ? _cancelRecognitionHandler : null,
          color: Colors.white,
          backgroundColor: Colors.blueGrey,
          fab: true),
      _buildIconButton(Icons.content_copy, _copyTranscription , fab: false),
    ];
    Row buttonBar = new Row(mainAxisSize: MainAxisSize.min, children: buttons);
    return buttonBar;
  }

  Widget _buildTranscriptionBox(
      {String text, VoidCallback onCancel, double width}) =>
      Container(
          width: width,
          height: MediaQuery.of(context).size.height/1.3,
          color: Color(0xFF2d3447),
          child: Row(children: [
            Expanded(
                child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(text, style: TextStyle(fontSize: 50.0, color: Colors.white),),
                )),
            // new IconButton(
            //     icon: new Icon(Icons.close, color: Colors.grey.shade600),
            //     onPressed: text != '' ? () => onCancel() : null),
          ]));

  Widget _buildIconButton(IconData icon, VoidCallback onPress,
      {
        Color color: Colors.grey,
        Color backgroundColor: Colors.black,
        bool fab = false}) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: fab
          ? FloatingActionButton(
            elevation: 20.0,
            shape: RoundedRectangleBorder(side: BorderSide(style: BorderStyle.none), borderRadius: BorderRadius.circular(30.0)),
            child: Icon(icon, size: 45.0),
            onPressed: onPress,
            backgroundColor: Color(0xFFA154F2))
            : RaisedButton(
              shape: RoundedRectangleBorder(side: BorderSide(style: BorderStyle.none), borderRadius: BorderRadius.circular(30.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(icon, size: 45.0, color: Colors.white),
                  Text('COPY', 
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                      fontFamily: 'Brandon_reg',
                      fontWeight: FontWeight.bold,
                      ),
                    ),
                ]
              ),
              color: Color(0xFFA154F2),
              onPressed: onPress
            ),
      );
  }
}