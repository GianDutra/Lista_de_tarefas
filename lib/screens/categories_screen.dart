import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todolist_app/models/category.dart';
import 'package:todolist_app/screens/home.screens.dart';
import 'package:todolist_app/services/category_service.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  var _categoryNameController = TextEditingController();
  var _categoryDescriptionController = TextEditingController();

  var _category = Category();
  var _categoryService = CategoryService();

  List<Category> _categoryList = List<Category>();

  var category;

  var _editCategoryNameController = TextEditingController();
  var _editCategoryDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getAllCategiries();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  getAllCategiries() async {
    _categoryList = List<Category>();
    var categories = await _categoryService.readCategories();
    categories.forEach((category) {
      setState(() {
        var categoryModel = Category();
        categoryModel.name = category['name'];
        categoryModel.description = category['description'];
        categoryModel.id = category['id'];
        _categoryList.add(categoryModel);
      });
    });
  }


  _editCategory(BuildContext context, categoryId) async{
    category = await _categoryService.readCategoryById(categoryId);
    setState(() {
      _editCategoryNameController.text = category[0]['name']??'No Name';
      _editCategoryDescriptionController.text = 
          category[0]['description']??'No Description';
    });
    _editFormDialog(context);
    
  }

    _showFormDialog(BuildContext context) {
      return showDialog(
          context: context,
          barrierDismissible: true,
          builder: (param) {
            return AlertDialog(
          actions: <Widget>[
            FlatButton(onPressed: () {},
              color: Colors.red,
              child: Text('Cancelar'),
            ),
            FlatButton(
              color: Colors.blue,
              onPressed: () async {
                _category.name = _categoryNameController.text;
                _category.description = _categoryDescriptionController.text;


                var result = await _categoryService.saveCategory(_category);
                if (result > 0) {
                  print(result);
                  Navigator.pop(context);
                  getAllCategiries();
                }
              },
              child: Text('Salvar'),
            ),
          ],
          title: Text('Categories Form'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _categoryNameController,
                  decoration: InputDecoration(
                      hintText: 'Escreva a categoria',
                      labelText: 'Categoria'
                  ),
                ),
                TextField(
                  controller: _categoryDescriptionController,
                  decoration: InputDecoration(
                      hintText: 'Escreva a categoria',
                      labelText: 'Descrição'
                  ),
                )
              ],
            ),
          ),
        );
      });
    }

     _editFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(onPressed: () {},
                color: Colors.red,
                child: Text('Cancelar'),
              ),
              FlatButton(
                color: Colors.blue,
                onPressed: () async {
                  _category.id = category[0]['id'];
                  _category.name = _editCategoryNameController.text;
                  _category.description = _editCategoryDescriptionController.text;
                  var result = await _categoryService.updateCategory(_category);
                  if (result > 0) {
                    Navigator.pop(context);
                    getAllCategiries();
                    _showSuccesSnackBar(Text('Atualizado'));
                  }

                },
                child: Text('Editar'),
              ),
            ],
            title: Text('Categories Form'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _editCategoryNameController,
                    decoration: InputDecoration(
                        hintText: 'Escreva a categoria',
                        labelText: 'Categoria'
                    ),
                  ),
                  TextField(
                    controller: _editCategoryDescriptionController,
                    decoration: InputDecoration(
                        hintText: 'Escreva a categoria',
                        labelText: 'Descrição'
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }


     _deleteFormDialog(BuildContext context, categoryId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(onPressed: () {},
                color: Colors.green,
                child: Text('Cancelar'),
              ),
              FlatButton(
                color: Colors.red,
                onPressed: () async {
                  var result =
                  await _categoryService.deleteCategory(categoryId);
                  if (result > 0) {
                    Navigator.pop(context);
                    getAllCategiries();
                    _showSuccesSnackBar(Text('Deletado'));
                  }

                },
                child: Text('Deletar'),
              ),
            ],
            title: Text('Você tem certeza que quer deletar?'),

          );
        });
  }


  _showSuccesSnackBar(message){
    var _snackBar = SnackBar(content: message);
    _globalKey.currentState.showSnackBar(_snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        leading: RaisedButton(
          onPressed: () =>
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomeScreen())),
          elevation: 0.0,
          child: Icon(Icons.arrow_back, color: Colors.white,),
          color: Colors.blue,
        ),
        title: Text('Categories'),
      ),
      body: ListView.builder(
          itemCount: _categoryList.length, itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
          child: Card(
            elevation: 8.0,
            child: ListTile(
              leading: IconButton(icon: Icon(Icons.edit), onPressed: () {
                _editCategory(context, _categoryList[index].id);
              }),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(_categoryList[index].name),
                  IconButton(icon: Icon(Icons.delete, color: Colors.red,),
                      onPressed: () {
                        _deleteFormDialog(context, _categoryList[index].id);
                      })
                ],
              ),
              subtitle: Text(_categoryList[index].description),
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFormDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
