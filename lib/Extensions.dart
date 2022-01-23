import 'package:intl/intl.dart';
extension DateParsing on DateTime {
  String formatTime() => this.format(syntax: "HH:mm");

  String formatDate() => this.format(syntax: "dd-MM-yyyy");

  String formatDateTime() => this.format(syntax: "dd-MM-yyyy HH:mm");

  String formatDateTimeForPost() => this.format(syntax: "yyyy-MM-ddTHH:mm:ss");

  String format({required String syntax}) {
    return DateFormat(syntax).format(this);
  }
}