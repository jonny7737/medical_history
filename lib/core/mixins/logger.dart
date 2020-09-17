import 'dart:core';

import 'package:medical_history/core/constants.dart';
import 'package:medical_history/core/helpers/trace_parser.dart';
import 'package:medical_history/ui/view_model/logger_provider.dart';

mixin Logger {
  final Boolean _logger = Boolean(false);
  final _model = LoggerProvider();

  bool get isLogging => _logger.value && _model.isLogging(LOGGING_APP);

  void setLogging(bool d) {
    _logger.value = d;
  }

  /// Usage:
  ///   ```lineNumber(StackTrace.current)```
  ///
  int lineNumber(StackTrace trace) {
    return TraceParser(trace).lineNumber;
  }

  /// [log()] A function to print a message to the console.
  ///
  ///     1. [msg]: The String to be logged
  ///
  ///     2. [linenumber]: Optional and enables the logging
  ///     to include the line number of the call to log.
  ///
  ///     3. [always]: Optionally flag a log call to ALWAYS log the message
  ///
  /// Example:
  /// ```dart
  ///     log('Message to log', linenumber: lineNumber(StackTrace.current);
  /// ```
  ///
  void log(String msg, {int linenumber, bool always = false}) {
    if (!always && (!_logger.value || !_model.isLogging(LOGGING_APP))) return;

    /// This is to determine the calling Class type so it can be included in the output.
    String source = this.runtimeType.toString();
    if (linenumber == null)
      print('[$source]=> $msg');
    else
      print('[$source.$linenumber]=> $msg');
  }
}

/// This class allows me to store the DEBUGGING flag more
/// cleanly in a StatelessWidget or other immutable object.
///
class Boolean {
  bool value = false;
  Boolean(bool b) : value = b;
}
