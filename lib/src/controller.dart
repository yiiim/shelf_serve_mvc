import 'dart:async';
import 'dart:convert';

import 'package:dart_dependency_injection/dart_dependency_injection.dart';
import 'package:shelf/shelf.dart';

import 'request/parser.dart';

abstract class MvcController with DependencyInjectionService {
  late final Request request;
  Future<Response> call(Request request);

  Response json(dynamic object) {
    return Response.ok(jsonEncode(object), headers: {'content-type': 'application/json'});
  }

  FutureOr<MvcRequestFieldParseResult<T>> parseRequestField<T>(dynamic data, {bool isRequired = true}) {
    return MvcRequestFieldParseResult<T>();
  }
}
