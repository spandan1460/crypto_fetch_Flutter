class Coin {
  String name;
  String symbol;
  String imgUrl;
  num price;
  num change;
  num changePer;

  Coin(
      {required this.name,
      required this.symbol,
      required this.imgUrl,
      required this.price,
      required this.change,
      required this.changePer});

  factory Coin.fromJSON(Map<String, dynamic> json) {
    return Coin(
        name: json['name'],
        symbol: json['symbol'],
        imgUrl: json['image'],
        price: json['current_price'],
        change: json['price_change_24h'],
        changePer: json['price_change_percentage_24h']);
  }
}

List<Coin> coinList = [];
