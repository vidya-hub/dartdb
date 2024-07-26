import 'dart:io';
import 'dart:developer' as dev;
import 'package:vm_service/utils.dart';
import 'package:vm_service/vm_service_io.dart';
import './utils/logger.dart' show StdoutLog;
import 'package:watcher/watcher.dart';
import 'package:stream_transform/stream_transform.dart';

Future<bool> enableHotReload() async {
  var observatoryUri = (await dev.Service.getInfo()).serverUri;
  if (observatoryUri == null) {
    print(
        'You need to pass `--enable-vm-service --disable-service-auth-codes` to enable hot reload');
    return false;
  }
  try {
    var serviceClient = await vmServiceConnectUri(
      convertToWebSocketUrl(serviceProtocolUrl: observatoryUri).toString(),
      log: StdoutLog(),
    );

    var vm = await serviceClient.getVM();
    var mainIsolate = (vm.isolates ?? []).first;

    Watcher(Directory.current.path)
        .events
        .throttle(
          const Duration(milliseconds: 1000),
        )
        .listen((_) async {
      await serviceClient.reloadSources(mainIsolate.id ?? "");
      print('Server restarted ${DateTime.now()}');
    });
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}
