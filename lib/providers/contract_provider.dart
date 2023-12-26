import 'package:flutter/foundation.dart';
import 'package:vertualcardview/db/db_helper.dart';
import 'package:vertualcardview/models/contact_model.dart';

class ContractProvider extends ChangeNotifier{
  List<ContactModel> contractList = [];
  final db = DbHelper();

  Future<int> insertContract(ContactModel contactModel) async{
    final rowId = await db.insertContract(contactModel);
    contactModel.id = rowId;
    contractList.add(contactModel);
    notifyListeners();
    return rowId;
  }

  Future<void> getAllContractsData() async{
    contractList =  await db.getAllContract();
    notifyListeners();
  }

  Future<int> deleteContract(int id) {
    return db.deleteContract(id);
  }
}