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
  //******************************* insert value in the database
    Future<int> insertContract(ContactModel contactModel) async{
     final db = await _open();
     return db.insert(tableContact, contactModel.toMap());
    }
    //**************************** make a query for render value in display
  Future<List<ContactModel>> getAllContract() async{
    final db = await _open();
    final mapList = await db.query(tableContact);
    return List.generate(mapList.length, (index) => ContactModel.fromMap(mapList[index]));
  }
}