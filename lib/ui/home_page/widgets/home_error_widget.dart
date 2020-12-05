import 'package:flutter/material.dart';

class HomeErrorWidget extends StatelessWidget {
  final String error;

  const HomeErrorWidget({Key key, @required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height/1.3,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                'OOPS! 👾'.toUpperCase(),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 30,
                  letterSpacing: 2,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 8,
              ),
            ),
            Center(
              child: Text(
                error,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 15,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 20,
                bottom: 20,
              ),
            ),
            Center(
              child: Text(
                'please try again!'.toUpperCase(),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 10,
                  letterSpacing: 1,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 8,
                bottom: 8,
              ),
            ),
            FloatingActionButton(
              child: Icon(
                Icons.replay,
                size: 30,
              ),
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
