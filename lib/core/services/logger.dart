import 'dart:core';

import 'package:medical_history/core/constants.dart';
import 'package:medical_history/core/helpers/trace_parser.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/models/logger_model.dart';

class Logger {
  final LoggerModel _model = locator();

  initSectionPref(String sectionName) {
    _model.initSectionPref(sectionName);
  }

  bool isLogging(String sectionName) =>
      _model.isEnabled(sectionName) && _model.isEnabled(LOGGING_APP);

  bool logsEnabled(String sectionName) => _model.isEnabled(sectionName);

  /// Usage:
  ///   ```lineNumber(StackTrace.current)```
  ///
  int lineNumber(StackTrace trace) {
    return TraceParser(trace).lineNumber;
  }

  /// [log()] A function to print a message to the console.
  ///
  ///     1. [source]: reference to the source of the log request.
  ///
  ///     2. [msg]: The String to be logged
  ///
  ///     3. [linenumber]: Optional and enables the logging
  ///     to include the line number of the call to log.
  ///
  ///     4. [always]: Optionally flag a log call to ALWAYS log the message
  ///
  /// Example:
  /// ```dart
  ///     log('Message to log', linenumber: lineNumber(StackTrace.current);
  /// ```
  ///
  void log(String source, String msg, {int linenumber, bool always = false}) {
    bool enabled = false;
    assert(enabled = true);
    if (!enabled) return;
    if (!always && (!_model.isEnabled(source) || !_model.isEnabled(LOGGING_APP))) return;

    if (linenumber == null)
      print('[$source]=> $msg');
    else
      print('[$source.$linenumber]=> $msg');
  }
}
