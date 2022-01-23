import 'package:intl/intl.dart';
extension DateParsing on DateTime {
  String formatTime() => this.format(syntax: "HH:mm");

  String formatDate() => this.format(syntax: "dd-MM-yyyy");

  String formatDateTime() => this.format(syntax: "EEEE dd  MMMM, hh:mm a");

  String formatDateTimeForPost() => this.format(syntax: "yyyy-MM-ddTHH:mm:ss");

  String format({required String syntax}) {
    return DateFormat(syntax).format(this);
  }
}
extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}