import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../utils/file_utils/file_utils.dart';
import '../models/db_credential_model.dart';

class DbHandleRouter {
  Router get router {
    final dbRouter = Router();
    dbRouter.post("/create", createDbHandler);
    return dbRouter;
  }

  Future<Response> createDbHandler(Request request) async {
    String requestBody = await request.readAsString();
    if (requestBody.isEmpty) {
      return Response(
        404,
        body: json.encode(
          {"message": "please provide db details"},
        ),
      );
    }
    Map<String, dynamic> decodedBody = json.decode(
      requestBody,
    );
    DbCredentialModel dbCredentialModel = DbCredentialModel.fromJson(
      decodedBody,
    );
    if (dbCredentialModel.errorValidation.isNotEmpty) {
      return Response(
        404,
        body: json.encode(
          {
            "message": dbCredentialModel.errorValidation,
          },
        ),
      );
    }
    String dbName = dbCredentialModel.getDbFolder;
    return Response(
      200,
      body: json.encode({
        "message": "OK",
        "details": decodedBody,
        "file": dbName,
      }),
    );
  }
}
