import 'package:http/http.dart' as http;
class GlobalRepositories{


  Future<http.Response> downloadImage(String imageUrl)async{
    try{
      final response = await http.get(Uri.parse(imageUrl));
      if(response.statusCode==200){
        return response;
      }else{
        throw Exception("Failed to download image status: ${response.statusCode}");
      }
    }catch(e){
      throw Exception("Error during image download: $e");
    }
  }
}