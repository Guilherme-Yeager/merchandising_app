import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _instance = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      dateTimeFormat: (time) => "[${time.hour}:${time.minute}:${time.second}]",
    ),
  );

  static Logger get instance => _instance;
}
