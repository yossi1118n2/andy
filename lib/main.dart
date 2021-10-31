import 'dart:math';

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
  double block_size = 80;
  double edge_size = 8;

  MaterialColor COLOR1 = Colors.red;
  MaterialColor COLOR2 = Colors.blue;

  //パネルの色管理
  List<MaterialColor> def = [Colors.grey,Colors.grey,Colors.grey,Colors.grey,Colors.grey,Colors.grey,Colors.grey,Colors.grey,Colors.grey];



  //0:まだ埋まっていない, 1: 先手が埋めた, 2: 後手が埋めた
  List<int> state_array = [0,0,0,0,0,0,0,0,0];

  int turn = 1;
  //0が初期状態
  int action = 0;

  static const int ALREADY = 0;
  static const int FIRST_MOVE = 1;
  static const int SECOND_MOVE = 2;
  static const int FIRST_MOVE_WIN = 3;
  static const int SECOND_MOVE_WIN = 4;
  static const int DRAW = 5;

  //タッチパネルナンバー
  static const int PANEL0 = 0;
  static const int PANEL1 = 1;
  static const int PANEL2 = 2;
  static const int PANEL3 = 3;
  static const int PANEL4 = 4;
  static const int PANEL5 = 5;
  static const int PANEL6 = 6;
  static const int PANEL7 = 7;
  static const int PANEL8 = 8;

  //画像をランダムに選ぶ際に利用
  Random random= Random();


  //画像
  List<String> player1win_image = [
    'images/andy2.jpg',
    'images/andy3.jpg'
  ];

  List<String> player2win_image = [
    'images/nishio1.jpg',
    'images/nishio2.jpg',
  ];

  List<String> draw_image =[
    'images/draw1.jpg',
    'images/draw2.jpg',
  ];




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
    print("return_num");
    print(return_num);
    print("array");
    for(int i=0; i<9;i++){
      print(state_array[i]);
    }
    return return_num;
  }

  void change_panel_color(int panel){
    switch(action){
      case ALREADY:
        break;
      case FIRST_MOVE:
        def[panel] = COLOR1;
        break;
      case SECOND_MOVE:
        def[panel] = COLOR2;
        break;
      case FIRST_MOVE_WIN:
        def[panel] = COLOR1;
        print("先手の勝利");
        int randomWin1Index = random.nextInt(player1win_image.length);
        String randomWin1 = player1win_image[randomWin1Index];
        showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Text("先手の勝利"),
              children: [
                Container(
                  width: block_size * 4,
                  height: block_size * 4,
                  child: Image.asset(
                    randomWin1,
                    fit: BoxFit.contain,
                  ),
                ),
                SimpleDialogOption(
                  onPressed: (){
                    reset();
                    Navigator.pop(context);
                  },
                  child: Text("NEXT GAME"),
                ),
              ],
            );
          },
        );
        //ここに書く
        break;
      case SECOND_MOVE_WIN:
        def[panel] = COLOR2;
        print("後手の勝利");
        int randomWin2Index = random.nextInt(player2win_image.length);
        String randomWin2 = player2win_image[randomWin2Index];
        showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Text("後手の勝利"),
              children: [
                Container(
                  width: block_size * 4,
                  height: block_size * 4,
                  child: Image.asset(
                    randomWin2,
                    fit: BoxFit.contain,
                  ),
                ),
                SimpleDialogOption(
                  onPressed: (){
                    reset();
                    Navigator.pop(context);
                  },
                  child: Text("NEXT GAME"),
                ),
              ],
            );
          },
        );
        //ここに書く
        break;
      case DRAW:
        def[panel] = COLOR1;
        print("引き分け");
        int randomDrawIndex = random.nextInt(draw_image.length);
        String randomDraw = draw_image[randomDrawIndex];
        showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Text("引き分け"),
              children: [
                Container(
                  width: block_size * 4,
                  height: block_size * 4,
                  child: Image.asset(
                    randomDraw,
                    fit: BoxFit.contain,
                  ),
                ),
                SimpleDialogOption(
                  onPressed: (){
                    reset();
                    Navigator.pop(context);
                  },
                  child: Text("NEXT GAME"),
                ),
              ],
            );
          },
        );
        //ここに書く
        break;
      default:
        break;
    }
  }

  void reset(){
    setState(() {
      for(int i=0;i<9;i++){
        def[i] = Colors.grey;
        state_array[i] = 0;
      }
      turn = 1;
    });
  }


