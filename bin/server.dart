import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import './hot_reload.dart' show enableHotReload;
import './routes/db_handle_router.dart';

void main(List<String> args) async {
// Configure routes.
  final mainRouter = Router();
  mainRouter.mount("/db", DbHandleRouter().router.call);
  await enableHotReload();

  final ip = InternetAddress.anyIPv4;
  // Configure a pipeline that logs requests.
  final handler = Pipeline()
      .addMiddleware(
        logRequests(),
      )
      .addHandler(
        mainRouter.call,
      );

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
