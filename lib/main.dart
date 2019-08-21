import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: MyHomePage(title: 'Random App'),
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
  int _randomInt = 0;
  int _min = 0;
  int _max = 1;

  void _createRondomInt() {
    if (_min > _max) {
      showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('Unhappy letter'),
            content: Text(
                'The maximum value must be set larger than the minimum value'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );
    } else {
      int count = 0;
      Timer.periodic(const Duration(milliseconds: 5), (timer) {
        setState(() {
          final rnd = new Random();
          _randomInt = _min + rnd.nextInt(_max - _min + 1);
          // print('min: $_min');
          // print('max: $_max');
          // print(_randomInt);
        });
        count++;
        if (count > 100) {
          timer.cancel();
        }
      });
    }
  }

  void _setMinInt(int value) {
    setState(() {
      _min = value;
    });
  }

  void _setMaxInt(int value) {
    setState(() {
      _max = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    var _minList = new List.generate(100, (i) => i);
    var _maxList = new List.generate(100, (i) => i + 1);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Generate random numbers!',
            ),
            Text(
              '$_randomInt',
              style: Theme.of(context).textTheme.display1,
            ),
            DropdownButton<int>(
              items: _minList.map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value'),
                );
              }).toList(),
              value: _min,
              hint: Text('select value'),
              onChanged: (int newValue) {
                _setMinInt(newValue);
              },
            ),
            DropdownButton<int>(
              items: _maxList.map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value'),
                );
              }).toList(),
              value: _max,
              hint: Text('select value'),
              onChanged: (int newValue) {
                _setMaxInt(newValue);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createRondomInt,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
