import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:confetti/confetti.dart';
import 'splash_page.dart'; //include custom splash page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rock Paper Scissors',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', //set initial route to SplashPage
      routes: {
        // When navigating to the "/" route, build the SplashPage widget.
        '/': (context) => SplashPage(),
        // When navigating to the "/second" route, build the MyHomePage widget.
        '/second': (context) =>
            MyHomePage(title: 'Welcome to Rock Paper Scissors!'),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ConfettiController _controllerCenter; //variable for confetti
  int _roboCounter = 0; //count robot's wins
  int _playerCounter = 0; //count player's wins
  int _result =
      0; //track the result wording to be displayed, initialize to show blank for start screen
  int _playerIndex = 0; //track whether user chooses r, p, or s
  int _roboIndex = 0; //track whether robot chooses r, p, or s
  final randGen = Random.secure(); //generate random number for robot to choose

  //initial state for confetti. limit to confetti blasts to 5 seconds.
  @override
  void initState() {
    super.initState();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 5));
  }

  //dispose confetti
  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  /// A custom path to paint stars for confetti.
  Path drawStar(Size size) {
    // method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  //variable listing game result text options
  var _resultText = [
    Text(''), //blank for startup prior to first play
    Text(
      'Player Wins Round',
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
    ),
    Text(
      'Robot Wins Round',
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
    ),
    Text(
      'Tied Round',
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
    ),
    Text(
      'YAY! YOU WON THE GAME!\nPlay Again!',
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
      textAlign: TextAlign.center,
    ),
    Text(
      'Aww Robot won the game.\nPlay Again!',
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
      textAlign: TextAlign.center,
    ),
  ];

  //variable for choice of rps image
  var _itemImage = [
    Image.asset(
      'images/rock.png',
      height: 100,
      width: 100,
    ),
    Image.asset(
      'images/paper.png',
      height: 100,
      width: 100,
    ),
    Image.asset(
      'images/scissors.png',
      height: 100,
      width: 100,
    ),
  ];

  //rerun the build method to display updated value if robot wins round
  void _incrementRoboCounter() {
    setState(() {
      _roboCounter++;
    });
  }

  //rerun the build method to display updated value if player wins round
  void _incrementPlayerCounter() {
    setState(() {
      _playerCounter++;
    });
  }

  //reset all counters and results
  void _startOver() {
    setState(() {
      _roboCounter = 0;
      _playerCounter = 0;
      _result = 0;
    });
  }

  //increases counters and displays results of each round and overall game
  void setResult() {
    //if player wins round
    if ((_playerIndex == 0 && _roboIndex == 2) ||
        (_playerIndex == 1 && _roboIndex == 0) ||
        (_playerIndex == 2 && _roboIndex == 1)) {
      _playerCounter++;
      _result = 1; //set message to player wins round
    }

    //if robot wins round
    else if ((_roboIndex == 0 && _playerIndex == 2) ||
        (_roboIndex == 1 && _playerIndex == 0) ||
        (_roboIndex == 2 && _playerIndex == 1)) {
      _roboCounter++;
      _result = 2; //set message to robot wins round
    }

    //if tie round
    else {
      _result = 3; //set message to tie
    }

    //if player wins game
    if (_playerCounter == 3) {
      _result = 4; //set message to player wins game
      _controllerCenter.play(); //play confetti
    }

    //if robot wins game
    if (_roboCounter == 3) {
      _result = 5; //set message to robot wins game
    }
  }

  //if game is over, next game start counters over and start with a clean results display
  void checkEndGame() {
    if (_playerCounter == 3 || _roboCounter == 3) {
      _startOver();
    }
  }

  //navigation bar for user to select rock, paper, or scissors hand
  final List<BottomNavigationBarItem> navItemList = [
    BottomNavigationBarItem(
      icon: Icon(
        FontAwesomeIcons.handRock,
        color: Colors.pink,
      ),
      title: Text('Rock'),
    ),
    BottomNavigationBarItem(
      icon: Icon(FontAwesomeIcons.handPaper, color: Colors.orange),
      title: Text('Paper'),
    ),
    BottomNavigationBarItem(
      icon: Icon(
        FontAwesomeIcons.handScissors,
        color: Colors.blue,
      ),
      title: Text('Scissors'),
    )
  ];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called.

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //Blast confetti
            Align(
              alignment: Alignment.center,
              child: ConfettiWidget(
                confettiController: _controllerCenter,
                numberOfParticles: 20,
                blastDirectionality: BlastDirectionality
                    .explosive, // don't specify a direction, blast randomly
                shouldLoop: false, // end when animation is finished, don't loop
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple
                ], // manually specify the colors to be used
                createParticlePath: drawStar, // call custom star path design
              ),
            ),

            //display game win instructions
            Text(
              'First to Win 3 Rounds Wins',
              style: Theme.of(context).textTheme.headline5,
            ),

            //container to display robot and user's hands
            Container(
              margin: const EdgeInsets.only(top: 30.0, bottom: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  //display robot's hand
                  Container(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Robot',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      _itemImage[_roboIndex],
                    ],
                  )),

                  //display player's hand
                  Container(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Player',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      _itemImage[_playerIndex],
                    ],
                  )),
                ],
              ),
            ),

            //display robot and player point counters
            Text(
              'Robot Wins: $_roboCounter | Player Wins: $_playerCounter',
              style: Theme.of(context).textTheme.bodyText1,
            ),

            //display messages to describe result of round and overall game
            Container(
              child: _resultText[_result],
            ),
          ],
        ),
      ),

      //display floating reset button to let player reset game
      floatingActionButton: FloatingActionButton(
        onPressed: _startOver,
        tooltip: 'Reset Game',
        child: const Icon(FontAwesomeIcons.sync),
      ),

      //display and actionlisteners for bottom navigation bar for user to select rock, paper, scissor hand
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _playerIndex,

        /// Here we update the tap event handler in bottom navigation bar to update the state of app after tap
        onTap: (int index) {
          setState(() {
            checkEndGame(); //check to see if game previously ended and need to reset counters and display msg
            _playerIndex =
                index; //update _playerindex to the hand that player picked
            _roboIndex = randGen
                .nextInt(3); //generate a random hand for robot out of 0, 1, 2
            setResult(); //generate results of round and overall game
          });
        },
        items: navItemList, //call display of bottom navigation bar
      ),
    );
  }
}
