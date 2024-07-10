import 'package:shelf_serve_mvc/shelf_serve_mvc.dart';

part 'test_controller.g.dart';

class TestModel {
  final String id;
  final String name;
  TestModel({required this.id, required this.name});

  static fromRequestField(Map<String, dynamic> data) {
    return TestModel(
      id: data["id"],
      name: data["name"],
    );
  }
}

class TestController extends MvcController with _$TestController {
  @HttpGet("/test")
  Future<Response> test({required String id}) {
    return Future.value(Response.ok("test"));
  }

  @HttpPost("/test1")
  Future<Response> test1(TestModel model) {
    return Future.value(Response.ok("test"));
  }
}
