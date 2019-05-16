import 'dart:convert';
import 'dart:io';
class Dog {
  /// Final is asignment const value
  final String name;
  final String location;
  final String description;
  String imageUrl;
  // All dogs start out at 10, because they're good dogs.
  int rating = 10;
  /// Constructor of class
  Dog(this.name, this.location, this.description);

  Future getImageUrl() async {
    // Null check so our app isn't doing extra word.
    // if there's already an image, we don't need to get one.
    if (imageUrl != null) {
      return;
    }
    // This is how http calls are done in flutter:
    HttpClient http = HttpClient();
    try {
      // Use darts Uri builder
      var uri = new Uri.http('dog.ceo', '/api/breeds/image/random');
      var request = await http.getUrl(uri);
      var response = await request.close();
      var responseBody = await response.transform(utf8.decoder).join();
      // the dog.ceo API returns a JSON object with a property
      // called 'message'. which actually is the URL.
      imageUrl = json.decode(responseBody)['message'];

    } catch (exception) {
      print(exception);
    }

  }

}
