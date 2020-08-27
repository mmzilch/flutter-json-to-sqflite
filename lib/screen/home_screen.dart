import 'package:flutter/material.dart';
import 'package:flutter_healthy_fitness/database/api_provider.dart';
import 'package:flutter_healthy_fitness/database/database_helper.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Healthy Fitness'),
          centerTitle: true,
          actions: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: Icon(Icons.settings_input_antenna),
                onPressed: () async {
                  await _loadFromApi();
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  await _deleteData();
                },
              ),
            ),
          ],
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _buildFoodListView());
  }

  _loadFromApi() async {
    setState(() {
      _isLoading = true;
    });

    var apiProvider = ApiProvider();
    await apiProvider.getAllFoods();

    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoading = false;
    });
  }

  _deleteData() async {
    setState(() {
      _isLoading = true;
    });

    await DatabaseHelper.instance.deleteAllFood();
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isLoading = false;
    });
    print('All food are deleted');
  }

  _buildFoodListView() {
    return FutureBuilder(
      future: DatabaseHelper.instance.getAllFoodfromDb(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: Colors.black12,
            ),
            itemCount: snapshot.data.length == 0 ? 0 : snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Text(
                  "${index + 1}",
                  style: TextStyle(fontSize: 20.0),
                ),
                title: Text("Name: ${snapshot.data[index].name}"),
                subtitle: Text('Category: ${snapshot.data[index].category}'),
              );
            },
          );
        }
      },
    );
  }
}
