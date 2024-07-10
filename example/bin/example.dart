import 'package:example/test_controller.dart';
import 'package:example/test_web_socket_controller.dart';
import 'package:shelf_serve_mvc/shelf_serve_mvc.dart';

class TestMiddleware1 extends MvcMiddleware {
  @override
  Handler middleware(Handler handler) {
    return (request) {
      print("middleware 1 $hashCode");
      return handler(request);
    };
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose middleware 1 $hashCode");
  }
}

class TestMiddleware2 extends MvcMiddleware {
  @override
  Handler middleware(Handler handler) {
    return (request) {
      print("middleware 2 $hashCode");
      if (request.requestedUri.path.startsWith("/b")) {
        return Response.ok("middleware 2");
      }
      return handler(request);
    };
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose middleware 2 $hashCode");
  }
}

class TestMiddleware3 extends MvcMiddleware {
  @override
  Handler middleware(Handler handler) {
    return (request) {
      print("middleware 3 $hashCode");
      return handler(request);
    };
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose middleware 3 $hashCode");
  }
}

void main() async {
  MvcAppBuilder builder = MvcAppBuilder();
  builder.addController<TestController>("/test", () => TestController());
  builder.addController<TestWebSocketController>("/ws", () => TestWebSocketController());
  builder.addMiddleware<TestMiddleware1>(() => TestMiddleware1());
  builder.addMiddleware<TestMiddleware2>(() => TestMiddleware2());
  builder.addMiddleware<TestMiddleware3>(() => TestMiddleware3());
  var app = await builder.buildApp();
  app.run();
}
