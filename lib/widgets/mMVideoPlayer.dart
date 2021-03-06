import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MMVideoPlayer extends StatefulWidget {
  /// The baseUrl of the video
  final String videourl;

  /// Play the video as soon as it's displayed
  final bool autoPlay;

  /// Start video at a certain position
  final Duration startAt;

  /// Whether or not the video should loop
  final bool looping;

  /// The Aspect Ratio of the Video. Important to get the correct size of the
  /// video!
  ///
  /// Will fallback to fitting within the space allowed.
  final double aspectRatio;

  MMVideoPlayer({
    Key key,
    @required this.videourl,
    @required this.aspectRatio,
    this.autoPlay = false,
    this.startAt,
    this.looping = false,
  }) : super(key: key);

  @override
  _MMVideoPlayerState createState() => _MMVideoPlayerState();
}

class _MMVideoPlayerState extends State<MMVideoPlayer> with AutomaticKeepAliveClientMixin {
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;
  Future<bool> _configChewieFuture;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _configChewieFuture = _configVideoPlayer();
    super.initState();
  }

  Future<bool> _configVideoPlayer() async{
    _videoPlayerController = VideoPlayerController.network(widget.videourl);
    await _videoPlayerController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: _videoPlayerController.value.aspectRatio,
      autoInitialize: true,
      customControls: MaterialControls(),
    );

    return true;
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    super.build(context);
    return FutureBuilder<bool>(
      initialData: false,
      future: _configChewieFuture,
      builder: (context, snapshot) {
        if(!snapshot.data) {
          return Container(
            width: width,
            height: width/widget.aspectRatio,
            child: Center(child: CircularProgressIndicator())
          );
        }

        return Chewie(
          controller: _chewieController,
        );
      }
    );
  }
}
