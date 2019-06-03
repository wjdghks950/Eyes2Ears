import 'package:flutter/material.dart';
import 'package:youtube_player/youtube_player.dart';

class VideoDetail extends StatefulWidget {
  @override
  _VideoDetailState createState() => _VideoDetailState();
}

class _VideoDetailState extends State<VideoDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Video Detail"),
        backgroundColor: Colors.blueGrey,
      ),
      body: YoutubePlayer(
        context: context,
        source: "https://youtu.be/BZpIQnPdsSQ",
        quality: YoutubeQuality.HD,
        aspectRatio: 16 / 9,
        autoPlay: true,
        loop: true,
        startFullScreen: true,
      ),
    );
  }
}
class VideoDetail2 extends StatefulWidget {
  @override
  _VideoDetail2State createState() => _VideoDetail2State();
}

class _VideoDetail2State extends State<VideoDetail2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Video Detail"),
        backgroundColor: Colors.blueGrey,
      ),
      body: YoutubePlayer(
        context: context,
        source: "https://youtu.be/DNrK0yhrz0A",
        quality: YoutubeQuality.HD,
        aspectRatio: 16 / 9,
        autoPlay: true,
        loop: true,
        startFullScreen: true,
      ),
    );
  }
}
class VideoDetail3 extends StatefulWidget {
  @override
  _VideoDetail3State createState() => _VideoDetail3State();
}

class _VideoDetail3State extends State<VideoDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Video Detail"),
        backgroundColor: Colors.blueGrey,
      ),
      body: YoutubePlayer(
        context: context,
        source: "https://youtu.be/woSCgIhRl9s",
        quality: YoutubeQuality.HD,
        aspectRatio: 16 / 9,
        autoPlay: true,
        loop: true,
        startFullScreen: true,
      ),
    );
  }
}

