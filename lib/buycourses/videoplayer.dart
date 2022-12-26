import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

// void main() {
//   runApp(
//     ChewieDemo(),
//   );
// }

class ChewieDemo extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  String link;
  ChewieDemo({required this.link});
  @override
  State<StatefulWidget> createState() {
    return _ChewieDemoState(link);
  }
}

class _ChewieDemoState extends State<ChewieDemo> {
  String link;
  _ChewieDemoState(this.link);
  TargetPlatform _platform;
  VideoPlayerController _videoPlayerController1;
  VideoPlayerController _videoPlayerController2;
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _videoPlayerController2.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController1 = VideoPlayerController.network(
        link);
    _videoPlayerController2 = VideoPlayerController.network(
        link);
    await Future.wait([
      _videoPlayerController1.initialize(),
      _videoPlayerController2.initialize()
    ]);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      autoPlay: true,
      looping: true,
      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Playing Lecture'),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: _chewieController != null &&
                        _chewieController
                            .videoPlayerController.value.initialized
                    ? Chewie(
                        controller: _chewieController,
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(height: 20),
                          Text('Loading'),
                        ],
                      ),
              ),
            ),
            TextButton(
              onPressed: () {
                _chewieController.enterFullScreen();
              },
              child: const Text('Fullscreen'),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _chewieController.dispose();
                        _videoPlayerController1.pause();
                        _videoPlayerController1.seekTo(const Duration());
                        _chewieController = ChewieController(
                          videoPlayerController: _videoPlayerController1,
                          autoPlay: true,
                          looping: true,
                        );
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text("Landscape Video"),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _chewieController.dispose();
                        _videoPlayerController2.pause();
                        _videoPlayerController2.seekTo(const Duration());
                        _chewieController = ChewieController(
                          videoPlayerController: _videoPlayerController2,
                          autoPlay: true,
                          looping: true,
                        );
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text("Portrait Video"),
                    ),
                  ),
                )
              ],
            ),
          //   Row(
          //     children: <Widget>[
          //       Expanded(
          //         child: TextButton(
          //           onPressed: () {
          //             setState(() {
          //               _platform = TargetPlatform.android;
          //             });
          //           },
          //           child: const Padding(
          //             padding: EdgeInsets.symmetric(vertical: 16.0),
          //             child: Text("Android controls"),
          //           ),
          //         ),
          //       ),
          //       Expanded(
          //         child: TextButton(
          //           onPressed: () {
          //             setState(() {
          //               _platform = TargetPlatform.iOS;
          //             });
          //           },
          //           child: const Padding(
          //             padding: EdgeInsets.symmetric(vertical: 16.0),
          //             child: Text("iOS controls"),
          //           ),
          //         ),
          //       )
          //     ],
          //   )
           ],
        ),
    );
  }
}