import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../models/db_query_model.dart';
import '../models/db_credential_model.dart';
import '../models/exception/database_exec_exception.dart';
import '../utils/file_utils/db_function_utils.dart';

class DbHandleRouter {
  Router get router {
    final dbRouter = Router();
    dbRouter.post("/register", _createUserHandler);
    dbRouter.post("/login", _getUserHandler);
    dbRouter.post("/query", _dbQueryHandler);
    return dbRouter;
  }

  Future<Response> _dbQueryHandler(Request request) async {
    String requestBody = await request.readAsString();
    print(requestBody);

    if (requestBody.isEmpty) {
      return _createErrorResponse(
        404,
        "Please provide DB details.",
      );
    }

    DbQueryModel userCredentials = DbQueryModel.fromJson(
      requestBody,
    );

    if (userCredentials.errorValidation.isNotEmpty) {
      return _createErrorResponse(
        400,
        userCredentials.errorValidation,
      );
    }
    try {
      Map<String, dynamic> queryResponse = userCredentials.executeQuery();

      return Response(
        200,
        body: json.encode(
          {
            "msg": "Query Executed Successfully!",
            "data": queryResponse,
          },
        ),
      );
    } catch (e) {
      if (e is DatabaseExecException) {
        return _createErrorResponse(400, e.message);
      }
      return _createErrorResponse(
        404,
        e.toString(),
      );
    }
  }

  Future<Response> _createUserHandler(Request request) async {
    String requestBody = await request.readAsString();

    if (requestBody.isEmpty) {
      return _createErrorResponse(
        404,
        "Please provide DB details.",
      );
    }

    UserCredentialModel userCredentials = UserCredentialModel.fromJson(
      requestBody,
    );

    if (userCredentials.errorValidation.isNotEmpty) {
      return _createErrorResponse(
        400,
        userCredentials.errorValidation,
      );
    }
    if (userCredentials.isDataExists) {
      return _createErrorResponse(
        409,
        "User already exists.",
      );
    }

    DbFunctionUtils.saveUserCredentials(
      userCredentials: userCredentials,
    );

    return Response.ok(
      json.encode({
        "message": "OK",
        "data": json.decode(requestBody),
      }),
    );
  }

  Future<Response> _getUserHandler(Request request) async {
    String requestBody = await request.readAsString();

    if (requestBody.isEmpty) {
      return _createErrorResponse(
        404,
        "Please provide DB details.",
      );
    }

    UserCredentialModel userCredentials = UserCredentialModel.fromJson(
      requestBody,
    );

    if (userCredentials.errorValidation.isNotEmpty) {
      return _createErrorResponse(
        400,
        userCredentials.errorValidation,
      );
    }
    if (userCredentials.isValidCredentials) {
      return Response.ok(
        json.encode({
          "message": "OK",
          "data": json.decode(requestBody),
        }),
      );
    }

    DbFunctionUtils.saveUserCredentials(
      userCredentials: userCredentials,
    );

    return Response.ok(
      json.encode({
        "message": "OK",
        "data": json.decode(requestBody),
      }),
    );
  }

  Response _createErrorResponse(
    int statusCode,
    String message,
  ) {
    return Response(
      statusCode,
      body: json.encode({
        "message": message,
        "data": null,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );
  }
}
