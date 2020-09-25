import 'package:hooks_riverpod/all.dart';
import 'package:medical_history/ui/views/login/login_view_model.dart';

final viewModel = ChangeNotifierProvider((_) => LoginViewModel());
