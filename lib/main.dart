import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:networking/number.dart';
import 'package:networking/ipAddress.dart';
import 'package:networking/random_user.dart';

void main() {
  runApp(NetworkingApp());
}

class NetworkingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Networking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Dio _dio = Dio();
  List<Cryptocurrency> cryptocurrencies = [];
  bool _isLoading = false;
  bool _showInRubles = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      Response response = await _dio.get(
          'https://api.coingecko.com/api/v3/coins/markets?vs_currency=${_showInRubles ? 'rub' : 'usd'}&order=market_cap_desc&per_page=40&page=1');
      List<dynamic> data = response.data as List<dynamic>;

      setState(() {
        cryptocurrencies = data
            .map((item) => Cryptocurrency(
                  name: item['name'],
                  image: item['image'],
                  price: item['current_price'].toString(),
                ))
            .toList();
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        cryptocurrencies = [];
        _isLoading = false;
      });
    }
  }

  void toggleCurrency() {
    setState(() {
      _showInRubles = !_showInRubles;
    });
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cryptocurrency Prices',
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 226, 232, 236),
              ),
              child: Text(
                'Выбор приложений',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Криптовалюты'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NetworkingApp()),
                );
              },
            ),
            ListTile(
              title: const Text('Информация об IP-адресе'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => IpAddress()),
                );
              },
            ),
            ListTile(
              title: const Text('Случайный пользователь'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserPage()),
                );
              },
            ),
            ListTile(
              title: const Text('Номер телефона'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PhoneNumberSearchPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: cryptocurrencies.length,
                      separatorBuilder: (context, index) => const Divider(
                        color: Colors.grey,
                        height: 1,
                      ),
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Image.network(cryptocurrencies[index].image),
                          title: Text(cryptocurrencies[index].name),
                          subtitle: Text(
                              'Price: ${_showInRubles ? '₽' : '\$'}${cryptocurrencies[index].price}'),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: toggleCurrency,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                      textStyle: const TextStyle(fontSize: 16.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                        _showInRubles
                        ? 'Показать в долларах'
                        : 'Показать в рублях'),
                  ),
                ],
              ),
      ),
    );
  }
}

class Cryptocurrency {
  final String name;
  final String image;
  final String price;

  Cryptocurrency({
    required this.name,
    required this.image,
    required this.price,
  });
}
