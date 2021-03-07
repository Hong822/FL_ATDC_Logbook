import 'package:flutter/material.dart';
import 'package:atdc_logbook/SpreadSheetUtil.dart';
import 'package:atdc_logbook/feedback_list.dart';

import 'controller/form_controller.dart';
import 'model/form.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Sheet Demo',
      theme: ThemeData(
        //primarySwatch: Colors.blue,
        primaryColor: Colors.blueGrey,
      ),
      home: MyHomePage(
        title: 'ATDC Logbook',
      ),
      //debugShowCheckedModeBanner: false,
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
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // TextField Controllers
  String _DepartureDate = " - - ";
  String _DepartureTime = "--:--";
  String _ArrivalDate = " - - ";
  String _ArrivalTime = "--:--";
  TextEditingController _DepartureMileageController =
      new TextEditingController();
  TextEditingController _ArrivalMileageController = new TextEditingController();
  TextEditingController _DestinationController = new TextEditingController();
  TextEditingController _DrivenByController = new TextEditingController();
  TextEditingController _ParkingController = new TextEditingController();
  TextEditingController _FuelController = new TextEditingController();
  var _bkmCheckBox = false;
  var _bFuelCheckBox = false;

  List<String> _valueList = new List<String>();
  String _SelectedCar;

  @override
  void initState() {
    FormController().getData_Easy().then((Records) {
      setState(() {
        List<DriveRecordForm> CarList =
            SpreadSheetUtil().FilterData(Records, "CarList");

        for (DriveRecordForm elem in CarList) {
          _valueList.add(elem.Car);
        }
        _SelectedCar = _valueList[0];
      });
    });
  }

  @override
  void dispose() {
    _DepartureMileageController.dispose();
    _ArrivalMileageController.dispose();
    _DestinationController.dispose();
    _DrivenByController.dispose();
    _ParkingController.dispose();
    _FuelController.dispose();
  }

  UpdateScreen() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: true,
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
          widget.title,
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
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: DropdownButton(
                            value: _SelectedCar,
                            items: _valueList.map((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _SelectedCar = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        RaisedButton(
                          child: Text("Get\nLast\nMileage"),
                          color: Colors.white70,
                          textTheme: ButtonTextTheme.normal,
                          onPressed: () async {
                            _showSnackbar("Downloading Data from Server.");
                            List<DriveRecordForm> Data =
                                await FormController().getData_Easy();
                            _DepartureMileageController.text = SpreadSheetUtil()
                                .GetLastMileage(Data, _SelectedCar);
                          },
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        RaisedButton(
                          child: Text("Show\nLast\n7 days"),
                          color: Colors.white70,
                          textTheme: ButtonTextTheme.normal,
                          onPressed: () async {
                            _showSnackbar("Downloading Data from Server.");
                            List<DriveRecordForm> Data =
                                await FormController().getData_Easy();
                            List<DriveRecordForm> OnlyRecordData =
                                SpreadSheetUtil()
                                    .FilterData(Data, "Record", _SelectedCar);
                            List<DriveRecordForm> Only7DaysData =
                                SpreadSheetUtil()
                                    .FilterData_Day(OnlyRecordData, 7);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecordViewScreen(
                                    Only7DaysData, _SelectedCar),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        RaisedButton(
                          child: Text("Departure\nTime"),
                          onPressed: () async {
                            DateTime DepartureDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2018),
                              lastDate: DateTime(2050),
                              builder: (BuildContext context, Widget child) {
                                return Theme(
                                  data: ThemeData.dark(),
                                  child: child,
                                );
                              },
                            );
                            print(DepartureDate);
                            var Month =
                                DepartureDate.month.toString().padLeft(2, '0');
                            var Day =
                                DepartureDate.day.toString().padLeft(2, '0');
                            _DepartureDate =
                                '${DepartureDate.year}-${Month}-${Day}';
                            print("D_Date: " + _DepartureDate);

                            TimeOfDay selectedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );

                            //_DepartureTime = '${Hour}:${Min}';
                            print(selectedTime);
                            var Hour =
                                selectedTime.hour.toString().padLeft(2, '0');
                            var Min =
                                selectedTime.minute.toString().padLeft(2, '0');
                            _DepartureTime = Hour + ":" + Min;
                            //_DepartureTime = '${selectedTime.hour}:${selectedTime.minute}';
                            print("Departure_Time: " + _DepartureTime);

                            UpdateScreen();
                          },
                        ),
                        Text(
                          //"${_DepartureDate}\n${_DepartureTime}",
                          _DepartureDate + "\n" + _DepartureTime,
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                        RaisedButton(
                          child: Text("Arrival\nTime"),
                          onPressed: () async {
                            DateTime ArrivalDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2018),
                              lastDate: DateTime(2050),
                              builder: (BuildContext context, Widget child) {
                                return Theme(
                                  data: ThemeData.dark(),
                                  child: child,
                                );
                              },
                            );
                            print(ArrivalDate);
                            var Month =
                                ArrivalDate.month.toString().padLeft(2, '0');
                            var Day =
                                ArrivalDate.day.toString().padLeft(2, '0');
                            _ArrivalDate =
                                '${ArrivalDate.year}-${Month}-${Day}';
                            print("D_Date: " + _ArrivalDate);

                            TimeOfDay selectedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );

                            print(selectedTime);
                            var Hour =
                                selectedTime.hour.toString().padLeft(2, '0');
                            var Min =
                                selectedTime.minute.toString().padLeft(2, '0');
                            _ArrivalTime = Hour + ":" + Min;
                            // _ArrivalTime = '${selectedTime.hour}:${selectedTime.minute}';
                            print("Arrival_Time: " + _ArrivalTime);

                            UpdateScreen();
                          },
                        ),
                        Text(
                          "${_ArrivalDate}\n${_ArrivalTime}",
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: _DepartureMileageController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Departure Mileage (km)",
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Empty!!!';
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      controller: _ArrivalMileageController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Arrival Mileage (km)",
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Empty!!!';
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      controller: _DestinationController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Destination & Purpose",
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Empty!!!';
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      controller: _DrivenByController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Driven by",
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Empty!!!';
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      controller: _ParkingController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Parking Area",
                        //hintText: "Parking Area",
                      ),
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Empty!!!';
                        } else {
                          return null;
                        }
                      },
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: TextFormField(
                            controller: _FuelController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Fuel (% or km)",
                            ),
                            validator: (value) {
                              if (value.trim().isEmpty) {
                                return 'Empty!!!';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("km"),
                        Checkbox(
                          value: _bkmCheckBox,
                          onChanged: (value) {
                            setState(() {
                              _bkmCheckBox = value;
                            });
                          },
                        ),
                        Text("Refuel"),
                        Checkbox(
                          value: _bFuelCheckBox,
                          onChanged: (value) {
                            setState(() {
                              _bFuelCheckBox = value;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: RaisedButton(
                            child: Text("Clear"),
                            onPressed: _ClearForm,
                          ),
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: RaisedButton(
                            child: Text("Uplaod"),
                            onPressed: _submitForm,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text("Version 1.0"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _GetSubmitText() {
    String RemainFuel =
        _bkmCheckBox ? _FuelController.text + "km" : _FuelController.text + "%";
    String DepartureMileage = _DepartureMileageController.text + "km";
    String ArrivalMileage = _ArrivalMileageController.text + "km";

    String Result = "Car: " +
        _SelectedCar +
        "\n" +
        "Time:" +
        _DepartureDate +
        " " +
        _DepartureTime +
        " / " +
        _ArrivalDate +
        " " +
        _ArrivalTime +
        "\n" +
        "Mileage: " +
        DepartureMileage +
        ", " +
        ArrivalMileage +
        "\n" +
        "Purpose: " +
        _DestinationController.text +
        "\n" +
        "Driven By: " +
        _DrivenByController.text +
        "\n" +
        "Parking: " +
        _ParkingController.text +
        "\n" +
        "Fuel: " +
        RemainFuel;

    return Result;
  }

  void _ClearForm() {
    _DepartureDate = " - - ";
    _DepartureTime = "--:--";
    _ArrivalDate = " - - ";
    _ArrivalTime = "--:--";
    _DepartureMileageController.clear();
    _ArrivalMileageController.clear();
    _DestinationController.clear();
    _DrivenByController.clear();
    _ParkingController.clear();
    _FuelController.clear();
    _bkmCheckBox = false;
    _bFuelCheckBox = false;

    UpdateScreen();
  }

  // Method to Submit Feedback and save it in Google Sheets
  void _submitForm() {
    // Validate returns true if the form is valid, or false
    // otherwise.
    var bValidTimeCheck = true;
    if (_DepartureDate == " - - " ||
        _ArrivalDate == " - - " ||
        _DepartureTime == "--:--" ||
        _ArrivalTime == "--:--") {
      _showSnackbar("Date is missing.");
    } else {
      if (_formKey.currentState.validate() == false) {
        _showSnackbar("Insufficient Input.");
      } else {
        if (int.parse(_ArrivalMileageController.text) <
            int.parse(_DepartureMileageController.text)) {
          _showSnackbar("Arrival Mileage is smaller than departure.");
        } else {
          var DepartureTime = _DepartureDate + " " + _DepartureTime + ":00";
          var ArrivalTime = _ArrivalDate + " " + _ArrivalTime + ":00";
          var DepartureDate = DateTime.parse(DepartureTime);
          var ArrivalDate = DateTime.parse(ArrivalTime);
          if (ArrivalDate.compareTo(DepartureDate) < 0) {
            _showSnackbar("Arrival Time is earlier than Departure.");
          } else {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Submit Record"),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text("Do you want to submit this record?\n"),
                        Text(_GetSubmitText()),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Cancel"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();

                        String _sFuelCheckbox = _bFuelCheckBox ? "O" : "";
                        String RemainFuel = _bkmCheckBox
                            ? _FuelController.text + "km"
                            : _FuelController.text + "%";

                        DriveRecordForm driveRecordForm = DriveRecordForm(
                          "Record",
                          _SelectedCar,
                          _DepartureDate,
                          _DepartureTime,
                          _DepartureMileageController.text,
                          _ArrivalDate,
                          _ArrivalTime,
                          _ArrivalMileageController.text,
                          _DestinationController.text,
                          _DrivenByController.text,
                          _ParkingController.text,
                          RemainFuel,
                          _sFuelCheckbox,
                        );

                        FormController formController = FormController();

                        _showSnackbar("Submitting Drive Record");

                        // Submit 'feedbackForm' and save it in Google Sheets.
                        formController.submitForm(driveRecordForm,
                            (String response) {
                          print("Response: $response");
                          if (response == FormController.STATUS_SUCCESS) {
                            // Feedback is saved succesfully in Google Sheets.
                            var showSnackbar =
                                _showSnackbar("Drive Record Submitted");
                          } else {
                            // Error Occurred while saving data in Google Sheets.
                            _showSnackbar("Error Occurred!");
                          }
                        });
                      },
                    ),
                  ],
                );
              },
            );
          }
        }
      }
    }
  }

  // Method to show snackbar with 'message'.
  _showSnackbar(String message) {
    final snackBar = SnackBar(content: Text(message));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
