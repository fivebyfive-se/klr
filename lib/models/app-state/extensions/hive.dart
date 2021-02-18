import 'dart:async';

import 'package:hive/hive.dart';

typedef BoxEventHandler = void Function(BoxEvent event);

extension BoxExtensions on Box {
  StreamSubscription<BoxEvent> listen(
    BoxEventHandler onData, {
      Function onError,
      Function onDone,
      bool cancelOnError
  }) => this.asBroadcastStream().listen(
    onData, 
    onError: onError,
    onDone: onDone,
    cancelOnError: cancelOnError
  );
  
  Stream<BoxEvent> asBroadcastStream() => this.watch().asBroadcastStream();
}

extension HiveExtensions on HiveInterface {
  Future<void> openBoxes(
    Iterable<String> names,
    { StreamConsumer<BoxEvent> consumer,
      void Function(BoxEvent) onUpdate }
  ) async {
    for (var name in names) {
      final stream = (await openBox(name))
        .watch()
        .asBroadcastStream();

      if (consumer != null) {
        consumer.addStream(stream);
      }
      if (onUpdate != null) {
        stream.listen(onUpdate);
      }
    }
  }
}


