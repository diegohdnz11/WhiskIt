import 'dart:convert';
import 'package:http/http.dart' as http;

class RecipeApi{
   static const baseUrl = "https://www.themealdb.com/api/json/v1/1";

  Future<Map<String, dynamic>> search(String x) async{
    final url = "$baseUrl/search.php?s=$x";
    final response = await http.get(Uri.parse(url));
    return json.decode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> lookup(String id) async {
    final url = "$baseUrl/lookup.php?i=$id";
    final response = await http.get(Uri.parse(url));
    return json.decode(response.body) as Map<String, dynamic>;
  }


}
