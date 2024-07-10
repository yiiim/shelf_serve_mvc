class HttpMethod {
  const HttpMethod(this.method, [this.path]);

  final String method;
  final String? path;
}

class HttpGet extends HttpMethod {
  const HttpGet([String? path]) : super("get", path);
}

class HttpPost extends HttpMethod {
  const HttpPost([String? path]) : super("post", path);
}

class HttpPut extends HttpMethod {
  const HttpPut([String? path]) : super("put", path);
}

class HttpDelete extends HttpMethod {
  const HttpDelete([String? path]) : super("delete", path);
}

class HttpPatch extends HttpMethod {
  const HttpPatch([String? path]) : super("patch", path);
}

class HttpOptions extends HttpMethod {
  const HttpOptions([String? path]) : super("options", path);
}

class HttpHead extends HttpMethod {
  const HttpHead([String? path]) : super("head", path);
}
