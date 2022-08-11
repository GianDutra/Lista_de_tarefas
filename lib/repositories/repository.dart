import 'package:sqflite/sqflite.dart';
import 'package:todolist_app/repositories/database_connection.dart';

class Repository{
  DatabaseConnection _databaseConnection;

    Repository(){
    _databaseConnection = DatabaseConnection();
  }

  static Database _database;

  //Verifica se existe uma database ou não
  Future<Database> get database async{
    if(_database!=null) return _database;
    _database = await _databaseConnection.setDatabase();
    return _database;
  }

  //Insere uma data na tabela
  insertData(table, data) async {
    var connection = await database;
    return await connection.insert(table, data);
  }


  // Ler data da tabela
readData(table) async {
    var connection = await database;
    return await connection.query(table);
}
  // Ler data da tablea por id
  readDataById(table, itemId) async{
    var connection = await database;
    return await connection.query(table, where: "id=?", whereArgs: [itemId]);
  }

  //atualizar data da tabela
  updateData(table, data) async{
    var connection = await data;
    return await connection.update(table,data, where: 'id=?', whereArgs: [data['id']]);
  }

  //deletar data da tabela
  deleteData(table, itemId) async{
    var connection = await database;
    return await connection.rawDelete("DELETE FROM $table WHERE id = $itemId");
  }

  //Ler data da tabela pelo nome da tabela
  readDataByColumnName(table,columnName,columnValue) async{
    var connection = await database;
    return await connection.query(table,where: '$columnName=?', whereArgs: [columnValue]);
  }
}