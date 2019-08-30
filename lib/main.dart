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
  int _max = 9;
  Map _range = {
    'min': 0,
    'max': 9,
  };
  bool _isRunning = false;
  Timer _timer;
  List _buttonLabel = ['Start', 'Stop'];
  String _runButtonLabel = 'Start';

  // 不幸のダイアログ
  void alert() {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Unhappy letter'),
          content: Text(
            'The maximum value must be set larger than the minimum value',
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  // 乱数生成の関数
  void _createRondomInt() {
    if (_range['min'] >= _range['max']) {
      alert();
    } else {
      if (_isRunning) {
        _timer?.cancel();
        setState(() {
          _isRunning = false;
          _runButtonLabel = _buttonLabel[0];
        });
      } else {
        setState(() {
          _isRunning = true;
          _runButtonLabel = _buttonLabel[1];
        });
        _timer = Timer.periodic(
          Duration(
            milliseconds: 5,
          ),
          (Timer timer) => setState(() {
            final rnd = new Random();
            _randomInt =
                _range['min'] + rnd.nextInt(_range['max'] - _range['min'] + 1);
          }),
        );
      }
    }
  }

  // 最大値と最小値を選ぶやつの設定
  void _showMinSelectWindow(String minMax) {
    var _numList = new List.generate(100, (i) => i);
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            child: CupertinoPicker(
              // 初期値設定
              scrollController: new FixedExtentScrollController(
                initialItem: _range[minMax],
              ),
              // 選択肢の高さ設定
              itemExtent: 45.0,
              // 変更時の処理
              onSelectedItemChanged: (int value) {
                setState(() {
                  _range[minMax] = value;
                });
              },
              // 選択肢の設定
              children: _numList.map<Center>((int value) {
                return Center(
                  child: Text('$value'),
                );
              }).toList(),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'Generate random number!',
            ),
            Text(
              '$_randomInt',
              style: Theme.of(context).textTheme.display1,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // 最小値ボタン
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    MaterialButton(
                      child: Text(
                        'min: ${_range["min"]}',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () => _showMinSelectWindow('min'),
                    ),
                    // 最大値ボタン
                    MaterialButton(
                      child: Text(
                        'max: ${_range["max"]}',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () => _showMinSelectWindow('max'),
                    ),
                  ],
                ),
                // スタート・ストップボタン
                Container(
                  margin: EdgeInsets.all(40.0),
                  child: CupertinoButton(
                    child: Text(
                      '$_runButtonLabel',
                    ),
                    color: Colors.deepPurple,
                    minSize: 50.0,
                    onPressed: _createRondomInt,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
