import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getx_todo_list/app/core/utils/keys.dart';

// nosso serviço de armazenamento local
// responsável por ler gravar localmente os dados
class StorageService extends GetxService {
  late GetStorage _box;
  Future<StorageService> init() async {
    _box = GetStorage();
    // await _box.write(taskKey, []);
    // await _box.writeIfNull(taskKey, []);
    return this;
  }

  // lendo e retornando dados pela key
  // usando tipo genérico
  T read<T>(String key) {
    return _box.read(key);
  }

  // escrevendo com tipo dinamico porque não sabemos o tipo
  // que será enviado
  void write(String key, dynamic value) async {
    await _box.write(key, value);
  }
}
