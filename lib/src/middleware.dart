import 'package:dart_dependency_injection/dart_dependency_injection.dart';
import 'package:shelf/shelf.dart';

abstract class MvcMiddleware with DependencyInjectionService {
  Handler middleware(Handler handler) => handler;
}
