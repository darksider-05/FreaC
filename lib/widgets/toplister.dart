import 'package:flutter/material.dart';
import 'package:win32/win32.dart';

/// the static widget that allows adding tracks
class TopLister extends StatefulWidget {
  const TopLister({super.key, required this.func, required this.start});
  final Function func;
  final int start;

  @override
  State<TopLister> createState() => _TopListerState();
}

class _TopListerState extends State<TopLister> {
  @override
  Widget build(BuildContext context) {
    List<int> sounds = [
      for (int i = widget.start; i < widget.start + 26; i++) 20 * i,
    ];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        sounds.length,
        (index) => Container(
          decoration: BoxDecoration(
            color: Colors.tealAccent,
            borderRadius: index == 0
                ? BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  )
                : index == sounds.length - 1
                ? BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  )
                : null,
          ),
          height: 100,

          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () => widget.func([sounds[index], 200]),
                      icon: Icon(Icons.add, size: 20),
                    ),
                    IconButton(
                      onPressed: () {
                        Beep(sounds[index], 200);
                      },
                      icon: Icon(Icons.volume_up, size: 20),
                    ),
                  ],
                ),
              ),
              Center(child: Text("  ${sounds[index]}")),
            ],
          ),
        ),
      ),
    );
  }
}
