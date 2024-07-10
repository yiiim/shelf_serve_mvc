import 'package:shelf_serve_mvc/shelf_serve_mvc.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';

class MvcWebSocketController extends MvcController {
  late final _handler = webSocketHandler(onConnection);
  void onConnection(WebSocketChannel webSocket) {}
  @override
  Future<Response> call(Request request) async {
    return await _handler(request);
  }
}
