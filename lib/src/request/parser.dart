import 'dart:async';

class MvcRequestFieldParseResult<T> {
  MvcRequestFieldParseResult({this.value, this.error});
  final T? value;
  final String? error;
}

abstract class MvcRequestFieldParser {
  Map<Type, MvcRequestModelParser> get modelParsers;
  Future<MvcRequestFieldParseResult<T>> parseField<T>({String? field, bool isRequired = true});
}

abstract class MvcRequestModelParser<T> {
  FutureOr<MvcRequestFieldParseResult<T>> parseModel(dynamic value);
}

class MvcFactoryRequestModelParser<T> extends MvcRequestModelParser<T> {
  MvcFactoryRequestModelParser(this.factory);
  final FutureOr<MvcRequestFieldParseResult<T>> Function(dynamic value) factory;

  @override
  FutureOr<MvcRequestFieldParseResult<T>> parseModel(dynamic value) {
    return factory(value);
  }
}
