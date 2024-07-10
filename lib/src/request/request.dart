import 'package:dart_dependency_injection/dart_dependency_injection.dart';
import 'package:shelf/shelf.dart';

extension MvcRequestExtension on Request {
  T getService<T>() {
    return (context["_shelfMvcIocContainer"] as ServiceProvider).get<T>();
  }
}

abstract class ShelfMvcRequestProvider {
  Request get request;
}

class ShelfMvcRequestManager implements ShelfMvcRequestProvider {
  ShelfMvcRequestManager(Request request) : _request = request;
  Request _request;

  @override
  Request get request => _request;

  Request change({
    Map<String, Object?>? headers,
    Map<String, Object?>? context,
    String? path,
    Object? body,
  }) {
    _request = _request.change(
      headers: headers,
      context: context,
      path: path,
      body: body,
    );
    return _request;
  }
}
