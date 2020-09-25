import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:medical_history/ui/themes/theme_data_provider.dart';
import 'package:medical_history/ui/view_model/user_provider.dart';

final themeDataProvider = ChangeNotifierProvider((_) => ThemeDataProvider());
final userProvider = ChangeNotifierProvider((_) => UserProvider());
