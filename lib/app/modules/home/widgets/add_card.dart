import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:getx_todo_list/app/core/utils/extensions.dart';
import 'package:getx_todo_list/app/core/values/colors.dart';
import 'package:getx_todo_list/app/data/models/task.dart';
import 'package:getx_todo_list/app/modules/home/controller.dart';
import 'package:getx_todo_list/app/widgets/icons.dart';

class AddCard extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  // removemos o const da frente para que se torne o construtor da classe
  AddCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // pegando a listagem de icons
    final icons = getIcons();
    // criando nosso quadrado
    // como cada card terá 3 de margem de cada lado
    // colocamos no calculo do card -12
    var squareWidth = Get.width - 12.0.wp;
    return Container(
      // como pegamos a largura inteira acima
      // e temos 2 cards por linha
      // vamos dividir por 2
      width: squareWidth / 2,
      height: squareWidth / 2,
      margin: EdgeInsets.all(3.0.wp),
      // vamos utilizar o InkWell para poder conter
      // os efeitos de clique físico do material
      child: InkWell(
        onTap: () async {
          await Get.defaultDialog(
              titlePadding: EdgeInsets.symmetric(vertical: 5.0.wp),
              radius: 5,
              title: 'Task Type',
              content: Form(
                key: homeCtrl.formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.0.wp),
                      child: TextFormField(
                          controller: homeCtrl.editCtrl,
                          // configurando a decoração da caixa de input
                          decoration: const InputDecoration(
                            // borda externa
                            border: OutlineInputBorder(),
                            // titulo
                            labelText: 'Title',
                          ),
                          // criando validador do form
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your task title';
                            }
                            return null;
                          }),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0.wp),
                      child: Wrap(
                        spacing: 2.0.wp,
                        children: icons
                            .map((e) => Obx(
                                  () {
                                    final index = icons.indexOf(e);
                                    return ChoiceChip(
                                      selectedColor: Colors
                                          .grey[200], // cor do selecionado
                                      pressElevation:
                                          0, // elavação do pressionado
                                      backgroundColor:
                                          Colors.white, // cor de fundo
                                      label: e,
                                      // exibimos selecionado o icone que estiver no chipIndex
                                      selected:
                                          homeCtrl.chipIndex.value == index,
                                      // quando selecionamos um icone da lista
                                      // este icone passa a ser nosso ChipIndex selecionado
                                      onSelected: (bool selected) {
                                        homeCtrl.chipIndex.value =
                                            selected ? index : 0;
                                      },
                                    );
                                  },
                                ))
                            .toList(),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        minimumSize: const Size(150, 40),
                      ),
                      onPressed: () {
                        if (homeCtrl.formKey.currentState!.validate()) {
                          // pegando o icone selecionado
                          int icon =
                              icons[homeCtrl.chipIndex.value].icon!.codePoint;
                          // pegando a cor do icone selecionado
                          String color =
                              icons[homeCtrl.chipIndex.value].color!.toHex();

                          // criando a task
                          var task = Task(
                              title: homeCtrl.editCtrl.text,
                              icon: icon,
                              color: color);
                          // fechando o dialogo
                          Get.back();
                          // salvando a tarefa
                          homeCtrl.addTask(task)
                              ? EasyLoading.showSuccess('Create Sucess')
                              : EasyLoading.showError('Duplicated Task');
                        }
                      },
                      child: const Text('Confirm'),
                    )
                  ],
                ),
              ));
          // quando a modal fechar
          // limpando o formulario
          // setando o primeiro como selecionado
          homeCtrl.editCtrl.clear();
          homeCtrl.changeChipIndex(0);
        },
        // aplicando a borda
        child: DottedBorder(
          color: Colors.grey[400]!,
          dashPattern: const [8, 4],
          child: Center(
            child: Icon(
              Icons.add,
              size: 10.0.wp,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
