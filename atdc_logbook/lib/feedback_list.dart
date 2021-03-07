import 'package:flutter/material.dart';

import 'controller/form_controller.dart';
import 'model/form.dart';

class RecordViewScreen extends StatelessWidget {
  final List<DriveRecordForm> RecordData;
  final String AppName;

  RecordViewScreen(this.RecordData, this.AppName);

  String _GetRecordString(var index) {
    String Refuel = (RecordData[index].ReFuel != "") ? " (Refuel:O)" : "";

    RecordData[index].DepartureTime =
        RecordData[index].DepartureTime.padLeft(5, '0');
    RecordData[index].ArrivalTime =
        RecordData[index].ArrivalTime.padLeft(5, '0');

    var DepartureTime = RecordData[index].DepartureDate +
        " " +
        RecordData[index].DepartureTime +
        ":00";
    var ArrivalTime = RecordData[index].ArrivalDate +
        " " +
        RecordData[index].ArrivalTime +
        ":00";
    var DepartureDate = DateTime.parse(DepartureTime);
    var ArrivalDate = DateTime.parse(ArrivalTime);
    var TimeGap = ArrivalDate.difference(DepartureDate);
    print("Minute: ${TimeGap.inMinutes}");
    int day = (TimeGap.inMinutes / 1440).toInt();
    var hour = ((TimeGap.inMinutes % 1440) / 60).toInt();
    var min = ((TimeGap.inMinutes % 1440) % 60).toInt();
    var GapString = "${day}d ${hour}h ${min}m";

    String Result = "D: " +
        RecordData[index].DepartureDate +
        " " +
        RecordData[index].DepartureTime +
        "\n" +
        "A: " +
        RecordData[index].ArrivalDate +
        " " +
        RecordData[index].ArrivalTime +
        " (" +
        GapString +
        ")\n" +
        "Mileage: " +
        RecordData[index].DepartureMileage +
        "km, " +
        RecordData[index].ArrivalMileage +
        "km" +
        "\n" +
        "Fuel: " +
        RecordData[index].Fuel +
        Refuel +
        "\n" +
        "Parking: " +
        RecordData[index].Parking;

    return Result;
  }

  @override
  Widget build(BuildContext context) {
    if (RecordData.length == 0) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Drive Record of ${AppName}"),
        ),
        body: Center(
          child: Text("No Drive Record.",
            style:TextStyle(fontWeight: FontWeight.bold),),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text("Drive Record of ${AppName}"),
        ),
        body: ListView.builder(
          itemCount: RecordData.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Row(
                children: <Widget>[
                  Icon(Icons.arrow_forward_ios_rounded),
                  Expanded(
                    child: Text(
                      _GetRecordString(index),
                    ),
                  )
                ],
              ),
              subtitle: Row(
                children: <Widget>[
                  Icon(Icons.account_box),
                  Expanded(
                    child: Text(RecordData[index].DrivenBy +
                        ", " +
                        RecordData[index].Destination),
                  )
                ],
              ),
            );
          },
        ),
      );
    }
  }
}
