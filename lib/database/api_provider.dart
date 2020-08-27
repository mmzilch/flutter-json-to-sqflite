import 'package:dio/dio.dart';
import 'package:flutter_healthy_fitness/database/database_helper.dart';
import 'package:flutter_healthy_fitness/model/foods_model.dart';

class ApiProvider {
  Future<List<Foods>> getAllFoods() async {
    var url = "https://healthfitness.khaingthinkyi.me/api/food";
    Response response = await Dio().get(url);
    print('responsedata>>>>'+response.data.toString());

    return (response.data as List).map((f) {
      print('Inserting $Foods');
      DatabaseHelper.instance.createFood(Foods.fromJson(f));
    }).toList();
  }
}