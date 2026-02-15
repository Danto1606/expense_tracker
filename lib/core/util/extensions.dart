import 'package:intl/intl.dart';

extension DateUtil on DateTime {
  String getOrdinalDate() {
    String suffix = 'th';

    if (day >= 11 && day <= 13) {
      suffix = 'th';
    } else {
      switch (day % 10) {
        case 1:
          suffix = 'st';
          break;
        case 2:
          suffix = 'nd';
          break;
        case 3:
          suffix = 'rd';
          break;
        default:
          suffix = 'th';
      }
    }
    String monthAndYear = DateFormat('MMMM, yyyy').format(this);

    return '$day$suffix $monthAndYear';
  }
}
