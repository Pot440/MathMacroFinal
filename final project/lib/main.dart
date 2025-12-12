import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'globals.dart';
import 'dart:math';
import 'dart:ui';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Math Macro',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {

  void pushUpdate() {
    notifyListeners();
  }
}



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var SelectedIndex = 0;
  List<Widget> kids = [];
  //initialize field for blocks

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    //dynamically size everything to screen resolution
    //theoretically supports landscape orientation, would require more logic

    final theme = Theme.of(context);

    final TextStyle listStyle = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.primary,
      fontSize: 100,
    );
    //set large font, FittedBox will scale text down to fit widgets

    void addKid(Widget newKid) {
      kids.add(
        newKid
      );
      refNumbers++;
      functionList.add(
        [0.0, 0.0]
        //list of values mapped to each widget
        // [stored value, type(0: float, 1: list)]
      );
      arrayList.add(
        []
      );
      coordList.add (
        Offset(0.0, 0.0)
        //list of coordinates of each widget, used in drawing
        //defaults to 0.0
      );
      connectionList.add(
        []
      );
      setState((){});
    } //add new widget to stack and update

    void Rebuild() {
      for (int i = 0; i < globalKeyList.length; i++) {
        //repeats for number of widgets to ensure everything has the newest data
        //could be improved with logic to get length of longest widget chain
        for (var i in globalKeyList) {
          if (i is GlobalKey<_TestingState>) {
            i.currentState?.doMath();
          }
        }
      }
    } //referenced by math widgets when passing data, makes all widgets recalculate/update
    //doMath() calling a setState internally means there's no need to setState the stack

    void clearKids() {
      kids = [];
      kids.add(
        //delete button needs to be readded since it's in the same stack as the math widgets
        Positioned(
          top: screenHeight/40,
          child: ElevatedButton(
            onPressed: clearKids, 
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Icon(
                Icons.delete,
              ),
            ),
          ),
        )
      );
      refNumbers = 0;
      functionList = [];
      globalKeyList = [];
      coordList = [];
      connectionList = [];
      setState((){});
    }
    //wipe widgets from stack and update

    kids.add(
      Positioned(
        top: screenHeight/40,
        child: ElevatedButton(
          onPressed: clearKids, 
          child: FittedBox(
            fit: BoxFit.fitHeight,
            child: Icon(
              Icons.delete,
            ),
          ),
        ),
      )
    );

    return Column(
      children: [
        Container(          
          color: theme.colorScheme.secondaryContainer,
          width: screenWidth,
          height: screenHeight * (3/4),
          child: CustomPaint (
            painter: LinePainter(),
            child: Stack(
              children: kids,
              //Stack automatically renders new widgets based off of the list provided
            )
          ),
        ),
        Container(
          color: theme.colorScheme.secondary,
          width: screenWidth,
          height: screenHeight * (1/4),
          child: GridView.count(
            crossAxisCount: 2,
            scrollDirection: Axis.horizontal,
            children: [
              //provides data for each selectable widget in the list
              //by passing a globalkey and adding reference to it to a global list
              //the parent function can easily tell each of them to update
              LongPressDraggable(
                dragAnchorStrategy:
                  (Draggable<Object> _, BuildContext __, Offset ___) =>
                    Offset(screenHeight/24, screenHeight/24),
                feedback: MathCardBase(
                  symbol: 'IN',
                  type: "input",
                  givenColor: theme.colorScheme.onSecondary,
                  givenStyle: listStyle,
                  ),
                child: DragCardBase(
                  givenColor: theme.colorScheme.onSecondary,
                  givenStyle: listStyle,
                  symbol: 'IN'),
                onDragEnd: (details) {
                  details.offset.dx;
                  details.offset.dy;

                  addKid(
                    TestingText(
                      myID: refNumbers,
                      pushUpdate: () {
                        Rebuild();
                      },
                      symbol: 'IN',
                      type: "input",
                      givenColor: theme.colorScheme.onSecondary,
                      givenStyle: listStyle,
                      x_: details.offset.dx,
                      y_: details.offset.dy,
                    )
                  );
                }
              ),
              LongPressDraggable(
                dragAnchorStrategy:
                  (Draggable<Object> _, BuildContext __, Offset ___) =>
                    Offset(screenHeight/24, screenHeight/24),
                feedback: MathCardBase(
                  symbol: 'OUT',
                  type: "output",
                  givenColor: theme.colorScheme.onSecondary,
                  givenStyle: listStyle,
                  ),
                child: DragCardBase(
                  givenColor: theme.colorScheme.onSecondary,
                  givenStyle: listStyle,
                  symbol: 'OUT'),
                onDragEnd: (details) {
                  details.offset.dx;
                  details.offset.dy;
                  GlobalKey<_TestingState> keyThing = GlobalKey();
                  addKid(
                    Testing(
                      key: keyThing,
                      myID: refNumbers,
                      pushUpdate: () {
                        Rebuild();
                      },
                      symbol: 'OUT',
                      type: "output",
                      givenColor: theme.colorScheme.onSecondary,
                      givenStyle: listStyle,
                      x_: details.offset.dx,
                      y_: details.offset.dy,
                    )
                  );
                  globalKeyList.add(keyThing);
                }
              ),
              LongPressDraggable(
                dragAnchorStrategy:
                  (Draggable<Object> _, BuildContext __, Offset ___) =>
                    Offset(screenHeight/24, screenHeight/24),
                feedback: MathCardBase(
                  symbol: '+',
                  type: "add",
                  givenColor: theme.colorScheme.onSecondary,
                  givenStyle: listStyle,
                  ),
                child: DragCardBase(
                  givenColor: theme.colorScheme.onSecondary,
                  givenStyle: listStyle,
                  symbol: '+'),
                onDragEnd: (details) {
                  details.offset.dx;
                  details.offset.dy;
                  GlobalKey<_TestingState> keyThing = GlobalKey();
                  addKid(
                    Testing(
                      key: keyThing,
                      myID: refNumbers,
                      pushUpdate: () {
                        Rebuild();
                      },
                      symbol: '+',
                      type: "add",
                      givenColor: theme.colorScheme.onSecondary,
                      givenStyle: listStyle,
                      x_: details.offset.dx,
                      y_: details.offset.dy,
                    )
                  );
                  globalKeyList.add(keyThing);
                }
              ),
              LongPressDraggable(
                dragAnchorStrategy:
                  (Draggable<Object> _, BuildContext __, Offset ___) =>
                    Offset(screenHeight/24, screenHeight/24),
                feedback: MathCardBase(
                  symbol: '-',
                  type: "subtract",
                  givenColor: theme.colorScheme.onSecondary,
                  givenStyle: listStyle,
                  ),
                child: DragCardBase(
                  givenColor: theme.colorScheme.onSecondary,
                  givenStyle: listStyle,
                  symbol: '-'),
                onDragEnd: (details) {
                  details.offset.dx;
                  details.offset.dy;
                  GlobalKey<_TestingState> keyThing = GlobalKey();
                  addKid(
                    Testing(
                      key: keyThing,
                      myID: refNumbers,
                      pushUpdate: () {
                        Rebuild();
                      },
                      symbol: '-',
                      type: "subtract",
                      givenColor: theme.colorScheme.onSecondary,
                      givenStyle: listStyle,
                      x_: details.offset.dx,
                      y_: details.offset.dy,
                    )
                  );
                  globalKeyList.add(keyThing);
                }
              ),
              LongPressDraggable(
                dragAnchorStrategy:
                  (Draggable<Object> _, BuildContext __, Offset ___) =>
                    Offset(screenHeight/24, screenHeight/24),
                feedback: MathCardBase(
                  symbol: 'x',
                  type: "multiply",
                  givenColor: theme.colorScheme.onSecondary,
                  givenStyle: listStyle,
                  ),
                child: DragCardBase(
                  givenColor: theme.colorScheme.onSecondary,
                  givenStyle: listStyle,
                  symbol: 'x'),
                onDragEnd: (details) {
                  details.offset.dx;
                  details.offset.dy;
                  GlobalKey<_TestingState> keyThing = GlobalKey();
                  addKid(
                    Testing(
                      key: keyThing,
                      myID: refNumbers,
                      pushUpdate: () {
                        Rebuild();
                      },
                      symbol: 'x',
                      type: "multiply",
                      givenColor: theme.colorScheme.onSecondary,
                      givenStyle: listStyle,
                      x_: details.offset.dx,
                      y_: details.offset.dy,
                    )
                  );
                  globalKeyList.add(keyThing);
                }
              ),
              LongPressDraggable(
                dragAnchorStrategy:
                  (Draggable<Object> _, BuildContext __, Offset ___) =>
                    Offset(screenHeight/24, screenHeight/24),
                feedback: MathCardBase(
                  symbol: '÷',
                  type: "divide",
                  givenColor: theme.colorScheme.onSecondary,
                  givenStyle: listStyle,
                  ),
                child: DragCardBase(
                  givenColor: theme.colorScheme.onSecondary,
                  givenStyle: listStyle,
                  symbol: '÷'),
                onDragEnd: (details) {
                  details.offset.dx;
                  details.offset.dy;
                  GlobalKey<_TestingState> keyThing = GlobalKey();
                  addKid(
                    Testing(
                      key: keyThing,
                      myID: refNumbers,
                      pushUpdate: () {
                        Rebuild();
                      },
                      symbol: '÷',
                      type: "divide",
                      givenColor: theme.colorScheme.onSecondary,
                      givenStyle: listStyle,
                      x_: details.offset.dx,
                      y_: details.offset.dy,
                    )
                  );
                  globalKeyList.add(keyThing);
                }
              ),
              LongPressDraggable(
                dragAnchorStrategy:
                  (Draggable<Object> _, BuildContext __, Offset ___) =>
                    Offset(screenHeight/24, screenHeight/24),
                feedback: MathCardBase(
                  symbol: '^',
                  type: "power",
                  givenColor: theme.colorScheme.onSecondary,
                  givenStyle: listStyle,
                  ),
                child: DragCardBase(
                  givenColor: theme.colorScheme.onSecondary,
                  givenStyle: listStyle,
                  symbol: '^'),
                onDragEnd: (details) {
                  details.offset.dx;
                  details.offset.dy;
                  GlobalKey<_TestingState> keyThing = GlobalKey();
                  addKid(
                    Testing(
                      key: keyThing,
                      myID: refNumbers,
                      pushUpdate: () {
                        Rebuild();
                      },
                      symbol: '^',
                      type: "power",
                      givenColor: theme.colorScheme.onSecondary,
                      givenStyle: listStyle,
                      x_: details.offset.dx,
                      y_: details.offset.dy,
                    )
                  );
                  globalKeyList.add(keyThing);
                }
              ),
              LongPressDraggable(
                dragAnchorStrategy:
                  (Draggable<Object> _, BuildContext __, Offset ___) =>
                    Offset(screenHeight/24, screenHeight/24),
                feedback: MathCardBase(
                  symbol: '√',
                  type: "root",
                  givenColor: theme.colorScheme.onSecondary,
                  givenStyle: listStyle,
                  ),
                child: DragCardBase(
                  givenColor: theme.colorScheme.onSecondary,
                  givenStyle: listStyle,
                  symbol: '√'),
                onDragEnd: (details) {
                  details.offset.dx;
                  details.offset.dy;
                  GlobalKey<_TestingState> keyThing = GlobalKey();
                  addKid(
                    Testing(
                      key: keyThing,
                      myID: refNumbers,
                      pushUpdate: () {
                        Rebuild();
                      },
                      symbol: '√',
                      type: "root",
                      givenColor: theme.colorScheme.onSecondary,
                      givenStyle: listStyle,
                      x_: details.offset.dx,
                      y_: details.offset.dy,
                    )
                  );
                  globalKeyList.add(keyThing);
                }
              ),
              LongPressDraggable(
                dragAnchorStrategy:
                  (Draggable<Object> _, BuildContext __, Offset ___) =>
                    Offset(screenHeight/24, screenHeight/24),
                feedback: MathCardBase(
                  symbol: 'E',
                  type: "bige",
                  givenColor: theme.colorScheme.onSecondary,
                  givenStyle: listStyle,
                  ),
                child: DragCardBase(
                  givenColor: theme.colorScheme.onSecondary,
                  givenStyle: listStyle,
                  symbol: 'E'),
                onDragEnd: (details) {
                  details.offset.dx;
                  details.offset.dy;
                  GlobalKey<_TestingState> keyThing = GlobalKey();
                  addKid(
                    Testing(
                      key: keyThing,
                      myID: refNumbers,
                      pushUpdate: () {
                        Rebuild();
                      },
                      symbol: 'E',
                      type: "bige",
                      givenColor: theme.colorScheme.onSecondary,
                      givenStyle: listStyle,
                      x_: details.offset.dx,
                      y_: details.offset.dy,
                    )
                  );
                  globalKeyList.add(keyThing);
                }
              ),
              LongPressDraggable(
                dragAnchorStrategy:
                  (Draggable<Object> _, BuildContext __, Offset ___) =>
                    Offset(screenHeight/24, screenHeight/24),
                feedback: MathCardBase(
                  symbol: 'ABS',
                  type: "abs",
                  givenColor: theme.colorScheme.onSecondary,
                  givenStyle: listStyle,
                  ),
                child: DragCardBase(
                  givenColor: theme.colorScheme.onSecondary,
                  givenStyle: listStyle,
                  symbol: 'ABS'),
                onDragEnd: (details) {
                  details.offset.dx;
                  details.offset.dy;
                  GlobalKey<_TestingState> keyThing = GlobalKey();
                  addKid(
                    Testing(
                      key: keyThing,
                      myID: refNumbers,
                      pushUpdate: () {
                        Rebuild();
                      },
                      symbol: 'ABS',
                      type: "abs",
                      givenColor: theme.colorScheme.onSecondary,
                      givenStyle: listStyle,
                      x_: details.offset.dx,
                      y_: details.offset.dy,
                    )
                  );
                  globalKeyList.add(keyThing);
                }
              ),
              LongPressDraggable(
                dragAnchorStrategy:
                  (Draggable<Object> _, BuildContext __, Offset ___) =>
                    Offset(screenHeight/24, screenHeight/24),
                feedback: MathCardBase(
                  symbol: 'ROUND',
                  type: "round",
                  givenColor: theme.colorScheme.onSecondary,
                  givenStyle: listStyle,
                  ),
                child: DragCardBase(
                  givenColor: theme.colorScheme.onSecondary,
                  givenStyle: listStyle,
                  symbol: 'ROUND'),
                onDragEnd: (details) {
                  details.offset.dx;
                  details.offset.dy;
                  GlobalKey<_TestingState> keyThing = GlobalKey();
                  addKid(
                    Testing(
                      key: keyThing,
                      myID: refNumbers,
                      pushUpdate: () {
                        Rebuild();
                      },
                      symbol: 'ROUND',
                      type: "round",
                      givenColor: theme.colorScheme.onSecondary,
                      givenStyle: listStyle,
                      x_: details.offset.dx,
                      y_: details.offset.dy,
                    )
                  );
                  globalKeyList.add(keyThing);
                }
              ),
              LongPressDraggable(
                dragAnchorStrategy:
                  (Draggable<Object> _, BuildContext __, Offset ___) =>
                    Offset(screenHeight/24, screenHeight/24),
                feedback: MathCardBase(
                  symbol: '%',
                  type: "mod",
                  givenColor: theme.colorScheme.onSecondary,
                  givenStyle: listStyle,
                  ),
                child: DragCardBase(
                  givenColor: theme.colorScheme.onSecondary,
                  givenStyle: listStyle,
                  symbol: '%'),
                onDragEnd: (details) {
                  details.offset.dx;
                  details.offset.dy;
                  GlobalKey<_TestingState> keyThing = GlobalKey();
                  addKid(
                    Testing(
                      key: keyThing,
                      myID: refNumbers,
                      pushUpdate: () {
                        Rebuild();
                      },
                      symbol: '%',
                      type: "mod",
                      givenColor: theme.colorScheme.onSecondary,
                      givenStyle: listStyle,
                      x_: details.offset.dx,
                      y_: details.offset.dy,
                    )
                  );
                  globalKeyList.add(keyThing);
                }
              ),
              LongPressDraggable(
                dragAnchorStrategy:
                  (Draggable<Object> _, BuildContext __, Offset ___) =>
                    Offset(screenHeight/24, screenHeight/24),
                feedback: MathCardBase(
                  symbol: 'SIN',
                  type: "sin",
                  givenColor: theme.colorScheme.onSecondary,
                  givenStyle: listStyle,
                  ),
                child: DragCardBase(
                  givenColor: theme.colorScheme.onSecondary,
                  givenStyle: listStyle,
                  symbol: 'SIN'),
                onDragEnd: (details) {
                  details.offset.dx;
                  details.offset.dy;
                  GlobalKey<_TestingState> keyThing = GlobalKey();
                  addKid(
                    Testing(
                      key: keyThing,
                      myID: refNumbers,
                      pushUpdate: () {
                        Rebuild();
                      },
                      symbol: 'SIN',
                      type: "sin",
                      givenColor: theme.colorScheme.onSecondary,
                      givenStyle: listStyle,
                      x_: details.offset.dx,
                      y_: details.offset.dy,
                    )
                  );
                  globalKeyList.add(keyThing);
                }
              ),
              LongPressDraggable(
                dragAnchorStrategy:
                  (Draggable<Object> _, BuildContext __, Offset ___) =>
                    Offset(screenHeight/24, screenHeight/24),
                feedback: MathCardBase(
                  symbol: 'SIN-1',
                  type: "arcsin",
                  givenColor: theme.colorScheme.onSecondary,
                  givenStyle: listStyle,
                  ),
                child: DragCardBase(
                  givenColor: theme.colorScheme.onSecondary,
                  givenStyle: listStyle,
                  symbol: 'SIN-1'),
                onDragEnd: (details) {
                  details.offset.dx;
                  details.offset.dy;
                  GlobalKey<_TestingState> keyThing = GlobalKey();
                  addKid(
                    Testing(
                      key: keyThing,
                      myID: refNumbers,
                      pushUpdate: () {
                        Rebuild();
                      },
                      symbol: 'SIN-1',
                      type: "arcsin",
                      givenColor: theme.colorScheme.onSecondary,
                      givenStyle: listStyle,
                      x_: details.offset.dx,
                      y_: details.offset.dy,
                    )
                  );
                  globalKeyList.add(keyThing);
                }
              ),
              LongPressDraggable(
                dragAnchorStrategy:
                  (Draggable<Object> _, BuildContext __, Offset ___) =>
                    Offset(screenHeight/24, screenHeight/24),
                feedback: MathCardBase(
                  symbol: 'COS',
                  type: "cos",
                  givenColor: theme.colorScheme.onSecondary,
                  givenStyle: listStyle,
                  ),
                child: DragCardBase(
                  givenColor: theme.colorScheme.onSecondary,
                  givenStyle: listStyle,
                  symbol: 'COS'),
                onDragEnd: (details) {
                  details.offset.dx;
                  details.offset.dy;
                  GlobalKey<_TestingState> keyThing = GlobalKey();
                  addKid(
                    Testing(
                      key: keyThing,
                      myID: refNumbers,
                      pushUpdate: () {
                        Rebuild();
                      },
                      symbol: 'COS',
                      type: "cos",
                      givenColor: theme.colorScheme.onSecondary,
                      givenStyle: listStyle,
                      x_: details.offset.dx,
                      y_: details.offset.dy,
                    )
                  );
                  globalKeyList.add(keyThing);
                }
              ),
              LongPressDraggable(
                dragAnchorStrategy:
                  (Draggable<Object> _, BuildContext __, Offset ___) =>
                    Offset(screenHeight/24, screenHeight/24),
                feedback: MathCardBase(
                  symbol: 'COS-1',
                  type: "arccos",
                  givenColor: theme.colorScheme.onSecondary,
                  givenStyle: listStyle,
                  ),
                child: DragCardBase(
                  givenColor: theme.colorScheme.onSecondary,
                  givenStyle: listStyle,
                  symbol: 'COS-1'),
                onDragEnd: (details) {
                  details.offset.dx;
                  details.offset.dy;
                  GlobalKey<_TestingState> keyThing = GlobalKey();
                  addKid(
                    Testing(
                      key: keyThing,
                      myID: refNumbers,
                      pushUpdate: () {
                        Rebuild();
                      },
                      symbol: 'COS-1',
                      type: "arccos",
                      givenColor: theme.colorScheme.onSecondary,
                      givenStyle: listStyle,
                      x_: details.offset.dx,
                      y_: details.offset.dy,
                    )
                  );
                  globalKeyList.add(keyThing);
                }
              ),
              LongPressDraggable(
                dragAnchorStrategy:
                  (Draggable<Object> _, BuildContext __, Offset ___) =>
                    Offset(screenHeight/24, screenHeight/24),
                feedback: MathCardBase(
                  symbol: 'TAN',
                  type: "tan",
                  givenColor: theme.colorScheme.onSecondary,
                  givenStyle: listStyle,
                  ),
                child: DragCardBase(
                  givenColor: theme.colorScheme.onSecondary,
                  givenStyle: listStyle,
                  symbol: 'TAN'),
                onDragEnd: (details) {
                  details.offset.dx;
                  details.offset.dy;
                  GlobalKey<_TestingState> keyThing = GlobalKey();
                  addKid(
                    Testing(
                      key: keyThing,
                      myID: refNumbers,
                      pushUpdate: () {
                        Rebuild();
                      },
                      symbol: 'TAN',
                      type: "tan",
                      givenColor: theme.colorScheme.onSecondary,
                      givenStyle: listStyle,
                      x_: details.offset.dx,
                      y_: details.offset.dy,
                    )
                  );
                  globalKeyList.add(keyThing);
                }
              ),
              LongPressDraggable(
                dragAnchorStrategy:
                  (Draggable<Object> _, BuildContext __, Offset ___) =>
                    Offset(screenHeight/24, screenHeight/24),
                feedback: MathCardBase(
                  symbol: 'TAN-1',
                  type: "arctan",
                  givenColor: theme.colorScheme.onSecondary,
                  givenStyle: listStyle,
                  ),
                child: DragCardBase(
                  givenColor: theme.colorScheme.onSecondary,
                  givenStyle: listStyle,
                  symbol: 'TAN-1'),
                onDragEnd: (details) {
                  details.offset.dx;
                  details.offset.dy;
                  GlobalKey<_TestingState> keyThing = GlobalKey();
                  addKid(
                    Testing(
                      key: keyThing,
                      myID: refNumbers,
                      pushUpdate: () {
                        Rebuild();
                      },
                      symbol: 'TAN-1',
                      type: "arctan",
                      givenColor: theme.colorScheme.onSecondary,
                      givenStyle: listStyle,
                      x_: details.offset.dx,
                      y_: details.offset.dy,
                    )
                  );
                  globalKeyList.add(keyThing);
                }
              ),
              LongPressDraggable(
                dragAnchorStrategy:
                  (Draggable<Object> _, BuildContext __, Offset ___) =>
                    Offset(screenHeight/24, screenHeight/24),
                feedback: MathCardBase(
                  symbol: 'SUM',
                  type: "sum",
                  givenColor: theme.colorScheme.onSecondary,
                  givenStyle: listStyle,
                  ),
                child: DragCardBase(
                  givenColor: theme.colorScheme.onSecondary,
                  givenStyle: listStyle,
                  symbol: 'SUM'),
                onDragEnd: (details) {
                  details.offset.dx;
                  details.offset.dy;
                  GlobalKey<_TestingState> keyThing = GlobalKey();
                  addKid(
                    Testing(
                      key: keyThing,
                      myID: refNumbers,
                      pushUpdate: () {
                        Rebuild();
                      },
                      symbol: 'SUM',
                      type: "sum",
                      givenColor: theme.colorScheme.onSecondary,
                      givenStyle: listStyle,
                      x_: details.offset.dx,
                      y_: details.offset.dy,
                    )
                  );
                  globalKeyList.add(keyThing);
                }
              ),
              LongPressDraggable(
                dragAnchorStrategy:
                  (Draggable<Object> _, BuildContext __, Offset ___) =>
                    Offset(screenHeight/24, screenHeight/24),
                feedback: MathCardBase(
                  symbol: 'COUNT',
                  type: "count",
                  givenColor: theme.colorScheme.onSecondary,
                  givenStyle: listStyle,
                  ),
                child: DragCardBase(
                  givenColor: theme.colorScheme.onSecondary,
                  givenStyle: listStyle,
                  symbol: 'COUNT'),
                onDragEnd: (details) {
                  details.offset.dx;
                  details.offset.dy;
                  GlobalKey<_TestingState> keyThing = GlobalKey();
                  addKid(
                    Testing(
                      key: keyThing,
                      myID: refNumbers,
                      pushUpdate: () {
                        Rebuild();
                      },
                      symbol: 'COUNT',
                      type: "count",
                      givenColor: theme.colorScheme.onSecondary,
                      givenStyle: listStyle,
                      x_: details.offset.dx,
                      y_: details.offset.dy,
                    )
                  );
                  globalKeyList.add(keyThing);
                }
              ),
              Card(
                color: theme.colorScheme.primary,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                )
              ),
              Card(
                color: theme.colorScheme.primary,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                )
              ),
          
            ],
            ),
        )
      ],
    );
  }
}

