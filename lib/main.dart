import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  //
  // void _incrementCounter() {
  //   setState(() {
  //     // This call to setState tells the Flutter framework that something has
  //     // changed in this State, which causes it to rerun the build method below
  //     // so that the display can reflect the updated values. If we changed
  //     // _counter without calling setState(), then the build method would not be
  //     // called again, and so nothing would appear to happen.
  //     _counter++;
  //   });
  // }
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '3目並べ',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Page()
    );
  }
}



class Page extends StatefulWidget{

  @override
  _PageState createState() => _PageState();

}


class _PageState extends State<Page>{
  //固定じゃなくて画面サイズに合わせて表示みたいなようにしたいなぁー
  double block_size = 200;

  //0:まだ埋まっていない, 1: 先手が埋めた, 2: 後手が埋めた
  List<int> state_array = [0,0,0,0,0,0,0,0,0];

  int turn = 1;
  //6が初期状態
  int action = 6;

  int ALREADY = 0;
  int FIRST_MOVE = 1;
  int SECOND_MOVE = 2;
  int FIRST_MOVE_WIN = 3;
  int SECOND_MOVE_WIN = 4;
  int DRAW = 5;

  //タッチパネルナンバー
  int PANEL0 = 0;
  int PANEL1 = 1;
  int PANEL2 = 2;
  int PANEL3 = 3;
  int PANEL4 = 4;
  int PANEL5 = 5;
  int PANEL6 = 6;
  int PANEL7 = 7;
  int PANEL8 = 8;




  bool is_win(int turn){
    //[終了判定]
    //勝利が決まった場合
    bool win = false;

    //行の判定
    for(int i = 0;i < 7;i += 3) {
      if ((state_array[i] == turn) && (state_array[i+1] == turn) &&
          (state_array[i+2] == turn)) {
        win = true;
      }
    }
    //列の判定
    for(int i = 0;i < 3;i++) {
      if ((state_array[i] == turn) && (state_array[i+3] == turn) &&
          (state_array[i+6] == turn)) {
        win = true;
      }
    }

    //斜めの判定
    if ((state_array[0] == turn) && (state_array[4] == turn) &&
        (state_array[8] == turn)) {
      win = true;
    }
    if ((state_array[2] == turn) && (state_array[4] == turn) &&
        (state_array[6] == turn)) {
      win = true;
    }

    return win;
  }

  bool is_draw(){
    bool draw = false;

    for(int i=0;i<9;i++){
      if(state_array[i] == 0){
        return draw;
      }
    }
    draw = true;
    return draw;
  }


  int touched(int touchedpanel){
    //return_num
    //0:もう埋まっている, 1: 先手のパネルを埋める, 2: 後手のパネルを埋める
    //3: 先手の勝利, 4: 後手の勝利, 5:　引き分け



    int return_num = ALREADY;
    bool win = false;
    bool draw = false;
    if(state_array[touchedpanel] ==  0) {
      state_array[touchedpanel] = turn;


      return_num = turn;
      win = is_win(turn);
      draw = is_draw();

      if(win == true){
        if(turn == FIRST_MOVE){
          return_num = FIRST_MOVE_WIN;
        }else{
          return_num = SECOND_MOVE_WIN;
        }
      }

      if(draw == true){
        if(return_num != FIRST_MOVE_WIN && return_num != SECOND_MOVE_WIN){
          return_num = DRAW;
        }
      }

      //相手のターンに移行
      if (turn == FIRST_MOVE) {
        turn = SECOND_MOVE;
      } else {
        turn = FIRST_MOVE;
      }

    }
    return return_num;
  }


//  ここで関数や変数を定義する
//後で配列などを追加する

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('3目並べ'),
      ),
      body:Container(
        child: Column(
          children: <Widget>[
            Column(
                children:<Widget>[
                  //即時関数(ちゃんと理解できていない。)
                  ((){
                    if(turn == 1){
                      return Text(
                          'andyの手番です',
                          style: TextStyle(fontSize: 50, color: Colors.black),
                    );
                    }else{
                       return Text(
                          '西尾教授の手番です',
                          style: TextStyle(fontSize: 50, color: Colors.black),
                      );
                    }
                  })(),

                ]

            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    action = touched(PANEL0);
                  },
                  child: ((){
                    if(action == 6){
                      Container( width: block_size,height: block_size,decoration: BoxDecoration(
                        border: const Border(
                          left: const BorderSide(
                            color: Colors.black,
                            width: 3,
                          ),
                          top: const BorderSide(
                            color: Colors.black,
                            width: 3,
                          ),
                          right: const BorderSide(
                            color: Colors.black,
                            width: 3,
                          ),
                          bottom: const BorderSide(
                            color: Colors.black,
                            width: 3,
                          ),
                        ),
                      ),
                      );
                    }
                    else if(action == 0){
                      Container(color: Colors.black12, width: block_size , height: block_size);
                    }
                    else if(action == 1){
                      //後で画像に差し替え
                      Container(color: Colors.yellowAccent, width: block_size , height: block_size);
                    }else if(action == 2){
                      //後で画像に差し替え
                      Container(color: Colors.redAccent, width: block_size , height: block_size);
                    }else if(action == 3){
                      //ポップアップを表示
                      Container(color: Colors.black12, width: block_size , height: block_size);
                    }else if(action == 4){
                      //ポップアップを表示
                      Container(color: Colors.black12, width: block_size , height: block_size);
                    }else if(action == 5){
                      //DRAWのポップアップを表示
                      Container(color: Colors.black12, width: block_size , height: block_size);
                    }else{
                      print("ミスってる");
                      Container(color: Colors.black12, width: block_size , height: block_size);
                    }
                  })(),
                ),
                Container(color: Colors.red, width: block_size , height: block_size),
                Container(color: Colors.green, width: 200, height: 200),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(color: Colors.orange, width: 200, height: 200),
                Container(color: Colors.pink, width: 200, height: 200),
                Container(color: Colors.amber, width: 200, height: 200),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(color: Colors.purple, width: 200, height: 200),
                Container(color: Colors.greenAccent, width: 200, height: 200),
                Container(color: Colors.deepPurpleAccent, width: 200, height: 200),
              ],
            ),
            Center(
              child:ResetButton(),
            ),
          ],
        ),
      ),
    );
  }

}




class ResetButton extends StatefulWidget{
  @override
  _ResetButtonState createState() => _ResetButtonState();
}

class _ResetButtonState extends State<ResetButton>{

  Widget build(BuildContext context){
    return Container(
      child: TextButton(
        onPressed: (){},
        child: Text(
            'リセット',
            style: TextStyle(fontSize: 50, color: Colors.black),
        ),
        style: TextButton.styleFrom(
          primary: Colors.black,
        ),
      ),
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
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
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
