import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medical_history/ui/views/home/home_viewmodel.dart';

final homeViewModel = ChangeNotifierProvider((_) => HomeViewModel());
