import 'package:flutter_test/flutter_test.dart';
import 'package:merchandising_app/ui/home/view_models/home_viewmodel.dart';

void main() {
  test('Atribuição do título da AppBar', () async {
    final HomeViewModel homeViewModel = HomeViewModel();

    homeViewModel.updateTitleAppBar("Início");
    expect(homeViewModel.titleAppBar, "Início");
  });

  test('Atribuição do subtítulo da AppBar', () async {
    final HomeViewModel homeViewModel = HomeViewModel();

    homeViewModel.updateSubtitleAppBar(null);
    expect(homeViewModel.subtitleAppBar, null);

    homeViewModel.updateSubtitleAppBar("Total: 6");
    expect(homeViewModel.subtitleAppBar, "Total: 6");
  });
}
