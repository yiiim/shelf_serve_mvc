// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_controller.dart';

// **************************************************************************
// ShelfMvcGenerator
// **************************************************************************

mixin _$TestController on MvcController {
  late final MvcRequestFieldParser _fieldParser =
      getService<MvcRequestFieldParser>();

  @override
  Future<Response> call(Request request) {
    final router = Router();
    router.add(
      'get',
      '/test',
      (request) => _test(request),
    );
    router.add(
      'post',
      '/test1',
      (request) => _test1(request),
    );
    return router.call(request);
  }

  Future<Response> _test(Request request) async {
    final namedPid = await _fieldParser.parseField<String>(
      field: "id",
      isRequired: true,
    );
    if (namedPid.error != null) {
      return Response(400, body: namedPid.error);
    }
    return (this as TestController).test(id: namedPid.value!);
  }

  Future<Response> _test1(Request request) async {
    _fieldParser.modelParsers[TestModel] =
        MvcFactoryRequestModelParser<TestModel>(
            (data) => TestModel.fromRequestField(data));
    final p0 = await _fieldParser.parseField<TestModel>(isRequired: true);
    if (p0.error != null) {
      return Response(400, body: p0.error!);
    }
    return (this as TestController).test1(p0.value!);
  }
}
