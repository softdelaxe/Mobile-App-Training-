// screens/meditation_home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';


class MeditationHomeScreen extends StatefulWidget {
  const MeditationHomeScreen({Key? key}) : super(key: key);

  @override
  State<MeditationHomeScreen> createState() => _MeditationHomeScreenState();
}

class _MeditationHomeScreenState extends State<MeditationHomeScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      await _audioPlayer.setAsset('assets/audio/meditation.mp3');
      _totalDuration = await _audioPlayer.duration ?? Duration.zero;
      _audioPlayer.positionStream.listen((position) {
        setState(() {
          _currentPosition = position;
        });
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error loading audio file.')),
      );
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Meditation App',
          style: TextStyle(fontWeight: FontWeight.w600,
          color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.teal.shade600,
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade400, Colors.teal.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Relax and Meditate',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // Separate Play and Pause Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20), backgroundColor: Colors.lightGreenAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          shadowColor: Colors.black.withOpacity(0.3),
                          elevation: 5,
                        ),
                        onPressed: () async {
                          await _audioPlayer.play();
                          setState(() {
                            _isPlaying = true;
                          });
                        },
                        child: Text(
                          'Play',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(width: 20), // Space between buttons
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20), backgroundColor: Colors.lightGreenAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          shadowColor: Colors.black.withOpacity(0.3),
                          elevation: 5,
                        ),
                        onPressed: () async {
                          await _audioPlayer.pause();
                          setState(() {
                            _isPlaying = false;
                          });
                        },
                        child: Text(
                          'Pause',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Progress and Duration Display
                  Slider(
                    value:_totalDuration.inSeconds > 0
                        ? _currentPosition.inSeconds.clamp(0, _totalDuration.inSeconds).toDouble()
                        : 0.0,
                    max:_totalDuration.inSeconds.toDouble(),
                    onChanged:_totalDuration.inSeconds > 0
                        ? (value) async {
                      final position = Duration(seconds:value.toInt());
                      await _audioPlayer.seek(position);
                      setState(() {
                        _currentPosition = position; // Update current position immediately on seek
                      });
                    }
                        : null,
                    activeColor:_isPlaying ? Colors.teal.shade300 : Colors.teal.shade100,
                    inactiveColor:_isPlaying ? Colors.teal.shade100 : Colors.grey,
                  ),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children:[
                      Text(_formatDuration(_currentPosition),style:
                      TextStyle(color:
                      Colors.white)),
                      Text(_formatDuration(_totalDuration),style:
                      TextStyle(color:
                      Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
