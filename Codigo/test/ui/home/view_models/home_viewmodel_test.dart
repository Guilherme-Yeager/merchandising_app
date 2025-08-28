import 'package:flutter_test/flutter_test.dart';
import 'package:merchandising_app/ui/home/view_models/home_viewmodel.dart';

void main() {
  group('HomeViewModel', () {
    late HomeViewModel homeViewModel;

    setUp(() {
      homeViewModel = HomeViewModel();
    });

    test('Atribuição do título da AppBar', () async {
      // Act
      homeViewModel.updateTitleAppBar("Início");

      // Assert
      expect(homeViewModel.titleAppBar, "Início");
    });

    test('Atribuição do subtítulo da AppBar igual a null', () async {
      // Act
      homeViewModel.updateSubtitleAppBar(null);

      // Assert
      expect(homeViewModel.subtitleAppBar, null);
    });

    test('Atribuição do subtítulo da AppBar', () async {
      // Act
      homeViewModel.updateSubtitleAppBar("Total: 6");

      // Assert
      expect(homeViewModel.subtitleAppBar, "Total: 6");
    });
  });
}
