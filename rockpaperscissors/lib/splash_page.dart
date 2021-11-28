import 'package:flutter/material.dart';
import 'main.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) => _afterBuild(context));
    super.initState();
  }

  //show logo on splash page
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Image.asset('images/logo.png'),
      ),
    );
  }

  //create blue, rounded bottom menu to start game on splash page
  void _afterBuild(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      barrierColor: Colors.transparent,
      backgroundColor: Colors.blue,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(25),
        topRight: const Radius.circular(25),
      )),
      builder: (builderContext) {
        return SizedBox(
          height: 100,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.blue,
                ),
                onPressed: () => Navigator.pushNamed(
                    context, '/second'), //Navigator.pop(context),
                child: Text('Play Game'),
              ),
            ),
          ),
        );
      },
    );
  }
}
