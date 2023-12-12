import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


class IpAddress extends StatefulWidget {
  @override
  _IpAddressState createState() => _IpAddressState();
}

class _IpAddressState extends State<IpAddress> {
  String ipAddress = '';
  String ip = '';
  String city = '';
  String region = '';
  String country = '';
  String loc = '';
  String org = '';
  String postal = '';
  String timezone = '';
  TextEditingController ipController = TextEditingController();

  final dio = Dio();
  bool _showList = false;
  bool _isLoading = false;

  Future<void> fetchIpAddress() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await dio.get('https://api.ipify.org?format=json');
      final data = response.data as Map<String, dynamic>;
      setState(() {
        ipAddress = data['ip'];
        _isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> fetchSearchIpAddress() async {
    final String searchip = ipController.text;

    setState(() {
      _isLoading = true;
    });
    try {
      final response = await dio.get('https://ipinfo.io/$searchip/geo');
      final data = response.data as Map<String, dynamic>;
      setState(() {
        ip = data['ip'];
        city = data['city'];
        region = data['region'];
        country = data['country'];
        loc = data['loc'];
        org = data['org'];
        postal = data['postal'];
        timezone = data['timezone'];
        _isLoading = false;
        _showList = true;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IP address information',
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
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: fetchIpAddress,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                      textStyle: const TextStyle(fontSize: 16.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('Узнать свой IP адрес'),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Ваш IP адрес:',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    ipAddress,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: TextField(
                      style: const TextStyle(fontSize: 20),
                      controller: ipController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Введите IP адрес',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: fetchSearchIpAddress,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                      textStyle: const TextStyle(fontSize: 16.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('Получить информацию об IP адресе'),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Информация об IP адресе:',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  if (_showList)
                    Expanded(
                      child: ListView(
                        children: [
                          ListTile(
                            title: const Text('IP адрес'),
                            subtitle: Text(ip),
                          ),
                          ListTile(
                            title: const Text('Город'),
                            subtitle: Text(city),
                          ),
                          ListTile(
                            title: const Text('Регион'),
                            subtitle: Text(region),
                          ),
                          ListTile(
                            title: const Text('Страна'),
                            subtitle: Text(country),
                          ),
                          ListTile(
                            title: const Text('Координаты'),
                            subtitle: Text(loc),
                          ),
                          ListTile(
                            title: const Text('Организация'),
                            subtitle: Text(org),
                          ),
                          ListTile(
                            title: const Text('Почтовый индекс'),
                            subtitle: Text(postal),
                          ),
                          ListTile(
                            title: const Text('Временная зона'),
                            subtitle: Text(timezone),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}