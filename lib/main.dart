
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

final gtaFmUrls =[
    "http://docs.google.com/uc?export=open&id=1xnAfo4aKXV6o4gx9kxqMOGPotVeCp9r0",//emotion
    "http://docs.google.com/uc?export=open&id=1AzUGOaa1CIPXaGZH_pmz_rZi53ocCXde",//espant
    "http://docs.google.com/uc?export=open&id=1n_QxTofhOSJY-YMoAft3shG-fHfYGXvy",//fever
    "http://docs.google.com/uc?export=open&id=1Wyl2LCPVMyWLtCFVBa7chR0BheGlQS56",//flash
    "http://docs.google.com/uc?export=open&id=1UvK462vjUIqWIebPieCIh_cEqz-D1Kjm",//vrock
    "http://docs.google.com/uc?export=open&id=1tqSpkUd3vJEFH2tNN5bUa0yB1DnAZiL4",//wave
    "http://docs.google.com/uc?export=open&id=1nacOzHWzfsUavKuks1x4nwY8pQlsIGSd"//waild
];
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GTA FM',
      theme: ThemeData.dark(),
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
  final AssetsAudioPlayer _player = AssetsAudioPlayer.newPlayer();
  
  final Playlist playlist = Playlist(audios: [
    Audio.network(
      gtaFmUrls[0],
      metas: Metas(
        title: 'Emotion FM',
        album: 'https://i.imgur.com/wKnKrV1.jpg'),//emotion
    ),
    Audio.network(
      gtaFmUrls[1],
      metas: Metas(
        title: 'Spantos FM',
        album: 'https://i.imgur.com/1EFMm9V.jpg'), //espanros
    ),
      Audio.network(
      gtaFmUrls[2],
      metas: Metas(
        title: 'Fever FM',
        album: 'https://i.imgur.com/9BQY6CG.jpg'),//fever
    ),
     Audio.network(
      gtaFmUrls[3],
      metas: Metas(
        title: 'Flash FM',
        album: 'https://i.imgur.com/dXCEhTg.jpeg'),//Flash
    ),
     Audio.network(
      gtaFmUrls[4],
      metas: Metas(
        title: 'V-Rock FM',
        album: 'https://i.imgur.com/7f1PZSL.jpg'),//rock
    ),
     Audio.network(
      gtaFmUrls[5],
      metas: Metas(
        title: 'Wave FM',
        album: 'https://i.imgur.com/HZRSvmp.jpg'),//wave
    ),
     Audio.network(
      gtaFmUrls[6],
      metas: Metas(
        title: 'Wild FM',
        album: 'https://i.imgur.com/J4szDOr.jpg'),
    ),
    
  ]);
  var i = 0;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          width: 800,
          height:  MediaQuery.of(context).size.width>800? 650:500,
          child: Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5,
            margin: EdgeInsets.all(10),           
            child: Column(
              children:[ 
                Image.network(        
                  playlist.audios[i].metas.album,
                  fit: BoxFit.fitWidth,
                ),
                Center(  
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(),
                      PlayerBuilder.currentPosition(
                        player: _player,
                        builder: (context, duration) {
                          try{
                            return Column(
                              children: [
                                SizedBox(height: 30,),
                                Text(_player.current.value.audio.audio.metas.title),
                                SizedBox(height: 10,),
                                Text(duration.toString() + ' / '+_player.current.value.audio.duration.toString() ),
                              ],
                            );
                          }
                          catch(e){
                            return Column(
                              children: [
                                SizedBox(height: 30,),
                                Text('loading...'),
                                SizedBox(height: 10,),
                                Text(duration.toString() ),
                              ],
                            );
                          }
                        }
                      ),
                      SizedBox(height: 10,),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if(i> 0)
                            _prevButton(),
                          SizedBox(width: 10,),
                          _playingButton(),
                          SizedBox(width: 10,),    
                          if(i < 6)
                            _nextButton()
                        ],
                      ),
                    ],
                  ),
                ),
              ]
            ),
          ),
        ),
      ),
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
            setState(() {
              i++;
            });
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
            setState(() {
              i--;
            });
          },
        );
      },
    );
  }
}