class LinePainter extends CustomPainter {

  var linePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10.0
    ..color = const Color.fromARGB(255, 74, 212, 212);

  @override
  void paint(Canvas canvas, Size size) {
    if (connectionList.isNotEmpty) {
      for (int i = 0; i < connectionList.length; i++) {
        if (connectionList[i].isNotEmpty) {
          for (var j in connectionList[i]) {
            //generate a gradient shader, rotate and resize depending on constituent parts
            linePaint.shader = LinearGradient(
              colors: [
              Color.fromARGB(255, 0, 0, 0),
              Color.fromARGB(255, 0, 195, 255),
              Color.fromARGB(255, 9, 105, 134),
              ],
              stops: [
                0.0,
                0.5,
                1.0
              ],
              transform: GradientRotation(atan2(
                (coordList[j].dy - coordList[i].dy), 
                (coordList[j].dx - coordList[i].dx)
                )),
            ).createShader(Rect.fromCenter(
              center: coordList[i],
              width: (coordList[i] - coordList[j]).distance,
              height: 30
            ));
            canvas.drawLine(coordList[i], coordList[j], linePaint);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Testing extends StatefulWidget {

  double x_;
  double y_;
  final String type;
  String symbol;
  final Color givenColor;
  final TextStyle givenStyle;
  final int myID; //each widget has an integer id mapping it to locations on the global lists
  final Function() pushUpdate; //push recalculating + setstate to all other math widgets
  var inputIDs = []; //initialize list of known ids

  Testing({
    Key? key,
    required this.pushUpdate,
    this.x_ = 50, 
    this.y_ = 50,
    required this.myID,
    required this.type,
    required this.symbol,
    required this.givenColor,
    required this.givenStyle,
    }) : super(key: key);

  @override
  State<Testing> createState() => _TestingState();

}

class _TestingState extends State<Testing> {
  
  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.sizeOf(context).height;
    double widgetScale = screenHeight * 1/24;

    coordList[widget.myID] = Offset(widget.x_ + widgetScale, widget.y_ + widgetScale);
    //initialize coordinates in array

    final theme = Theme.of(context);

    final TextStyle listStyle = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.primary,
      fontSize: 100,
    );

    return Positioned(
      left: widget.x_,
      top: widget.y_,
      child: GestureDetector(
        onPanUpdate: (details) {
          widget.y_ = widget.y_ + details.delta.dy;
          widget.x_ = widget.x_ + details.delta.dx;
          coordList[widget.myID] = Offset(widget.x_ + widgetScale, widget.y_ + widgetScale);
          setState((){});
        },
        child: LongPressDraggable<int>(
          data: widget.myID,
          dragAnchorStrategy:
              (Draggable<Object> _, BuildContext __, Offset ___) =>
                 Offset(widgetScale/2, widgetScale/2), 
                 //force dragging to center the widget
          feedback: ConnectionPointer(
            sourceID: widget.myID,
            givenScale: widgetScale
          ),
          child: DragTarget<int>(
            onWillAcceptWithDetails: (info) {
              switch (widget.type) {
                //precautionary in case future widgets need to deny certain data types
                //not yet used
                default:
                if (info.data == widget.myID ) {
                  return false;
                }
                if (widget.inputIDs.contains(info.data)) {
                  return false;
                }
                else {
                  return true;
                }
              }
            },
            onAcceptWithDetails: (info) {
              widget.inputIDs.add(info.data);
              connectionList[widget.myID].add(info.data);
              doMath();
              widget.pushUpdate();
              //accept widget ID and update + push all widgets to update
              widget.x_ += 0.0000001;
              setState(() {});
            },
            builder: (
              context, 
              List<dynamic> accepted,
              List<dynamic> rejected,
            ) {
              return Card(
                color: theme.colorScheme.onSecondary,
                child: Container(
                  width: screenHeight * 1/12,
                  height: screenHeight * 1/12,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Center(
                      child: Text(
                        style: listStyle,
                        widget.symbol,
                      )
                    ),
                  )
                )
              );
            }
          )
        ),
      )
    );
  }
  
  void doMath() {
    //uses switch case to determine which logic to use
    //should probably have doMath() passed in as a variable on refactor for more dynamic behavior
    switch (widget.type) {
                //each case has internal logic to handle lists and single values
                //dart passes a pointer to lists, must be reassembled

                case "add":
                  if (widget.inputIDs.length > 1) {
                    if (functionList[widget.inputIDs[0]][1] == 0.0) {
                      double j = 0;
                      for (var i in widget.inputIDs) {
                        if (functionList[i][1] == 1.0) {
                          j = j + arrayList[i][0];
                        }
                        else {
                          j = j + functionList[i][0];
                        }
                      }
                      functionList[widget.myID][0] = j;
                      functionList[widget.myID][1] = 0.0;
                    }
                    else {
                      List j = [];
                      for (var i in arrayList[widget.inputIDs[0]]) {
                        j.add(i);
                      }
                      for (int k = 1; k < widget.inputIDs.length; k++) {
                        if (functionList[widget.inputIDs[k]][1] == 0.0) {
                          for (int i = 0; i < j.length; i++) {
                            j[i] = j[i] + functionList[widget.inputIDs[k]][0];
                          }
                        }
                        else {
                          for (int i = 0; i < j.length; i++) {
                            if (arrayList[widget.inputIDs[k]].length > i) {
                              j[i] = j[i] + arrayList[widget.inputIDs[k]][i];
                            }
                          }
                        }
                      }
                      arrayList[widget.myID] = j;
                      functionList[widget.myID][1] = 1.0;
                    }
                  }
                break;

                case "subtract":
                  if (widget.inputIDs.length > 1) {
                    if (functionList[widget.inputIDs[0]][1] == 0.0) {
                      double j = functionList[widget.inputIDs[0]][0];
                      for (int i = 1; i < widget.inputIDs.length; i++) {
                        if (functionList[i][1] == 1.0) {
                          j = j - arrayList[i][0];
                        }
                        else {
                          j = j - functionList[widget.inputIDs[i]][0];
                        }
                      }
                      functionList[widget.myID][0] = j;
                      functionList[widget.myID][1] = 0.0;
                    }
                    else {
                      List j = [];
                      for (var i in arrayList[widget.inputIDs[0]]) {
                        j.add(i);
                      }
                      for (int k = 1; k < widget.inputIDs.length; k++) {
                        if (functionList[widget.inputIDs[k]][1] == 0.0) {
                          for (int i = 0; i < j.length; i++) {
                            j[i] = j[i] - functionList[widget.inputIDs[k]][0];
                          }
                        }
                        else {
                          for (int i = 0; i < j.length; i++) {
                            if (arrayList[widget.inputIDs[k]].length > i) {
                              j[i] = j[i] - arrayList[widget.inputIDs[k]][i];
                            }
                          }
                        }
                      }
                      arrayList[widget.myID] = j;
                      functionList[widget.myID][1] = 1.0;
                    }
                  }
                break;

                case "multiply":
                  if (widget.inputIDs.length > 1) {
                    if (functionList[widget.inputIDs[0]][1] == 0.0) {
                      double j = functionList[widget.inputIDs[0]][0];
                      for (int i = 1; i < widget.inputIDs.length; i++) {
                        if (functionList[widget.inputIDs[i]][1] == 1.0) {
                          j = j * arrayList[widget.inputIDs[i]][0];
                        }
                        else {
                          j = j * functionList[widget.inputIDs[i]][0];
                        }
                      }
                      functionList[widget.myID][0] = j;
                      functionList[widget.myID][1] = 0.0;
                    }
                    else {
                      List j = [];
                      for (var i in arrayList[widget.inputIDs[0]]) {
                        j.add(i);
                      }
                      for (int k = 1; k < widget.inputIDs.length; k++) {
                        if (functionList[widget.inputIDs[k]][1] == 0.0) {
                          for (int i = 0; i < j.length; i++) {
                            j[i] = j[i] * functionList[widget.inputIDs[k]][0];
                          }
                        }
                        else {
                          for (int i = 0; i < j.length; i++) {
                            if (arrayList[widget.inputIDs[k]].length > i) {
                              j[i] = j[i] * arrayList[widget.inputIDs[k]][i];
                            }
                          }
                        }
                      }
                      arrayList[widget.myID] = j;
                      functionList[widget.myID][1] = 1.0;
                    }
                  }
                break;

                case "divide":
                  if (widget.inputIDs.length > 1) {
                    if (functionList[widget.inputIDs[0]][1] == 0.0) {
                      double j = functionList[widget.inputIDs[0]][0];
                      for (int i = 1; i < widget.inputIDs.length; i++) {
                        if (functionList[widget.inputIDs[i]][1] == 1.0) {
                          j = j / arrayList[widget.inputIDs[i]][0];
                        }
                        else {
                          j = j / functionList[widget.inputIDs[i]][0];
                        }
                      }
                      functionList[widget.myID][0] = j;
                      functionList[widget.myID][1] = 0.0;
                    }
                    else {
                      List j = [];
                      for (var i in arrayList[widget.inputIDs[0]]) {
                        j.add(i);
                      }
                      for (int k = 1; k < widget.inputIDs.length; k++) {
                        if (functionList[widget.inputIDs[k]][1] == 0.0) {
                          for (int i = 0; i < j.length; i++) {
                            j[i] = j[i] / functionList[widget.inputIDs[k]][0];
                          }
                        }
                        else {
                          for (int i = 0; i < j.length; i++) {
                            if (arrayList[widget.inputIDs[k]].length > i) {
                              j[i] = j[i] / arrayList[widget.inputIDs[k]][i];
                            }
                          }
                        }
                      }
                      arrayList[widget.myID] = j;
                      functionList[widget.myID][1] = 1.0;
                    }
                  }
                break;

                case "power":
                  if (widget.inputIDs.length > 1) {
                    if (functionList[widget.inputIDs[0]][1] == 0.0) {
                      double j = functionList[widget.inputIDs[0]][0];
                      for (int i = 1; i < widget.inputIDs.length; i++) {
                        if (functionList[widget.inputIDs[i]][1] == 1.0) {
                          j = pow(j, arrayList[widget.inputIDs[i]][0]).toDouble();
                        }
                        else {
                          j = pow(j, functionList[widget.inputIDs[i]][0]).toDouble();
                        }
                      }
                      functionList[widget.myID][0] = j;
                      functionList[widget.myID][1] = 0.0;
                    }
                    else {
                      List j = [];
                      for (var i in arrayList[widget.inputIDs[0]]) {
                        j.add(i);
                      }
                      for (int k = 1; k < widget.inputIDs.length; k++) {
                        if (functionList[widget.inputIDs[k]][1] == 0.0) {
                          for (int i = 0; i < j.length; i++) {
                            j[i] = pow(j[i], functionList[widget.inputIDs[k]][0]).toDouble();
                          }
                        }
                        else {
                          for (int i = 0; i < j.length; i++) {
                            if (arrayList[widget.inputIDs[k]].length > i) {
                              j[i] = pow(j[i], arrayList[widget.inputIDs[k]][i]).toDouble();
                            }
                          }
                        }
                      }
                      arrayList[widget.myID] = j;
                      functionList[widget.myID][1] = 1.0;
                    }
                  }
                break;

                case "root":
                  if (widget.inputIDs.length > 1) {
                    if (functionList[widget.inputIDs[0]][1] == 0.0) {
                      double j = functionList[widget.inputIDs[0]][0];
                      for (int i = 1; i < widget.inputIDs.length; i++) {
                        if (functionList[widget.inputIDs[i]][1] == 1.0) {
                          j = pow(j, (1/arrayList[widget.inputIDs[i]][0])).toDouble();
                        }
                        else {
                          j = pow(j, (1/functionList[widget.inputIDs[i]][0])).toDouble();
                        }
                      }
                      functionList[widget.myID][0] = j;
                      functionList[widget.myID][1] = 0.0;
                    }
                    else {
                      List j = [];
                      for (var i in arrayList[widget.inputIDs[0]]) {
                        j.add(i);
                      }
                      for (int k = 1; k < widget.inputIDs.length; k++) {
                        if (functionList[widget.inputIDs[k]][1] == 0.0) {
                          for (int i = 0; i < j.length; i++) {
                            j[i] = pow(j[i], (1/functionList[widget.inputIDs[k]][0])).toDouble();
                          }
                        }
                        else {
                          for (int i = 0; i < j.length; i++) {
                            if (arrayList[widget.inputIDs[k]].length > i) {
                              j[i] = pow(j[i], (1/arrayList[widget.inputIDs[k]][i])).toDouble();
                            }
                          }
                        }
                      }
                      arrayList[widget.myID] = j;
                      functionList[widget.myID][1] = 1.0;
                    }
                  }
                break;

                case "bige":
                  if (widget.inputIDs.length > 1) {
                    if (functionList[widget.inputIDs[0]][1] == 0.0) {
                      double j = functionList[widget.inputIDs[0]][0];
                      for (int i = 1; i < widget.inputIDs.length; i++) {
                        if (functionList[widget.inputIDs[i]][1] == 1.0) {
                          j = j * pow(10, arrayList[widget.inputIDs[i]][0]);
                        }
                        else {
                          j = j * pow(10, functionList[widget.inputIDs[i]][0]);
                        }
                      }
                      functionList[widget.myID][0] = j;
                      functionList[widget.myID][1] = 0.0;
                    }
                    else {
                      List j = [];
                      for (var i in arrayList[widget.inputIDs[0]]) {
                        j.add(i);
                      }
                      for (int k = 1; k < widget.inputIDs.length; k++) {
                        if (functionList[widget.inputIDs[k]][1] == 0.0) {
                          for (int i = 0; i < j.length; i++) {
                            j[i] = j[i] * pow(10, functionList[widget.inputIDs[k]][0]);
                          }
                        }
                        else {
                          for (int i = 0; i < j.length; i++) {
                            if (arrayList[widget.inputIDs[k]].length > i) {
                              j[i] = j[i] * pow(10, arrayList[widget.inputIDs[k]][i]);
                            }
                          }
                        }
                      }
                      arrayList[widget.myID] = j;
                      functionList[widget.myID][1] = 1.0;
                    }
                  }
                break;

                case "mod":
                  if (widget.inputIDs.length > 1) {
                    if (functionList[widget.inputIDs[0]][1] == 0.0) {
                      double j = functionList[widget.inputIDs[0]][0];
                      for (int i = 1; i < widget.inputIDs.length; i++) {
                        if (functionList[widget.inputIDs[i]][1] == 1.0) {
                          j = j % arrayList[widget.inputIDs[i]][0];
                        }
                        else {
                          j = j % functionList[widget.inputIDs[i]][0];
                        }
                      }
                      functionList[widget.myID][0] = j;
                      functionList[widget.myID][1] = 0.0;
                    }
                    else {
                      List j = [];
                      for (var i in arrayList[widget.inputIDs[0]]) {
                        j.add(i);
                      }
                      for (int k = 1; k < widget.inputIDs.length; k++) {
                        if (functionList[widget.inputIDs[k]][1] == 0.0) {
                          for (int i = 0; i < j.length; i++) {
                            j[i] = j[i] % functionList[widget.inputIDs[k]][0];
                          }
                        }
                        else {
                          for (int i = 0; i < j.length; i++) {
                            if (arrayList[widget.inputIDs[k]].length > i) {
                              j[i] = j[i] % arrayList[widget.inputIDs[k]][i];
                            }
                          }
                        }
                      }
                      arrayList[widget.myID] = j;
                      functionList[widget.myID][1] = 1.0;
                    }
                  }
                break;

                case "abs":
                  if (widget.inputIDs.isNotEmpty){
                    widget.inputIDs = [widget.inputIDs.last];
                    connectionList[widget.myID] = widget.inputIDs;
                    if (functionList[widget.inputIDs[0]][1] == 1.0) {
                      List j = [];
                      for (int i = 0; i < arrayList[widget.inputIDs[0]].length; i++) {
                        j.add(arrayList[widget.inputIDs[0]][i].abs());
                      }
                      arrayList[widget.myID] = j;
                      functionList[widget.myID][1] = 1.0;
                    }
                    else {
                      functionList[widget.myID][0] = functionList[widget.inputIDs[0]][0].abs();
                      functionList[widget.myID][1] = 0.0;
                    }
                  }
                break;

                case "round":
                  if (widget.inputIDs.isNotEmpty){
                    widget.inputIDs = [widget.inputIDs.last];
                    connectionList[widget.myID] = widget.inputIDs;
                    if (functionList[widget.inputIDs[0]][1] == 1.0) {
                      List j = [];
                      for (int i = 0; i < arrayList[widget.inputIDs[0]].length; i++) {
                        j.add(arrayList[widget.inputIDs[0]][i].round().toDouble());
                      }
                      arrayList[widget.myID] = j;
                      functionList[widget.myID][1] = 1.0;
                    }
                    else {
                      functionList[widget.myID][0] = functionList[widget.inputIDs[0]][0].round().toDouble();
                      functionList[widget.myID][1] = 0.0;
                    }
                  }
                break;


                case "sin":
                  if (widget.inputIDs.isNotEmpty){
                    widget.inputIDs = [widget.inputIDs.last];
                    connectionList[widget.myID] = widget.inputIDs;
                    if (functionList[widget.inputIDs[0]][1] == 1.0) {
                      List j = [];
                      for (int i = 0; i < arrayList[widget.inputIDs[0]].length; i++) {
                        j.add(sin(arrayList[widget.inputIDs[0]][i]*(pi/180)));
                      }
                      arrayList[widget.myID] = j;
                      functionList[widget.myID][1] = 1.0;
                    }
                    else {
                      functionList[widget.myID][0] = sin(functionList[widget.inputIDs[0]][0]*(pi/180));
                      functionList[widget.myID][1] = 0.0;
                    }
                  }
                break;

                case "cos":
                  if (widget.inputIDs.isNotEmpty){
                    widget.inputIDs = [widget.inputIDs.last];
                    connectionList[widget.myID] = widget.inputIDs;
                    if (functionList[widget.inputIDs[0]][1] == 1.0) {
                      List j = [];
                      for (int i = 0; i < arrayList[widget.inputIDs[0]].length; i++) {
                        j.add(cos(arrayList[widget.inputIDs[0]][i]*(pi/180)));
                      }
                      arrayList[widget.myID] = j;
                      functionList[widget.myID][1] = 1.0;
                    }
                    else {
                      functionList[widget.myID][0] = cos(functionList[widget.inputIDs[0]][0]*(pi/180));
                      functionList[widget.myID][1] = 0.0;
                    }
                  }
                break;

                case "tan":
                  if (widget.inputIDs.isNotEmpty){
                    widget.inputIDs = [widget.inputIDs.last];
                    connectionList[widget.myID] = widget.inputIDs;
                    if (functionList[widget.inputIDs[0]][1] == 1.0) {
                      List j = [];
                      for (int i = 0; i < arrayList[widget.inputIDs[0]].length; i++) {
                        j.add(tan(arrayList[widget.inputIDs[0]][i]*(pi/180)));
                      }
                      arrayList[widget.myID] = j;
                      functionList[widget.myID][1] = 1.0;
                    }
                    else {
                      functionList[widget.myID][0] = tan(functionList[widget.inputIDs[0]][0]*(pi/180));
                      functionList[widget.myID][1] = 0.0;
                    }
                  }
                break;

                case "arcsin":
                  if (widget.inputIDs.isNotEmpty){
                    widget.inputIDs = [widget.inputIDs.last];
                    connectionList[widget.myID] = widget.inputIDs;
                    if (functionList[widget.inputIDs[0]][1] == 1.0) {
                      List j = [];
                      for (int i = 0; i < arrayList[widget.inputIDs[0]].length; i++) {
                        if (arrayList[widget.inputIDs[0]][i] > 1) {
                          j.add(0.0);
                        }
                        else {
                          j.add(asin(arrayList[widget.inputIDs[0]][i])*(180/pi));
                        }
                      }
                      arrayList[widget.myID] = j;
                      functionList[widget.myID][1] = 1.0;
                    }
                    else {
                      if (functionList[widget.inputIDs[0]][0] > 1) {
                        functionList[widget.myID][0] = 0.0;
                      }
                      else {
                        functionList[widget.myID][0] = asin(functionList[widget.inputIDs[0]][0])*(180/pi);
                      }
                      functionList[widget.myID][1] = 0.0;
                    }
                  }
                break;

                case "arccos":
                  if (widget.inputIDs.isNotEmpty){
                    widget.inputIDs = [widget.inputIDs.last];
                    connectionList[widget.myID] = widget.inputIDs;
                    if (functionList[widget.inputIDs[0]][1] == 1.0) {
                      List j = [];
                      for (int i = 0; i < arrayList[widget.inputIDs[0]].length; i++) {
                        if (arrayList[widget.inputIDs[0]][i] > 1) {
                          j.add(0.0);
                        }
                        else {
                          j.add(acos(arrayList[widget.inputIDs[0]][i])*(180/pi));
                        }
                      }
                      arrayList[widget.myID] = j;
                      functionList[widget.myID][1] = 1.0;
                    }
                    else {
                      if (functionList[widget.inputIDs[0]][0] > 1) {
                        functionList[widget.myID][0] = 0.0;
                      }
                      else {
                        functionList[widget.myID][0] = acos(functionList[widget.inputIDs[0]][0])*(180/pi);
                      }
                      functionList[widget.myID][1] = 0.0;
                    }
                  }
                break;

                case "arctan":
                  if (widget.inputIDs.isNotEmpty){
                    widget.inputIDs = [widget.inputIDs.last];
                    connectionList[widget.myID] = widget.inputIDs;
                    if (functionList[widget.inputIDs[0]][1] == 1.0) {
                      List j = [];
                      for (int i = 0; i < arrayList[widget.inputIDs[0]].length; i++) {
                        j.add(atan(arrayList[widget.inputIDs[0]][i])*(180/pi));
                      }
                      arrayList[widget.myID] = j;
                      functionList[widget.myID][1] = 1.0;
                    }
                    else {
                      functionList[widget.myID][0] = atan(functionList[widget.inputIDs[0]][0])*(180/pi);
                      functionList[widget.myID][1] = 0.0;
                    }
                  }
                break;

                case "sum":
                  if (widget.inputIDs.isNotEmpty){
                    widget.inputIDs = [widget.inputIDs.last];
                    connectionList[widget.myID] = widget.inputIDs;
                    if (functionList[widget.inputIDs[0]][1] == 1.0) {
                      double j = 0;
                      for (int i = 0; i < arrayList[widget.inputIDs[0]].length; i++) {
                        j = j + arrayList[widget.inputIDs[0]][i];
                      }
                      functionList[widget.myID][0] = j;
                      functionList[widget.myID][1] = 0.0;
                    }
                    else {
                      functionList[widget.myID][0] = functionList[widget.inputIDs[0]][0];
                      functionList[widget.myID][1] = 0.0;
                    }
                  }
                break;

                case "count":
                  if (widget.inputIDs.isNotEmpty){
                    widget.inputIDs = [widget.inputIDs.last];
                    connectionList[widget.myID] = widget.inputIDs;
                    if (functionList[widget.inputIDs[0]][1] == 1.0) {
                      double j = 0;
                      for (int i = 0; i < arrayList[widget.inputIDs[0]].length; i++) {
                        j++;
                      }
                      functionList[widget.myID][0] = j;
                      functionList[widget.myID][1] = 0.0;
                    }
                    else {
                      functionList[widget.myID][0] = 1.0;
                      functionList[widget.myID][1] = 0.0;
                    }
                  }
                break;
                
                case "output":
                  if (widget.inputIDs.isNotEmpty) {
                  widget.inputIDs = [widget.inputIDs.last];
                  connectionList[widget.myID] = widget.inputIDs;
                  if (functionList[widget.inputIDs[0]][1] == 0.0) {
                    if (functionList[widget.inputIDs[0]][0] % 1 == 0) {
                      if (functionList[widget.inputIDs[0]][0].toInt().toString().length < 5) {
                        widget.symbol = functionList[widget.inputIDs[0]][0].toInt().toString();
                      }
                      else {
                        widget.symbol = functionList[widget.inputIDs[0]][0].toStringAsPrecision(5);
                      }
                    }
                    else {
                      widget.symbol = functionList[widget.inputIDs[0]][0].toStringAsPrecision(5);
                    }
                    functionList[widget.myID][0] = functionList[widget.inputIDs[0]][0];
                    functionList[widget.myID][1] = 0.0;
                  }
                  else if (functionList[widget.inputIDs[0]][1] == 1.0){
                    List displaylist = [];
                    for (var i in arrayList[widget.inputIDs[0]]) {
                      if (i % 1 == 0) {
                        displaylist.add(i.toInt().toString());
                      }
                      else if ((i < 10) & (i % 0.1 == 0)) {
                        displaylist.add(i.toStringAsPrecision(2));
                      }
                      else {
                        displaylist.add(i.toStringAsPrecision(3));
                      }
                    }
                    List forwardlist = [];
                    for (var i in arrayList[widget.inputIDs[0]]) {
                      forwardlist.add(i);
                    }
                    widget.symbol = displaylist.join(' ');
                    arrayList[widget.myID] = forwardlist;
                    functionList[widget.myID][1] = 1.0;
                  }
                  }
                break;
              }
    setState(() {});
  }
}

class TestingText extends StatefulWidget {

  double x_;
  double y_;
  final String type;
  final String symbol;
  final Color givenColor;
  final TextStyle givenStyle;
  final int myID;
  final Function() pushUpdate;

  var inputIDs = [];

  TestingText({
    required this.myID,
    required this.pushUpdate,
    this.x_ = 50, 
    this.y_ = 50,
    required this.type,
    required this.symbol,
    required this.givenColor,
    required this.givenStyle,
  });

  @override
  State<TestingText> createState() => _TestingStateText();

}

class _TestingStateText extends State<TestingText> {
  
  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.sizeOf(context).height;
    double widgetScale = screenHeight * 1/24;

    coordList[widget.myID] = Offset(widget.x_ + widgetScale, widget.y_ + widgetScale);
    //initialize coordinates in array

    final theme = Theme.of(context);

    final TextStyle listStyle = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.primary,
      fontSize: screenHeight/40,
    );

    final testController = TextEditingController();

    return Positioned(
      left: widget.x_,
      top: widget.y_,
      child: GestureDetector(
        onPanUpdate: (details) {
          widget.y_ = widget.y_ + details.delta.dy;
          widget.x_ = widget.x_ + details.delta.dx;
          coordList[widget.myID] = Offset(widget.x_ + widgetScale, widget.y_ + widgetScale);
          setState((){});
        },
        child: LongPressDraggable<int>(
          data: widget.myID,
          dragAnchorStrategy:
              (Draggable<Object> _, BuildContext __, Offset ___) =>
                 Offset(widgetScale/2, widgetScale/2), 
          feedback: ConnectionPointer(
            sourceID: widget.myID,
            givenScale: widgetScale
          ),
          child: Card(
            color: theme.colorScheme.onSecondary,
            child: Container(
            width: screenHeight * 1/12,
            height: screenHeight * 1/12,
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: screenHeight * 1/12,
                    height: screenHeight * 1/20,
                    child: TextField(
                      style: listStyle,
                      keyboardType: TextInputType.numberWithOptions(),
                      controller: testController,
                      onChanged: (text) {
                        testController.text = testController.text.replaceAll(RegExp(r'[^0-9. -]'), '');
                        if (testController.text != '') { //check for blank string
                          //detect whether input is list or single value, parse accordingly
                          if (testController.text.contains(' ')) {
                            List textlist = testController.text.split(' ');
                            List<double> numlist = [];
                            for (var i in textlist) {
                              if (i != '') {
                                numlist.add(double.parse(i));
                              }
                            }
                            arrayList[widget.myID] = numlist;
                            functionList[widget.myID][1] = 1.0;
                          }
                          else {
                            functionList[widget.myID][0] = double.parse(testController.text);
                            functionList[widget.myID][1] = 0.0;
                          }
                        }
                        else {
                          functionList[widget.myID][0] = 0.0;
                        }
                        widget.pushUpdate();
                        }
                      ),
                  ),
                  ),
              ],
            )
            )
          )
        ),
      )
    );
  }
}

