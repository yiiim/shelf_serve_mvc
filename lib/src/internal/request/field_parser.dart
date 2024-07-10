import 'dart:async';
import 'dart:convert';

import 'package:shelf_multipart/form_data.dart';
import 'package:shelf_serve_mvc/shelf_serve_mvc.dart';

class DefaultMvcRequestFieldParser with DependencyInjectionService implements MvcRequestFieldParser {
  late final ShelfMvcRequestProvider requestManager = getService();
  Request? _request;

  dynamic _data;

  Future _readBodyIfNeed() async {
    if (_data == null || _request != requestManager.request) {
      _request = requestManager.request;
      final request = _request!;
      if (['get', 'head', 'delete'].contains(request.method.toLowerCase())) {
        _data = request.url.queryParameters;
      } else {
        if (request.headers['content-type']?.startsWith('application/json') == true) {
          _data = jsonDecode(await request.readAsString());
        } else if (request.headers['content-type']?.startsWith('application/x-www-form-urlencoded') == true) {
          _data = await request.multipartFormData.toList();
        } else {
          _data = await request.read().toList();
        }
      }
    }
  }

  @override
  Future<MvcRequestFieldParseResult<T>> parseField<T>({String? field, bool isRequired = true}) async {
    await _readBodyIfNeed();
    dynamic fieldData;
    if (field == null) {
      fieldData = _data;
    } else {
      if (_data is Map<String, dynamic>) {
        fieldData = _data[field];
      } else if (_data is List<FormData>) {
        for (FormData element in _data) {
          if (element.name == field) {
            fieldData = element;
            break;
          }
        }
      }
    }
    if (fieldData == null) {
      if (isRequired) {
        return MvcRequestFieldParseResult<T>(error: 'Missing required field ${field ?? ""}');
      } else {
        return MvcRequestFieldParseResult<T>();
      }
    }
    if (fieldData is T) {
      return MvcRequestFieldParseResult<T>(value: fieldData);
    }
    final result = switch (T) {
      String => MvcRequestFieldParseResult<T>(value: fieldData.toString() as T),
      int => MvcRequestFieldParseResult<T>(value: int.tryParse(fieldData.toString()) as T?),
      double => MvcRequestFieldParseResult<T>(value: double.tryParse(fieldData.toString()) as T?),
      bool => MvcRequestFieldParseResult<T>(value: (fieldData == 1 || fieldData == '1' || fieldData == 'true') as T?),
      _ => await _parseModel<T>(fieldData),
    };
    if (result != null) {
      if (result.error == null && result.value == null && isRequired) {
        return MvcRequestFieldParseResult<T>(error: 'Invalid field ${field ?? ""} value');
      }
      return result;
    }
    return MvcRequestFieldParseResult(error: 'Cant parse field ${field ?? ""} ');
  }

  FutureOr<MvcRequestFieldParseResult<T>?> _parseModel<T>(dynamic fieldData) async {
    final service = tryGetService<MvcRequestModelParser<T>>();
    if (service != null) {
      return await service.parseModel(fieldData);
    }
    final parser = modelParsers[T] as MvcRequestModelParser<T>?;
    if (parser != null) {
      return await parser.parseModel(fieldData);
    }
    return null;
  }

  @override
  Map<Type, MvcRequestModelParser> modelParsers = {};
}
