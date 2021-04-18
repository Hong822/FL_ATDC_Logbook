import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

import '../model/form.dart';

/// FormController is a class which does work of saving FeedbackForm in Google Sheets using
/// HTTP GET request on Google App Script Web URL and parses response and sends result callback.
class FormController {
  // Google App Script Web URL.
  // static const String URL =
  //     "https://script.google.com/macros/s/AKfycbxGdY-prHSakdtdNKsKqJkHUuIXYR1pivjGaUjg2RXOaHdK8AA/exec";
  static const String URL =
       "https://script.google.com/macros/s/AKfycbx0zDQEbKSmcYlB3wDy4tr6-P_2FyZk30rgNDUI-CjcR0uKk6f_LhK7SiPfA5IM6SHe/exec";

  //static const String ChanhongPrivateURL = "https://script.google.com/macros/s/AKfycbx-BF2PBC4GM9l6_FrywRBXEi-0oali6a-FYprkzkPF_Y-4lbY/exec";
  //static const String ExampleURL = "https://script.google.com/macros/s/AKfycbyAaNh-1JK5pSrUnJ34Scp3889mTMuFI86DkDp42EkWiSOOycE/exec";

  // Success Status Message
  static const STATUS_SUCCESS = "SUCCESS";

  /// Async function which saves feedback, parses [feedbackForm] parameters
  /// and sends HTTP GET request on [URL]. On successful response, [callback] is called.
  void submitForm(
      DriveRecordForm driveRecordForm, void Function(String) callback) async {
    try {
      await http
          .post(URL, body: driveRecordForm.toJson())
          .then((response) async {
        if (response.statusCode == 302) {
          var url = response.headers['location'];
          await http.get(url).then((response) {
            callback(convert.jsonDecode(response.body)['status']);
          });
        } else {
          callback(convert.jsonDecode(response.body)['status']);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  /// Async function which loads feedback from endpoint URL and returns List.
  // Future<List<DriveRecordForm>> getFeedbackList() async {
  //   return await http.get(URLORG).then((response) {
  //     var jsonFeedback = convert.jsonDecode(response.body) as List;
  //     return jsonFeedback
  //         .map((json) => DriveRecordForm.fromJson(json))
  //         .toList();
  //   });
  // }

  Future<List<DriveRecordForm>> getData_Easy() async {
    final response = await http.get(URL);
    if (response.statusCode == 200) {
      var temp = convert.jsonDecode(response.body);
      var jsonFeedback = convert.jsonDecode(response.body) as List;
      var temp2 = jsonFeedback.map((json) => DriveRecordForm.fromJson(json));
      var temp3 = temp2.toList();
      return temp3;
    } else {
      throw Exception('Failed to load post');
    }
  }
}
