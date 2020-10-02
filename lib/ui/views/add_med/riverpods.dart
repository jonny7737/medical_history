import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medical_history/ui/views/add_med/add_med_viewmodel.dart';
import 'package:medical_history/ui/views/add_med/widgets/error_message_viewmodel.dart';

final addMedViewModel = ChangeNotifierProvider<AddMedViewModel>((_) => AddMedViewModel());
final errorMessageViewModel = ChangeNotifierProvider((_) => ErrorMessageViewModel());
