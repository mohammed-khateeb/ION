
import 'package:flutter/material.dart';
import 'package:ion_application/Services/transactions_services.dart';

import '../Models/Api/transactions.dart';
import '../Models/Responses/httpresponse.dart';

class TransactionsController with ChangeNotifier {
  List<Transaction>? transactions;
  bool waiting = true;


  Future getTransactions() async {
    final TransactionsServices transactionsServices = TransactionsServices();
    HttpResponse<List<Transaction>> response = await transactionsServices.getTransactions();
    if(response.isSuccess!){
      setTransactions(response.data!);
    }
  }

  Future<List<int>> getSessionActive() async {
    final TransactionsServices transactionsServices = TransactionsServices(useV3: true);
    HttpResponse<List<int>> response = await transactionsServices.getSessionActive();
    return response.data!;
  }

  void setTransactions(List<Transaction> transactions) {
    this.transactions = transactions;
    waiting = false;
    notifyListeners();
  }

  Future waitTransaction()async{
    waiting = true;
    transactions = null;
    notifyListeners();
  }
}
