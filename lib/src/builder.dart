import 'package:dart_dependency_injection/dart_dependency_injection.dart';

import 'app.dart';
import 'controller.dart';
import 'internal/builder.dart';
import 'middleware.dart';

abstract class MvcAppBuilder extends ServiceCollection {
  factory MvcAppBuilder() => DefaultMvcAppBuilder();

  void addController<T extends MvcController>(String prefix, T Function() create);
  void addMiddleware<T extends MvcMiddleware>(T Function() create);
  void useAddress(Object address);
  void usePort(int port);
  Future<MvcApp> buildApp();
}
