import 'dart:math';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
//import 'package:flutter_acrylic/flutter_acrylic.dart';

void main() /*async*/ {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Taquin());
  // await Window.initialize();

  doWhenWindowReady(
    () {
      appWindow.alignment = Alignment.center;
      appWindow.size = const Size(630, 750);
      appWindow.minSize = const Size(630, 750);
      appWindow.maxSize = const Size(630, 750);
      appWindow.show();
    },
  );
}

class Taquin extends StatelessWidget {
  const Taquin({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return const MaterialApp(
          home: Puzzle(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class Puzzle extends StatefulWidget {
  const Puzzle({super.key});

  @override
  State<Puzzle> createState() => _PuzzleState();
}

class _PuzzleState extends State<Puzzle> {
  List<int> numbers = <int>[1, 2, 3, 4, 5, 6, 7, 8, 0];

  @override
  void dispose() {
    numbers.clear();
    super.dispose();
  }

  @override
  void initState() {
    numbers.shuffle();
    // blurer();
    super.initState();
  }

  /*void blurer() async {
    await Window.setEffect(effect: WindowEffect.aero);
  }*/

  @override
  Widget build(BuildContext context) {
    double minimum = max(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 32, 59),
      extendBodyBehindAppBar: false,
      extendBody: true,
      body: Column(
        children: [
          WindowTitleBarBox(
            child: Row(
              children: [
                Expanded(
                  child: MoveWindow(),
                ),
                MinimizeWindowButton(),
                MaximizeWindowButton(),
                CloseWindowButton(
                  colors: WindowButtonColors(
                    normal: Colors.pinkAccent,
                    iconNormal: Colors.white,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: Center(
                child: GridView.builder(
                  //physics: const NeverScrollableScrollPhysics(),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 16.0,
                      crossAxisSpacing: 16.0,
                      childAspectRatio: 1.0,
                      mainAxisExtent: MediaQuery.of(context).size.width / 3),
                  itemCount: numbers.length,
                  itemBuilder: (context, index) {
                    return numbers[index] == 0
                        ? const SizedBox()
                        : InkWell(
                            onTap: () {
                              setState(() {
                                if ((index - 1 >= 0 &&
                                        numbers[index - 1] == 0 &&
                                        index % 3 != 0) ||
                                    (index + 1 < 9 &&
                                        numbers[index + 1] == 0 &&
                                        (index + 1) % 3 != 0) ||
                                    ((index - 3) >= 0 &&
                                        numbers[index - 3] == 0) ||
                                    ((index + 3) < 9 &&
                                        numbers[index + 3] == 0)) {
                                  numbers[numbers.indexOf(0)] = numbers[index];
                                  numbers[index] = 0;
                                }
                              });
                              if (numbers == [1, 2, 3, 4, 5, 6, 7, 8, 0]) {
                                print("u win");
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors
                                    .lightGreenAccent, //Colors.primaries[index % Colors.primaries.length],
                              ),
                              height: minimum / 3,
                              width: minimum / 3,
                              child: Center(
                                child: Text(
                                  numbers[index].toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          (MediaQuery.of(context).size.width /
                                                  3) *
                                              .5,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          );
                  },
                ),
              ),
            ),
          ),
          Center(
            child: IconButton(
              onPressed: () {
                setState(() {
                  numbers.shuffle();
                });
              },
              icon: const Icon(
                Icons.restart_alt,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
