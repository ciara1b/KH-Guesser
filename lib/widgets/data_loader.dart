import '../models/character.dart';
import '../models/keyblade.dart';

Future<void>? _loading;

Future<void> get dataReady =>
    _loading ??= Future.wait([loadCharacters(), loadKeyblades()]).then((_) {});
