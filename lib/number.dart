import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class PhoneNumberSearchPage extends StatefulWidget {
  @override
  _PhoneNumberSearchPageState createState() => _PhoneNumberSearchPageState();
}

class _PhoneNumberSearchPageState extends State<PhoneNumberSearchPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  List<String> _searchResults = [];

  Future<void> _searchPhoneNumber() async {
    const String token = '0a9d496bafc80662437a5c70eef9f7d1';
    final String phoneNumber = _phoneNumberController.text;

    try {
      final response = await Dio().get('http://htmlweb.ru/geo/api.php?json&telcod=$phoneNumber&api_key=$token');

      setState(() {
        _searchResults = response.data.toString().split('\n');
      });
    } catch (error) {
      if (error is DioError) {
        final errorMessage = error.response?.data['message'] ?? 'Unknown error occurred';
        setState(() {
          _searchResults = ['API Error: $errorMessage'];
        });
      } else {
        setState(() {
          _searchResults = ['Error: $error'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Phone Number Search',
        style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
          ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _searchPhoneNumber,
              child: Text('Search'),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final item = _searchResults[index];
                  final itemParts = item.split(':');
                  if (itemParts.length == 2) {
                    final itemTitle = itemParts[0].trim();
                    final itemValue = itemParts[1].trim();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          itemTitle,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(itemValue),
                        SizedBox(height: 8.0),
                      ],
                    );
                  } else {
                    return Text(item);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}