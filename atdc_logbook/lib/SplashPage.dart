import 'package:atdc_logbook/SpreadSheetUtil.dart';
import 'package:atdc_logbook/controller/form_controller.dart';
import 'package:atdc_logbook/model/form.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  static const routeName = '/';

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _LoadingState = true;
  List<String> _CarList = [];
  String _Password = "";
  TextEditingController _PasswordController = new TextEditingController();

  void initState() {
    super.initState();
    Loading();
  }

  Loading() async {
    var Records = await FormController().getData_Easy();
    _Password = SpreadSheetUtil().GetPasswordData(Records, "Password");

    List<DriveRecordForm> CarList =
        SpreadSheetUtil().FilterCarData(Records, "CarList");
    for (DriveRecordForm elem in CarList) {
      _CarList.add(elem.Car);
    }
    _LoadingState = false;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _PasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DrawWidgetByLoadingState();
  }

  DrawWidgetByLoadingState() {
    if (_LoadingState == true) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image(
                image: AssetImage('images/Audi.jpg'),
              ),
              CircularProgressIndicator(),
            ],
          ),
        ),
      );
    } else {
      return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/Audi.jpg'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            title: Text(
              "Input Password",
              style: TextStyle(color: Colors.black, shadows: [
                Shadow(
                    // bottomLeft
                    offset: Offset(-1.5, -1.5),
                    color: Colors.white),
                Shadow(
                    // bottomRight
                    offset: Offset(1.5, -1.5),
                    color: Colors.white),
                Shadow(
                    // topRight
                    offset: Offset(1.5, 1.5),
                    color: Colors.white),
                Shadow(
                    // topLeft
                    offset: Offset(-1.5, 1.5),
                    color: Colors.white),
              ]),
            ),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(0.5),
                child: GridView.count(
                  crossAxisCount: 3,
                  children: <Widget>[
                    ButtonWidget("1"),
                    ButtonWidget("2"),
                    ButtonWidget("3"),
                    ButtonWidget("4"),
                    ButtonWidget("5"),
                    ButtonWidget("6"),
                    ButtonWidget("7"),
                    ButtonWidget("8"),
                    ButtonWidget("9"),
                    ButtonWidget("Clear"),
                    ButtonWidget("0"),
                    ButtonWidget("OK"),
                  ],
                ),
              ),
            ),
          ),
        ),
        onWillPop: _onWillPop,
      );
    }
  }

  Widget ButtonWidget(String txt) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(0.5),
        alignment: Alignment.center,
        color: Colors.black12,
        child: Text(
          txt,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onTap: () {
        if (txt == "Clear") {
          _PasswordController.text = "";
        } else if (txt == "OK") {
          _PasswordChecker();
        } else {
          _PasswordController.text += txt;
          _PasswordChecker();
        }
      },
    );
  }

  _PasswordChecker() {
    print("Input PW = ${_PasswordController.text}");
    if (_PasswordController.text == _Password) {
      Navigator.pushReplacementNamed(
        context,
        "/home",
        arguments: _CarList,
      );
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Terminate'),
            content: new Text('Do you want to terminate this app?'),
            actions: <Widget>[
              new TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }
}
