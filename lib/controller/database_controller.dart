import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DatabaseController extends GetxController {
  final _realtimeDatabaseRef = FirebaseDatabase.instance.ref('restante');
  final _firestoreDatabaseRef =
      FirebaseFirestore.instance.collection('participants');
  late StreamSubscription<DatabaseEvent> remainSubscription;

  var remain = 0.obs;

  @override
  void onInit() {
    super.onInit();
    initializeData();
  }

  // Método que verifica se o CPF já existe no Database
  Future<bool> documentAlreadyExists(String cpf) async {
    var document = await _firestoreDatabaseRef.doc(cpf).get();
    if (document.exists) {
      Get.snackbar(
        "Erro",
        "Já existe um usuário cadastrado com esse CPF!",
        colorText: Colors.white,
        icon: const Icon(Icons.error_rounded),
        backgroundColor: Colors.redAccent,
      );
      return true;
    }
    return false;
  }

  // Método que realiza a inscrição do evento, criando o document do user
  // e decrementa a quantidade de vagas disponíveis
  doInscription(String cpf, String name, int phone, String item) async {
    await _firestoreDatabaseRef.doc(cpf).set({
      'nome': name,
      'telefone': phone,
      'item': item,
    });
    await _realtimeDatabaseRef.set(remain.value - 1);
  }

  // Método que escuta as alterações no Realtime Database.
  initializeData() async {
    remainSubscription = _realtimeDatabaseRef.onValue.listen(
      (event) {
        remain((event.snapshot.value ?? 0) as int);
      },
    );
  }
}
