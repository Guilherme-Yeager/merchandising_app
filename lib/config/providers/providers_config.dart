import 'package:merchandising_app/ui/auth/login/view_models/login_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

abstract class ProvidersConfig {
  static List<SingleChildWidget> get providers => [
    ChangeNotifierProvider(create: (_) => LoginViewmodel()),
  ];
}
