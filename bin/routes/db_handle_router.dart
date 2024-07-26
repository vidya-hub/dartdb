import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../models/db_credential_model.dart';
import '../utils/file_utils/db_function_utils.dart';

class DbHandleRouter {
  Router get router {
    final dbRouter = Router();
    dbRouter.post("/create", _createDbHandler);

    return dbRouter;
  }

  Future<Response> _createDbHandler(Request request) async {
    String requestBody = await request.readAsString();

    if (requestBody.isEmpty) {
      return _createErrorResponse(
        404,
        "Please provide DB details.",
      );
    }

    Map<String, dynamic> decodedBody = json.decode(requestBody);

    DbCredentialModel dbCredentialModel = DbCredentialModel.fromJson(
      decodedBody,
    );

    if (dbCredentialModel.errorValidation.isNotEmpty) {
      return _createErrorResponse(
        400,
        dbCredentialModel.errorValidation,
      );
    }

    String dbFileName = dbCredentialModel.dbFileName;
    if (File(dbFileName).existsSync()) {
      return _createErrorResponse(
        409,
        "DB already exists.",
      );
    }

    DbFunctionUtils.createDbData(
      dbCredentialModel: dbCredentialModel,
    );

    return Response.ok(json.encode({
      "message": "OK",
      "details": decodedBody,
    }));
  }

  Response _createErrorResponse(
    int statusCode,
    String message,
  ) {
    return Response(
      statusCode,
      body: json.encode({"message": message}),
      headers: {
        'Content-Type': 'application/json',
      },
    );
  }
}
