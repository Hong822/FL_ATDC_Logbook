import 'package:atdc_logbook/model/form.dart';

class SpreadSheetUtil {
  List<DriveRecordForm> FilterData(List<DriveRecordForm> Data, String DataType,
      [String Car = ""]) {
    List<DriveRecordForm> lResult = new List<DriveRecordForm>();

    for (DriveRecordForm element in Data) {
      if (element.DataType == DataType) {
        if (Car == "") {
          lResult.add(element);
        } else {
          if (element.Car == Car) {
            lResult.add(element);
          }
        }
      }
    }

    print(lResult.length);
    for (DriveRecordForm element in lResult) {
      print(element.Car +
          "/" +
          element.DepartureMileage +
          "/" +
          element.DrivenBy);
    }
    return lResult;
  }

  List<DriveRecordForm> FilterData_Day(List<DriveRecordForm> Data, int nDay) {
    List<DriveRecordForm> lResult = new List<DriveRecordForm>();
    DateTime nNow = DateTime.now();
    for (DriveRecordForm element in Data) {
      var ParseDate = DateTime.parse(element.DepartureDate);
      int nGap = nNow.difference(ParseDate).inDays;
      print ("Date Gap: ${nGap}");
      if (nGap.abs() < 7) {
        lResult.add(element);
      }
      else{
        print (element.DepartureDate);
      }
    }

    print (Data.length);
    print (lResult.length);
    return lResult;
  }

  String GetLastMileage(List<DriveRecordForm> Data, String SelectedCar) {
    String Result = "";
    for (DriveRecordForm element in Data) {
      if (element.DataType == "Record" && element.Car == SelectedCar) {
        Result = element.ArrivalMileage;
        print(element.Car);
        break;
      }
    }
    print(Result);
    return Result;
  }
}