//  ここで関数や変数を定義する
//後で配列などを追加する

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('白熱!! 3目並べ'),
      ),
      body:Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/background.jpg'),
              fit: BoxFit.cover,
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
                children:<Widget>[
                  //即時関数(ちゃんと理解できていない。)
                  ((){
                    if(turn == 1){
                      return Container(color: Colors.white,  width: block_size * 3.5 , height: block_size ,
                        child: Text('andyの手番です',
                          style: TextStyle(
                              fontSize:block_size / 3,
                              color: COLOR1),),
                        alignment:Alignment.center,);
                    }else{
                       return Container(color: Colors.white,  width: block_size * 3.5 , height: block_size ,
                         child: Text('教授の手番です',
                           style: TextStyle(
                               fontSize:block_size / 3,
                               color: COLOR2),),
                         alignment:Alignment.center,);
                    }
                  })(),

                ]

            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  // behavior: HitTestBehavior.deferToChild,
                  onTap: (){
                    setState(() {
                      action = touched(PANEL0);
                      print("touched");
                      change_panel_color(PANEL0);
                    });
                  },
                  child: Padding(
                          padding: EdgeInsets.all(edge_size),
                          child:Container(color: def[PANEL0], width: block_size , height: block_size),
                          ),
                ),
                GestureDetector(
                  // behavior: HitTestBehavior.deferToChild,
                  onTap: (){
                    setState(() {
                      action = touched(PANEL1);
                      print("touched");
                      change_panel_color(PANEL1);
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.all(edge_size),
                    child:Container(color: def[PANEL1], width: block_size , height: block_size),
                  ),
                ),
                GestureDetector(
                  // behavior: HitTestBehavior.deferToChild,
                  onTap: (){
                    setState(() {
                      action = touched(PANEL2);
                      print("touched");
                      change_panel_color(PANEL2);
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.all(edge_size),
                    child:Container(color: def[PANEL2], width: block_size , height: block_size),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  // behavior: HitTestBehavior.deferToChild,
                  onTap: (){
                    setState(() {
                      action = touched(PANEL3);
                      print("touched");
                      change_panel_color(PANEL3);
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.all(edge_size),
                    child:Container(color: def[PANEL3], width: block_size , height: block_size),
                  ),
                ),
                GestureDetector(
                  // behavior: HitTestBehavior.deferToChild,
                  onTap: (){
                    setState(() {
                      action = touched(PANEL4);
                      print("touched");
                      change_panel_color(PANEL4);
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.all(edge_size),
                    child:Container(color: def[PANEL4], width: block_size , height: block_size),
                  ),
                ),
                GestureDetector(
                  // behavior: HitTestBehavior.deferToChild,
                  onTap: (){
                    setState(() {
                      action = touched(PANEL5);
                      print("touched");
                      change_panel_color(PANEL5);
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.all(edge_size),
                    child:Container(color: def[PANEL5], width: block_size , height: block_size),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  // behavior: HitTestBehavior.deferToChild,
                  onTap: (){
                    setState(() {
                      action = touched(PANEL6);
                      print("touched");
                      change_panel_color(PANEL6);
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.all(edge_size),
                    child:Container(color: def[PANEL6], width: block_size , height: block_size),
                  ),
                ),
                GestureDetector(
                  // behavior: HitTestBehavior.deferToChild,
                  onTap: (){
                    setState(() {
                      action = touched(PANEL7);
                      print("touched");
                      change_panel_color(PANEL7);
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.all(edge_size),
                    child:Container(color: def[PANEL7], width: block_size , height: block_size),
                  ),
                ),
                GestureDetector(
                  // behavior: HitTestBehavior.deferToChild,
                  onTap: (){
                    setState(() {
                      action = touched(PANEL8);
                      print("touched");
                      change_panel_color(PANEL8);
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.all(edge_size),
                    child:Container(color: def[PANEL8], width: block_size , height: block_size),
                  ),
                ),
              ],
            ),
            Center(
              child:GestureDetector(
                // behavior: HitTestBehavior.deferToChild,
                onTap: (){
                  reset();
                },
                child:Container(color: Colors.white,  width: block_size * 3 , height: block_size , child: Text('リセット',style: TextStyle(fontSize:block_size / 2, color: Colors.green),),alignment:Alignment.center,),
              ),
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
        onPressed: (){

        },
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
