import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
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
  //**************************************  delete contract
  Future<int> deleteContract(int id) {
    return db.deleteContract(id);
  }

  // ******************************** for update

  Future<void> updateContractField (ContactModel contactModel, String field) async{
    await db.updateContractField(contactModel.id, {field : contactModel.favorite ? 0 : 1});
    final index = contractList.indexOf(contactModel);
    contractList[index].favorite = !contractList[index].favorite;
    notifyListeners();
  }
}