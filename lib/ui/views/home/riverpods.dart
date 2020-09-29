import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medical_history/core/global_providers.dart';
import 'package:medical_history/ui/views/home/home_viewmodel.dart';

final homeViewModel = ChangeNotifierProvider<HomeViewModel>((ref) {
  final user = ref.watch(userProvider);
  return HomeViewModel(
    user: user,
  );
});
