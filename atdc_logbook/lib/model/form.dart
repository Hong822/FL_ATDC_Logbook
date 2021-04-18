/// FeedbackForm is a data class which stores data fields of Feedback.
class DriveRecordForm {
  String DataType = "";
  String Password = "";
  String Car = "";
  String DepartureDate = "";
  String DepartureTime = "";
  String DepartureMileage = "";
  String ArrivalDate = "";
  String ArrivalTime = "";
  String ArrivalMileage = "";
  String Destination = "";
  String DrivenBy = "";
  String Parking = "";
  String Fuel = "";
  String ReFuel = "";

  DriveRecordForm(
      this.DataType,
      this.Password,
      this.Car,
      this.DepartureDate,
      this.DepartureTime,
      this.DepartureMileage,
      this.ArrivalDate,
      this.ArrivalTime,
      this.ArrivalMileage,
      this.Destination,
      this.DrivenBy,
      this.Parking,
      this.Fuel,
      this.ReFuel);

  factory DriveRecordForm.fromJson(dynamic json) {
    return DriveRecordForm(
        "${json['DataType']}",
        "${json['Password']}",
        "${json['Car']}",
        "${json['DepartureDate']}",
        "${json['DepartureTime']}",
        "${json['DepartureMileage']}",
        "${json['ArrivalDate']}",
        "${json['ArrivalTime']}",
        "${json['ArrivalMileage']}",
        "${json['Destination']}",
        "${json['DrivenBy']}",
        "${json['Parking']}",
        "${json['Fuel']}",
        "${json['ReFuel']}");
  }

  // Method to make GET parameters.
  Map toJson() => {
        'DataType': "Record",
        'Car' : Car,
        'DepartureDate': DepartureDate,
        'DepartureTime': DepartureTime,
        'DepartureMileage': DepartureMileage,
        'ArrivalDate': ArrivalDate,
        'ArrivalTime': ArrivalTime,
        'ArrivalMileage': ArrivalMileage,
        'Destination': Destination,
        'DrivenBy': DrivenBy,
        'Parking': Parking,
        'Fuel': Fuel,
        'FuelCheckBox': ReFuel,
      };
}
