import 'dart:convert';
import 'package:http/http.dart' as http;

class Responce {
  final _apiKey = 'ENTER API KEY HERE';
  final _endpoint = 'https://api.openai.com/v1/chat/completions';

    Future<Map<String, dynamic>> sendMessageToChatGPT(message) async {

    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {'role': 'system', 'content': '''You are india based Agriculture specialist and only answers the questions about agriculture field.
          you should follow the instructions given below
          1.answer only agriculture questions else don't answer and politely ask to provide questions related to agriculture field.
          2.answer must be shorter in beetween 10 to 80 words and must be related to agriculture field.'''},
          {'role': 'user', 'content': message}
        ],
      },),
    );
    if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
    } else {
      throw Exception('Error occured!');
    }
  }


  Future<String> verifyBlogContent(message) async {

    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {'role': 'system', 'content': '''You are going to analyze the content provided by user in a following way :
          1.verify the content is related to agriculture field or not.
          2.if content is related to agriculture field then just provide one word "True" else provide "False".'''},
          {'role': 'user', 'content': message}
        ],
      },),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Error occured!');
    }
  }

}

