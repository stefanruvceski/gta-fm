
import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

final gtaFmUrls =[
    "http://docs.google.com/uc?export=open&id=1Bn_3HikUes4JD-Y1oH61zif3duQcPu6M",
    //"http://docs.google.com/uc?export=open&id=1iJlM-eqY0UzipbsVhxc0kPFaoqbv_Ud3",
    "http://docs.google.com/uc?export=open&id=1rrBoRRklcKo3IEwLspF0I_x4c3IWL49S",
    "http://docs.google.com/uc?export=open&id=17cntczpONIGX9yamzj2J1gapKwqURExL",
    "http://docs.google.com/uc?export=open&id=11AXR4q1JNwy0_rxdTFFGu2DeI-Fd4Z73",
    "http://docs.google.com/uc?export=open&id=14hDjUvbAUoLwIDmrcYPcK5rtvZxPGipt"
];

var dio = Dio();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GTA FM',
      theme: ThemeData.light(),
      home: MyHomePage(title: 'GTA FM'),
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
  String downloadingProgress;
  final AssetsAudioPlayer _player = AssetsAudioPlayer.newPlayer();

  final Playlist playlist = Playlist(audios: [
    Audio.network(
      gtaFmUrls[0],
      metas: Metas(
        title: 'Flash FM',
        album: 'https://i.imgur.com/dXCEhTg.jpeg'),
    ),
    Audio.network(
      gtaFmUrls[1],
      metas: Metas(
        title: 'Vice City FM',
        album: 'https://i.imgur.com/ocDKnV5.jpg'),
    ),
     Audio.network(
      gtaFmUrls[2],
      metas: Metas(
        title: 'Emotion 983 FM',
        album: 'https://i.imgur.com/wKnKrV1.jpg'),
    ),
     Audio.network(
      gtaFmUrls[3],
      metas: Metas(
        title: 'Fever 105 FM',
        album: 'https://i.imgur.com/9BQY6CG.jpg'),
    ),
     Audio.network(
      gtaFmUrls[4],
      metas: Metas(
        title: 'Flash FM',
        album: 'https://i.imgur.com/dXCEhTg.jpeg'),
    ),
    //  Audio.network(
    //   gtaFmUrls[5],
    //   metas: Metas(title: ''),
    // ),
  ]);


  @override
  void initState() {
    super.initState();
    _player.currentPosition.listen((event) {
      //print("_player.currentPosition: $event");
    });
    _player.open(
      playlist,
      loopMode: LoopMode.playlist,
      autoStart: false,
      showNotification: true,

    );
    //_downloadInParallel();
  }

  void _downloadInParallel() async {
    final tempDir = await getTemporaryDirectory();
    final downloadPath = tempDir.path + "/downloaded.mp3";
    print('full path $downloadPath');

    await Future.delayed(Duration(seconds: 3));

    await downloadFileTo(
        dio: dio,
        url: gtaFmUrls[0],
        savePath: downloadPath,
        progressFunction: (received, total) {
          if (total != -1) {
            setState(() {
              downloadingProgress =
                  (received / total * 100).toStringAsFixed(0) + "%";
            });
          }
        });
    setState(() {
      print("downloaded, switching to file type $downloadPath");
      playlist.replaceAt(
        0,
        (oldAudio) {
          return oldAudio.copyWith(
              audioType: AudioType.file, path: downloadPath);
        },
        keepPlayingPositionIfCurrent: true,
      );
      this.downloadingProgress = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Card(
        semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
               shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              margin: EdgeInsets.all(10),
       
          child: Stack(
            children:[ 
                Image.network(
                'https://i.imgur.com/9BQY6CG.jpg',
                fit: BoxFit.fitWidth,
              ),
             
                 Center(
              
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                if (downloadingProgress != null)
                    Text(this.downloadingProgress)
                  else
                    SizedBox(),

                    PlayerBuilder.currentPosition(
                      player: _player,
                      builder: (context, duration) {
                        try{
                          print(_player.current.value.audio.audio.metas.title);
                          return Column(
                            children: [
                              Image.network(_player.current.value.audio.audio.metas.album,width: 500,),
                              SizedBox(height: 10,),
                              Text(_player.current.value.audio.audio.metas.title),
                              SizedBox(height: 10,),
                              Text(duration.toString() + ' / '+_player.current.value.audio.duration.toString() ),
                            ],
                          );

                        }
                        catch(e){
                           return Text(duration.toString());
                        }


                      }
                  ),
                  SizedBox(height: 10,),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                       _prevButton(),
                       SizedBox(width: 10,),
                      _playingButton(),
                      SizedBox(width: 10,),
                    _nextButton(),
                    ],),


                ],
              ),
            ),]
          ),
        
      ),
    );
  }

  bool _play = false;
  Widget wid(){
    return AudioWidget.assets(
     path: gtaFmUrls[0],
     play: _play,
     child: ElevatedButton(
           child: Text(
               _play ? "pause" : "play",
           ),
           onPressed: () {
               setState(() {
                 _play = !_play;
               });
           }
      ),
      onReadyToPlay: (duration) {
          //onReadyToPlay
      },
      onPositionChanged: (current, duration) {
          //onPositionChanged
      },
  );
  }

  Widget _playingButton() {
    return PlayerBuilder.isPlaying(
      player: _player,
      builder: (context, isPlaying) {
        return FloatingActionButton(
          child: isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
          onPressed: () {
            _player.playOrPause();
          },
        );
      },
    );
  }

  Widget _nextButton() {
    return PlayerBuilder.isPlaying(
      player: _player,
      builder: (context, isPlaying) {
        return FloatingActionButton(
          child: Icon(Icons.skip_next),
          onPressed: () {
            _player.pause();
            _player.next();
          },
        );
      },
    );
  }
  Widget _prevButton() {
    return PlayerBuilder.isPlaying(
      player: _player,
      builder: (context, isPlaying) {
        return FloatingActionButton(
          child: Icon(Icons.skip_previous),
          onPressed: () {
            _player.pause();
            _player.previous();
          },
        );
      },
    );
  }
}

Future downloadFileTo(
    {Dio dio,
    String url,
    String savePath,
    Function(int received, int total) progressFunction}) async {
  try {
    final Response response = await dio.get(
      url,
      onReceiveProgress: progressFunction,
      //Received data with List<int>
      options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status < 500;
          }),
    );
    print(response.headers);
    final File file = File(savePath);
    var raf = file.openSync(mode: FileMode.write);
    // response.data is List<int> type
    raf.writeFromSync(response.data);
    await raf.close();
  } catch (e) {
    print(e);
  }
}