class ConnectionPointer extends StatelessWidget {

  final int sourceID;
  final double givenScale;

  const ConnectionPointer({super.key, required this.sourceID, required this.givenScale});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.cyanAccent,
        child: Container(
          width: givenScale,
          height: givenScale,
      )
    );
  }
}

class DragCardBase extends StatelessWidget {

  final Color givenColor;
  final String symbol;
  final TextStyle givenStyle;

  const DragCardBase({super.key, required this.givenColor, required this.symbol, required this.givenStyle});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: givenColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Center(
            child: Text(
              style: givenStyle,
              symbol,
            )
          ),
        ),
      )
    );
  }
}

class MathCardBase extends StatefulWidget {

  final String type;
  final String symbol;
  final Color givenColor;
  final TextStyle givenStyle;

  MathCardBase({super.key, required this.type, required this.symbol, required this.givenStyle, required this.givenColor});

  @override
  State<MathCardBase> createState() => _MathCardBaseState();
}

class _MathCardBaseState extends State<MathCardBase> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    final theme = Theme.of(context);



    final TextStyle listStyle = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.primary,
      fontSize: 100,
    );
    
    return Card(
      color: theme.colorScheme.onSecondary,
      child: Container(
        width: screenHeight * 1/12,
        height: screenHeight * 1/12,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Center(
            child: Text(
              style: listStyle,
              widget.symbol,
            )
          ),
        )
      )
    );
  }
}