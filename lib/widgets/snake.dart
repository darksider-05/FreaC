import 'package:flutter/material.dart';
import 'package:freac/core/context.dart';
import 'package:freac/core/trackholder.dart';
import 'package:win32/win32.dart';

/// the widget responsible for showing the track
class Snake extends StatelessWidget {
  const Snake({
    super.key,
    required this.worm,
    required this.mvr,
    required this.mvl,
    required this.rmt,
    required this.inc,
    required this.dec,
  });
  final TrackHolder worm;
  final Function mvr;
  final Function mvl;
  final Function rmt;
  final Function inc;
  final Function dec;

  @override
  Widget build(BuildContext context) {
    final ui = context.ui;
    ScrollController cont = ScrollController();
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
        boxShadow: const [
          BoxShadow(
            blurRadius: 32,
            offset: Offset(0, 8),
            color: Color(0x26000000),
          ),
        ],
      ),
      width: ui.vw(60),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 120,
            child: Scrollbar(
              controller: cont,
              interactive: true,
              thumbVisibility: true,
              child: ListView.builder(
                controller: cont,
                scrollDirection: Axis.horizontal,
                itemCount: worm.track.length,
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                    color: Colors.tealAccent,
                    borderRadius: index == 0
                        ? BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            topLeft: Radius.circular(10),
                          )
                        : index == worm.track.length - 1
                        ? BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          )
                        : null,
                  ),
                  height: 100,

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // play
                      GestureDetector(
                        onTap: () {
                          Beep(worm.track[index][0], worm.track[index][1]);
                        },

                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () => mvl(index),
                              icon: Icon(Icons.arrow_left),
                            ),
                            Text(worm.track[index][0].toString()),
                            IconButton(
                              onPressed: () => mvr(index),
                              icon: Icon(Icons.arrow_right),
                            ),
                          ],
                        ),
                      ),

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => dec(index),
                            icon: Icon(Icons.remove),
                          ),
                          Text(worm.track[index][1].toString()),
                          IconButton(
                            onPressed: () => inc(index),
                            icon: Icon(Icons.add),
                          ),
                        ],
                      ),

                      //remove
                      IconButton(
                        onPressed: () => rmt(index),
                        icon: Icon(Icons.cancel_outlined),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
