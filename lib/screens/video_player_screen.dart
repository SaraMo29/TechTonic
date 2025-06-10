import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:get/get.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String title;

  const VideoPlayerScreen({
    Key? key,
    required this.videoUrl,
    required this.title,
  }) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: false,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
        placeholder: Container(
          color: Colors.black,
          child: const Center(child: CircularProgressIndicator()),
        ),
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.blue,
          handleColor: Colors.blue,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.lightBlue,
        ),
      );

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error loading video: $e';
      });
      print('Error initializing video player: $e');
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage.isNotEmpty
                ? Center(
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Center(
                    child: Chewie(
                      controller: _chewieController!,
                    ),
                  ),
      ),
    );
  }
}
