import 'dart:io';

import 'package:dart_dependency_injection/dart_dependency_injection.dart';

import 'internal/use_environment.dart';

String kShelfMvcReleaseMode = 'ShelfMvcRelease';
String kShelfMvcTestMode = 'ShelfMvcTest';
String kShelfMvcDebugMode = 'ShelfMvcDebug';

class ShelfMvcAppEnvironment with DependencyInjectionService {
  late final String? _useEnvironmentName = tryGetService<ShelfMvcUseEnvironment>()?.name;
  late final String? _platformEnvironmentmName = Platform.environment["ShelfMvcServerMode"];
  String get name {
    return _useEnvironmentName ?? _platformEnvironmentmName ?? kShelfMvcReleaseMode;
  }

  bool get isRelease => name == kShelfMvcReleaseMode;
  bool get isTest => name == kShelfMvcTestMode;
  bool get isDebug => name == kShelfMvcDebugMode;
}

extension ShelfMvcAppEnvironmentExtension on ServiceCollection {
  void useEnvironment(String name) {
    addSingleton((_) => ShelfMvcUseEnvironment(name));
  }
}
