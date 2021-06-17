import 'package:ai_voice_assistant/model/radio.dart';
import 'package:ai_voice_assistant/utils/ai_util.dart';
import 'package:alan_voice/alan_voice.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MyRadio> radios;
  MyRadio _selectedRadio;
  Color _selectedColor;
  bool _isPlaying = false;

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    setupAlan();
    fetchRadios();

    _audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == AudioPlayerState.PLAYING) {
        _isPlaying = true;
      } else {
        _isPlaying = false;
      }
      setState(() {});
    });
  }

  setupAlan() {
    AlanVoice.addButton(
        "b87f700bbaf3a44250e5417a3b81716e2e956eca572e1d8b807a3e2338fdd0dc/stage",
        buttonAlign: AlanVoice.BUTTON_ALIGN_RIGHT);
    AlanVoice.callbacks.add((command) => _handleCommand(command.data));
  }

  _handleCommand(Map<String, dynamic> response) {
    switch (response["command"]) {
      case "play":
        _playMusic(_selectedRadio.url);
        break;
      case "play_channel":
        final id = response["id"];
        _audioPlayer.pause();
        MyRadio newRadio = radios.firstWhere((element) => element.id == id);
        radios.remove(newRadio);
        radios.insert(0, newRadio);
        _playMusic(newRadio.url);
        break;
      case "stop":
        _audioPlayer.stop();
        break;
      case "next":
        final index = _selectedRadio.id;
        MyRadio newRadio;
        if (index + 1 > radios.length) {
          newRadio = radios.firstWhere((element) => element.id == 1);
          radios.remove(newRadio);
          radios.insert(0, newRadio);
        } else {
          newRadio = radios.firstWhere((element) => element.id == index + 1);
          radios.remove(newRadio);
          radios.insert(0, newRadio);
        }
        _playMusic(newRadio.url);
        break;
      case "previous":
        final index = _selectedRadio.id;
        MyRadio newRadio;
        if (index - 1 <= 0) {
          newRadio = radios.firstWhere((element) => element.id == 1);
          radios.remove(newRadio);
          radios.insert(0, newRadio);
        } else {
          newRadio = radios.firstWhere((element) => element.id == index - 1);
          radios.remove(newRadio);
          radios.insert(0, newRadio);
        }
        _playMusic(newRadio.url);
        break;
      default:
        print("Command was ${response["Command"]}");
        break;
    }
  }

  fetchRadios() async {
    final radioJson = await rootBundle.loadString("assets/radio.json");
    radios = MyRadioList.fromJson(radioJson).radios;
    _selectedRadio = radios[0];
    _selectedColor = Color(int.tryParse(_selectedRadio.color));
    print(radios);
    setState(() {}); // refresh the UI
  }

  _playMusic(String url) {
    _audioPlayer.play(url);
    _selectedRadio = radios.firstWhere((element) => element.url == url);
    print(_selectedRadio.name);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      body: Stack(children: [
        VxAnimatedBox()
            .size(context.screenWidth, context.screenHeight)
            .withGradient(LinearGradient(colors: [
              AIColors.primaryColor2,
              _selectedColor ?? AIColors.primaryColor1
            ], begin: Alignment.topLeft, end: Alignment.bottomRight))
            .make(),
        AppBar(
          title: "AI Radio".text.xl4.bold.white.make().shimmer(
              primaryColor: Vx.purple300, secondaryColor: Colors.white),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
        ).h(100).p16(),
        radios != null
            ? VxSwiper.builder(
                itemCount: radios.length,
                aspectRatio: 1.0,
                enlargeCenterPage: true,
                onPageChanged: (index) {
                  _selectedRadio = radios[index];
                  final colorHex = radios[index].color;
                  _selectedColor = Color(int.tryParse(colorHex));
                  setState(() {});
                },
                itemBuilder: (context, index) {
                  final rad = radios[index];
                  return VxBox(
                    child: ZStack([
                      Positioned(
                        right: 0.0,
                        child: VxBox(
                                child: rad.category.text.uppercase.white
                                    .make()
                                    .p16())
                            .height(50)
                            .black
                            .alignCenter
                            .withRounded(value: 10.0)
                            .make(),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: VStack(
                          [
                            rad.name.text.xl3.white.bold.make(),
                            5.heightBox,
                            rad.tagline.text.sm.white.semiBold.make()
                          ],
                          crossAlignment: CrossAxisAlignment.center,
                        ),
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: [
                            Icon(CupertinoIcons.play_circle,
                                color: Colors.white),
                            10.heightBox,
                            "Double Tap to Play".text.gray300.make()
                          ].vStack())
                    ]),
                  )
                      .clip(Clip.antiAlias)
                      .bgImage(
                        DecorationImage(
                          image: NetworkImage(rad.image),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.3), BlendMode.darken),
                        ),
                      )
                      .border(color: Colors.black, width: 5)
                      .withRounded(value: 60.0)
                      .make()
                      .onInkDoubleTap(() {
                    _playMusic(rad.url);
                  }).p16();
                },
              ).centered()
            : Center(
                child:
                    CircularProgressIndicator(backgroundColor: Colors.white)),
        Align(
          alignment: Alignment.bottomCenter,
          child: [
            if (_isPlaying)
              "Playing Now - ${_selectedRadio.name} FM"
                  .text
                  .white
                  .makeCentered(),
            Icon(
                    _isPlaying
                        ? CupertinoIcons.stop_circle
                        : CupertinoIcons.play_circle,
                    color: Colors.white,
                    size: 50.0)
                .onInkTap(() {
              if (_isPlaying)
                _audioPlayer.stop();
              else
                _playMusic(_selectedRadio.url);
            })
          ].vStack(),
        ).pOnly(bottom: context.percentHeight * 12)
      ], fit: StackFit.expand),
    );
  }
}
