import 'dart:async';
import 'dart:io';

import 'package:shelf_serve_mvc/shelf_serve_mvc.dart';

import 'request/field_parser.dart';

class _ShelfMvcController<T extends MvcController> {
  _ShelfMvcController(this.prefix, this.create);
  final String prefix;
  final T Function() create;
  T requestController(Request request) {
    return request.getService<T>();
  }
}

class _ShelfMvcMiddlewar<T extends MvcMiddleware> {
  _ShelfMvcMiddlewar();

  T requestMiddlewar(Request request) {
    return request.getService<T>();
  }
}

class _DefaultShelfMvcApp extends MvcApp with DependencyInjectionService {
  _DefaultShelfMvcApp({required this.address, required this.port, required this.middlewares, required this.controllers});
  final Object address;
  final int port;
  final List<_ShelfMvcMiddlewar> middlewares;
  final List<_ShelfMvcController> controllers;
  @override
  Future<HttpServer> run() async {
    var server = await serve(_handler(), address, port);
    print("server runing http://${server.address.host}:${server.port}");
    return server;
  }

  Handler _handler() {
    var pipeline = Pipeline();
    pipeline = pipeline.addMiddleware(
      (innerHandler) {
        return (request) async {
          ShelfMvcRequestManager requestManager = ShelfMvcRequestManager(request);
          var serviceProvider = buildScopedServiceProvider(
            builder: (collection) {
              collection.addSingleton<ShelfMvcRequestManager>((_) => requestManager);
              collection.addSingleton<ShelfMvcRequestProvider>((_) => requestManager);
            },
          );
          var newRequest = requestManager.change(context: {"_shelfMvcIocContainer": serviceProvider});
          var resp = await innerHandler(newRequest);
          return resp;
        };
      },
    );
    for (var element in middlewares) {
      pipeline = pipeline.addMiddleware(
        (innerHandler) {
          return (request) {
            return element.requestMiddlewar(request).middleware(innerHandler)(request);
          };
        },
      );
    }
    var router = Router();
    for (var element in controllers) {
      router.mount(
        element.prefix,
        (request) async {
          final serviceProvider = request.context["_shelfMvcIocContainer"] as ServiceProvider;
          final controller = element.requestController(request);
          controller.request = request;
          final resp = await controller(request);
          scheduleMicrotask(
            () {
              serviceProvider.dispose();
            },
          );
          return resp;
        },
      );
    }
    return pipeline.addHandler(router);
  }
}

class DefaultMvcAppBuilder extends ServiceCollection implements MvcAppBuilder {
  DefaultMvcAppBuilder() : super(allowOverrides: true);
  final List<_ShelfMvcMiddlewar> _middlewares = [];
  final List<_ShelfMvcController> _controllers = [];
  Object _address = InternetAddress.anyIPv4;
  int _port = 8080;

  @override
  void useAddress(Object address) {
    _address = address;
  }

  @override
  void usePort(int port) {
    _port = port;
  }

  @override
  void addController<T extends MvcController>(String prefix, T Function() create) {
    _controllers.add(_ShelfMvcController<T>(prefix, create));
    addScopedSingleton<T>((serviceProvider) => create());
  }

  @override
  void addMiddleware<T extends MvcMiddleware>(T Function() create) {
    addScopedSingleton<T>((container) => create());
    _middlewares.add(_ShelfMvcMiddlewar<T>());
  }

  @override
  Future<MvcApp> buildApp() async {
    addScopedSingleton<MvcRequestFieldParser>((_) => DefaultMvcRequestFieldParser());
    addSingleton<MvcApp>(
      (container) => _DefaultShelfMvcApp(
        address: _address,
        port: _port,
        middlewares: _middlewares,
        controllers: _controllers,
      ),
      initializeWhenServiceProviderBuilt: true,
    );
    var container = build();
    await container.waitServicesInitialize();
    return container.get<MvcApp>();
  }
}
