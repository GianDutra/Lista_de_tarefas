import 'package:todolist_app/repositories/repository.dart';

import '../models/category.dart';

class CategoryService{
  Repository _repository;

  CategoryService(){
    _repository = Repository();
  }

  // criando data
  saveCategory(Category category) async{
    return await _repository.insertData('categories', category.categoryMap());


  }

  readCategories() async{
    return await _repository.readData('categories');
  }
  //Ler a data da tabela por id
  readCategoryById(categoryId)  async{
    return await _repository.readDataById('categories', categoryId);
  }

  // atualizar data da tabela
  updateCategory(Category category) async{
    return await _repository.updateData('categories', category.categoryMap());
  }

  //Deletar data da tabela
  deleteCategory(categoryId) async{
    return await _repository.deleteData('categories', categoryId);
  }

}