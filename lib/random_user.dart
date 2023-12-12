import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late User _user = User(
    firstName: '',
    lastName: '',
    email: '',
    username: '',
    picture: '',
    city: '', 
    address: '', 
    phoneNumber: '', 
    password: '',
  ); // Инициализация в объявлении
  bool _isLoading = false;
  bool _isUserGenerated = false;

  Future<void> _fetchRandomUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await Dio().get('https://randomuser.me/api/');
      final results = response.data['results'];
      final user = results[0];

      setState(() {
        _user = User(
          firstName: user['name']['first'],
          lastName: user['name']['last'],
          email: user['email'],
          username: user['login']['username'],
          picture: user['picture']['large'],
          city: user['location']['city'],
          address: user['location']['street']['name'],
          phoneNumber: user['phone'],
          password: user['login']['password'],
        );
        _isLoading = false;
        _isUserGenerated = true;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Random User Generator',
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : !_isUserGenerated // Использование _isUserGenerated для проверки
                ? const Text(
                    'Нажмите кнопку, чтобы сгенерировать случайного пользователя.',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 80,
                        backgroundImage: NetworkImage(_user.picture),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${_user.firstName} ${_user.lastName}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                     const SizedBox(height: 8),
                    Text('Username: ${_user.username}', style: const TextStyle(fontSize: 18),),
                    const SizedBox(height: 8),
                    Text('City: ${_user.city}', style: const TextStyle(fontSize: 18),),
                    const SizedBox(height: 8),
                    Text('Address: ${_user.address}', style: const TextStyle(fontSize: 18),),
                    const SizedBox(height: 8),
                    Text('Email: ${_user.email}', style: const TextStyle(fontSize: 18),),
                    const SizedBox(height: 8),
                    Text('Phone Number: ${_user.phoneNumber}', style: const TextStyle(fontSize: 18),),
                    const SizedBox(height: 8),
                    Text('Password: ${_user.password}', style: const TextStyle(fontSize: 18),),
                    ],
                  ),
      ),
      floatingActionButton: TextButton(
        onPressed: _fetchRandomUser,
        child: const Icon(
          Icons.refresh,
          size: 35,
          color: Colors.black,
        ),
      ),
    );
  }
}

class User {
  final String firstName;
  final String lastName;
  final String email;
  final String username;
  final String picture;
  final String city;
  final String address;
  final String phoneNumber;
  final String password;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    required this.picture,
    required this.city,
    required this.address,
    required this.phoneNumber,
    required this.password,
  });
}
