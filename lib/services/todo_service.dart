import 'package:todolist_app/models/todo.dart';
import 'package:todolist_app/repositories/repository.dart';

class TodoService{
  Repository _repository;

  TodoService(){
    _repository= Repository();
  }


  //criar todos
  saveTodo(Todo todo) async{
    return await _repository.insertData('todos', todo.todoMap());
  }

  //ler todos

  readTodos() async{
    return await _repository.readData('todos');
  }

  //ler lista de tarefas por categorias
readTodosByCategory(category) async{
    return await _repository.readDataByColumnName('todos', 'category', category);
}
}