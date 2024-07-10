import 'package:shelf_serve_mvc/shelf_serve_mvc.dart';

class TestWebSocketController extends MvcWebSocketController {
  @override
  void onConnection(WebSocketChannel webSocket) {
    print("onConnection");
    webSocket.stream.listen(
      (event) {
        print("event $event");
      },
    );
  }

  void onDone() {
    print("onDone");
  }

  void onError(Object e, StackTrace stackTrace) {
    print("onError $e");
  }

  @override
  Future<Response> call(Request request) {
    print("test web socket controller$hashCode");
    return super.call(request);
  }
}
