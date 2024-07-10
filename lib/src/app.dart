import 'dart:io';

abstract class MvcApp {
  Future<HttpServer> run();
}
