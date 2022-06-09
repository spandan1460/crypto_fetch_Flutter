import 'dart:async';
import 'dart:convert';

import 'package:crypto_fetch/coin_card.dart';
import 'package:crypto_fetch/coin_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<Coin>> fetchCoin() async {
    coinList = [];
    final response = await http.get(Uri.parse(
        "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false"));

    // print("Response from API: $response");

    if (response.statusCode == 200) {
      List<dynamic> values = [];
      values = json.decode(response.body);
      print("JSON reponse $values");
      if (values.length > 0) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            coinList.add(Coin.fromJSON(map));
          }
        }
        setState(() {
          coinList;
        });
      } else {
        throw Exception('Failed to load the API data.');
      }
    }
    return coinList;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCoin();
    Timer.periodic(Duration(seconds: 2), ((timer) => fetchCoin()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Crypto Information System',
          style: TextStyle(color: Colors.grey[800]),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[300],
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: coinList.length,
        itemBuilder: (context, index) {
          return CoinCard(
              name: coinList[index].name,
              symbol: coinList[index].symbol,
              imgUrl: coinList[index].imgUrl,
              price: coinList[index].price,
              change: coinList[index].change,
              changePer: coinList[index].changePer.toDouble());
        },
      ),
    );
  }
}
