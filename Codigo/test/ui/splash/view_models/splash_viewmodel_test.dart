import 'package:flutter_test/flutter_test.dart';
import 'package:merchandising_app/ui/splash/view_models/splash_viewmodel.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@GenerateMocks([SupabaseClient, GoTrueClient, Session])
import 'splash_viewmodel_test.mocks.dart';

void main() {
  group('SplashViewModel', () {
    late SplashViewModel splashViewModel;
    late MockSupabaseClient mockSupabaseClient;
    late MockGoTrueClient mockAuth;

    setUp(() {
      mockSupabaseClient = MockSupabaseClient();
      mockAuth = MockGoTrueClient();
      when(mockSupabaseClient.auth).thenReturn(mockAuth);
      splashViewModel = SplashViewModel(supabaseClient: mockSupabaseClient);
    });

    test('sessaoEstaValida deve retornar true quando há uma sessão válida', () {
      // Arrange
      final MockSession mockSession = MockSession();
      when(mockAuth.currentSession).thenReturn(mockSession);

      // Act
      final bool result = splashViewModel.sessaoEstaValida();

      // Assert
      expect(result, true);
    });

    test('sessaoEstaValida deve retornar false quando não há sessão', () {
      // Arrange
      when(mockAuth.currentSession).thenReturn(null);

      // Act
      final bool result = splashViewModel.sessaoEstaValida();

      // Assert
      expect(result, false);
    });
  });
}
