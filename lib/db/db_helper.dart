import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:vertualcardview/models/contact_model.dart';
class DbHelper{
  Future<Database> _open() async{
    final String _createTableContact = '''create table $tableContact(
    $tblContactColId integer primary key autoincrement,
    $tblContactColName text,
    $tblContactColMobile text,
    $tblContactColEmail text,
    $tblContactColAddress text,
    $tblContactColCompany text,
    $tblContactColDesignation text,
    $tblContactColWebsite text,
    $tblContactColImage text,
    $tblContactColFavorite integer)''';
    final root =  await getDatabasesPath();
    final dbPath = p.join(root, 'contract.db');
    return openDatabase(dbPath, version: 1, onCreate: (db, version){
      db.execute(_createTableContact);
    },);
  }
  //.......................................................................... insert value in the database
    Future<int> insertContract(ContactModel contactModel) async{
     final db = await _open();
     return db.insert(tableContact, contactModel.toMap());
    }

    //....................................................................... get contract by id
  Future<ContactModel> getAllContractById(int id) async{
    final db = await _open();
    final mapList = await db.query(tableContact, where: '$tblContactColId = ?', whereArgs: [id]);
    return  ContactModel.fromMap(mapList.first);
  }
    //........................................................................ make a query for render value in display[get data from database]
  Future<List<ContactModel>> getAllContract() async{
    final db = await _open();
    final mapList = await db.query(tableContact);
    return List.generate(mapList.length, (index) => ContactModel.fromMap(mapList[index]));
  }
  //.......................................................................... for delete

Future<int> deleteContract(int id) async{
    final db = await _open();
    return db.delete(tableContact, where: '$tblContactColId = ?', whereArgs: [id]);
}
//............................................................................. for update
Future<int> updateContractField (int id, Map<String, dynamic> map) async{
   final db =  await _open();
   return db.update(tableContact, map, where: '$tblContactColId = ?', whereArgs: [id]);
}
}