import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(CleanSpeakersApp());
}

class CleanSpeakersApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blueGrey[900], 
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Clean Speakers'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Fix My Speaker 🔊',
                      style: TextStyle(
                        fontSize: 36, 
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16), 
                    Text(
                      'Get water and dust out of speakers by playing sound.',
                      style: TextStyle(
                        fontSize: 18, 
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32), 
                    CleanSpeakersButton(),
                    SizedBox(height: 8), 
                    Text(
                      '(Audio will last approximately 4 minutes)',
                      style: TextStyle(
                        fontSize: 16, 
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Click the button above to activate blower',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 17), 
                  Text(
                    '1. Disconnect from any Bluetooth speaker or earbuds if you’re using them.\n'
                    '2. Turn up the volume to the max.\n'
                    '3. Tap to listen to the sound to the end to get the water out.\n'
                    '4. Play the sound 2-3 times. If the sound does not work, put your phone in a closed rice bag for the whole day or send it to an expert.\n',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CleanSpeakersButton extends StatefulWidget {
  @override
  _CleanSpeakersButtonState createState() => _CleanSpeakersButtonState();
}

class _CleanSpeakersButtonState extends State<CleanSpeakersButton> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isPaused = false;

  Future<void> playOrPauseSound() async {
    if (_isPlaying) {
      if (_isPaused) {
        
        await audioPlayer.resume();
        setState(() {
          _isPaused = false;
        });
      } else {
        
        await audioPlayer.pause();
        setState(() {
          _isPaused = true;
        });
      }
    } else {
      
      setState(() {
        _isPlaying = true;
        _isPaused = false;
      });

      try {
        const url = 'https://ahmetkoca.dev/flutter/clean.mp3';
        await audioPlayer.play(UrlSource(url));
        audioPlayer.onPlayerComplete.listen((_) {
          setState(() {
            _isPlaying = false;
            _isPaused = false;
          });
        });
        print('Ses çalıyor!');
      } catch (e) {
        print('Hata oluştu: $e');
        setState(() {
          _isPlaying = false;
          _isPaused = false;
        });
      }
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8, 
      child: ElevatedButton(
        onPressed: () {
          playOrPauseSound();
        },
        child: Text(_isPlaying
            ? (_isPaused ? 'Resume Playback' : 'Pause Playback')
            : 'Clean Speakers'),
        style: ElevatedButton.styleFrom(
          backgroundColor: _isPlaying
              ? (_isPaused ? Colors.green : Colors.blue) 
              : Colors.blue, 
          foregroundColor: Colors.white, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.symmetric(vertical: 16), 
          textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
