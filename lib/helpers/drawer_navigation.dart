import 'package:flutter/material.dart';
import 'package:todolist_app/screens/categories_screen.dart';
import 'package:todolist_app/screens/home.screens.dart';
import 'package:todolist_app/screens/todos_by_category.dart';
import 'package:todolist_app/services/category_service.dart';

class DrawerNavigation extends StatefulWidget {
  const DrawerNavigation({Key key}) : super(key: key);

  @override
  State<DrawerNavigation> createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  List<Widget> _categoryList = List<Widget>();

  CategoryService _categoryService = CategoryService();

  @override
  initState(){
    super.initState();
    getAllCategories();
  }

  getAllCategories() async {
    var categories = await _categoryService.readCategories();

    categories.forEach((category) {
      setState(() {
        _categoryList.add(InkWell(
          onTap: ()=>Navigator.push(context, new MaterialPageRoute
            (builder: (context) => new TodosByCategory(category: category['name'],))),
          child: ListTile(
            title: Text(category['name']),
          ),
        ));
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
            backgroundImage: NetworkImage(
                'https://yt3.ggpht.com/vVXiByofq9op4iMd0B_N1zDP0B4hke0kvG1yhq-agZWRBuBdiNyD4dWlSKJdoKL_ptcQx-yXHKo=s900-c-k-c0x00ffffff-no-rj'
        ),
        ),
                accountName: Text('Gian Vitor Dutra'),
                accountEmail: Text('giandutra@hotmail.com.br'),
                decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Inicio'),
              onTap: ()=>Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomeScreen())),
            ),
            ListTile(
            leading: Icon(Icons.view_list),
            title: Text('Categorias'),
              onTap: ()=>Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => CategoriesScreen())),

              ),
            Divider(),
            Column(
                children: _categoryList,
            ),
          ],
        ),
      ),
    );
  }
}
