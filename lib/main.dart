import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getx_todo_list/app/data/services/storage/services.dart';
import 'package:getx_todo_list/app/modules/home/biding.dart';
import 'package:getx_todo_list/app/modules/home/view.dart';

void main() async {
  // inicando o storage local
  await GetStorage.init();
  // retornando instância de armazenamento
  await Get.putAsync(() => StorageService().init());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Todo List Using GetX',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      initialBinding: HomeBiding(),
      // easyloading biblioteca para load de carregamento
      builder: EasyLoading.init(),
    );
  }
}
