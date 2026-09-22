import 'package:flutter/material.dart';
import 'package:freac/core/context.dart';
import 'package:freac/core/wav_maker.dart';
import 'package:freac/widgets/snake.dart';
import 'package:freac/widgets/toplister.dart';
import 'package:freac/core/trackholder.dart';
import 'package:win32/win32.dart' show Beep;

/// the main parent widget of the app
class CheckInPage extends StatefulWidget {
  const CheckInPage({super.key});

  @override
  State<CheckInPage> createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  TrackHolder godWorm = TrackHolder();

  bool generateMenu = false;

  bool fileMakeError = true;

  TextEditingController textController = TextEditingController();

  /// toggles the menu that allows for saving the current track
  void unmenu() {
    setState(() {
      generateMenu = !generateMenu;
    });
  }

  void checkText() {
    setState(() {
      if (textController.text.contains(".") ||
          textController.text.contains(" ") ||
          textController.text == "") {
        fileMakeError = true;
      } else {
        fileMakeError = false;
      }
    });
  }

  void addToWorm(List<int> note) {
    setState(() {
      godWorm.addTrack(note);
    });
  }

  void mvr(int index) {
    setState(() {
      godWorm.moveR(index);
    });
  }

  void mvl(int index) {
    setState(() {
      godWorm.moveL(index);
    });
  }

  void rmt(index) {
    setState(() {
      godWorm.rmTrack(index);
    });
  }

  void inc(index) {
    setState(() {
      godWorm.incTime(index);
    });
  }

  void dec(index) {
    setState(() {
      godWorm.decTime(index);
    });
  }

  Future<void> makesound(List<int> note) async {
    setState(() {
      godWorm.updateIndex();
    });
    await Future.delayed(Duration(milliseconds: 48));
    Beep(note[0], note[1]);
  }

  @override
  Widget build(BuildContext context) {
    final ui = context.ui;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: ui.width,
              height: ui.height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    Color.fromARGB(255, 255, 182, 25), // light blue
                    Color.fromRGBO(27, 255, 247, 1), // teal
                  ],
                ),
              ),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 32,
                          offset: Offset(0, 8),
                          color: Color(0x26000000),
                        ),
                      ],
                    ),
                    child: Column(
                      spacing: 15,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TopLister(func: addToWorm, start: 0),
                        TopLister(func: addToWorm, start: 26),
                        Snake(
                          worm: godWorm,
                          mvr: mvr,
                          mvl: mvl,
                          rmt: rmt,
                          inc: inc,
                          dec: dec,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: unmenu,
                              icon: Icon(Icons.download),
                            ),
                            IconButton(
                              onPressed: () async {
                                for (List<int> note in godWorm.track) {
                                  await makesound(note);
                                }
                              },
                              icon: Icon(Icons.play_arrow, size: 30),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            left: 0,
            top: ui.height - 10,
            child: Container(
              width: godWorm.track.isEmpty
                  ? 0
                  : ui.width * (godWorm.index / godWorm.track.length),
              height: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color.fromRGBO(27, 255, 247, 1),
                    Color.fromARGB(255, 255, 182, 25),
                  ],
                ),
              ),
            ),
          ),
          generateMenu
              ? GestureDetector(
                  onTap: unmenu,
                  child: Container(
                    width: ui.width,
                    height: ui.height,
                    color: Color(0xA6083E21),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: ui.vw(40),
                          height: ui.vh(60),
                          decoration: BoxDecoration(
                            border: BoxBorder.all(
                              color: Colors.black54,
                              width: 0.75,
                            ),
                            borderRadius: BorderRadius.circular(75),
                            color: Colors.teal,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 10,
                            children: [
                              Text(
                                "Please enter the file name",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.deepPurple,
                                ),
                                padding: EdgeInsets.all(15),
                                width: ui.vw(30),
                                height: 95,
                                child: TextField(
                                  onChanged: (change) {
                                    checkText();
                                  },
                                  controller: textController,

                                  autofocus: false,
                                  maxLength: 16,
                                  style: const TextStyle(color: Colors.white),
                                  cursorColor: Colors.tealAccent,
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    errorText: fileMakeError
                                        ? "The file name can't be empty, nor contain spaces and dots"
                                        : null,
                                    errorStyle: TextStyle(
                                      color: Colors.lightBlueAccent[100],
                                    ),
                                    errorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.amber,
                                        width: 2,
                                      ),
                                    ),
                                    focusedErrorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.amber,
                                        width: 2,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.amber,
                                        width: 2,
                                      ),
                                    ),
                                    labelText: 'Enter the FileName',
                                    hintText: 'example: "myMusicFile"',
                                    labelStyle: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),

                              Row(
                                spacing: ui.vw(10),
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: !fileMakeError
                                        ? () async {
                                            await writeFile(
                                              textController.text,
                                              godWorm.track,
                                            );
                                          }
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.lime,
                                      side: BorderSide(width: 0.5),
                                    ),
                                    child: Text(
                                      "make the file",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: unmenu,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      side: BorderSide(
                                        color: Colors.white,
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Text(
                                      "cancel",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
