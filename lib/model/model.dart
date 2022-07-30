class PriceModel {
  final Map<Period, List<GraphPoint>>? points;
  final String? symbol;

  PriceModel({
    required this.points,
    required this.symbol,
  });
  //Map<Period, List<GraphPoint>>.from(json["1G"].map((e) => GraphPoint.fromJson(e))),
  factory PriceModel.fromJson(Map<String, dynamic> json) => PriceModel(
        points: {
          Period.oneDay: List<GraphPoint>.from(json["1G"].map((dynamic e) => GraphPoint.fromJson(e))),
          Period.oneWeek: List<GraphPoint>.from(json["1H"].map((dynamic e) => GraphPoint.fromJson(e))),
          Period.oneMonth: List<GraphPoint>.from(json["1A"].map((dynamic e) => GraphPoint.fromJson(e))),
          Period.threeMonth: List<GraphPoint>.from(json["3A"].map((dynamic e) => GraphPoint.fromJson(e))),
          Period.oneYear: List<GraphPoint>.from(json["1Y"].map((dynamic e) => GraphPoint.fromJson(e))),
          Period.fiveYear: List<GraphPoint>.from(json["5Y"].map((dynamic e) => GraphPoint.fromJson(e))),
        },
        symbol: json["symbol"],
      );
  Map<String, dynamic> toJson() => {
        "1G": points![Period.oneDay]!.map((dynamic e) => GraphPoint.fromJson(e)),
        "1H": points![Period.oneWeek]!.map((dynamic e) => GraphPoint.fromJson(e)),
        "1A": points![Period.oneMonth]!.map((dynamic e) => GraphPoint.fromJson(e)),
        "3A": points![Period.threeMonth]!.map((dynamic e) => GraphPoint.fromJson(e)),
        "1Y": points![Period.oneYear]!.map((dynamic e) => GraphPoint.fromJson(e)),
        "5Y": points![Period.fiveYear]!.map((dynamic e) => GraphPoint.fromJson(e)),
        "symbol": symbol,
      };
}

class GraphPoint {
  final double? price;
  final DateTime? dateTime;
  final int? v;
  final double? h;
  final double? l;

  GraphPoint({
    required this.price,
    required this.dateTime,
    required this.v,
    required this.h,
    required this.l,
  });

  factory GraphPoint.fromJson(Map<String, dynamic> json) => GraphPoint(
        price: json["c"].toDouble(),
        dateTime: DateTime.fromMillisecondsSinceEpoch(json["d"]),
        v: json["v"],
        h: json["h"].toDouble(),
        l: json["l"].toDouble(),
      );
  Map<String, dynamic> toJson() => {
        'c': price,
        'd': dateTime!.millisecondsSinceEpoch,
        'v': v,
        'h': h,
        'l': l,
      };
}

enum Period {
  oneDay,
  oneWeek,
  oneMonth,
  threeMonth,
  oneYear,
  fiveYear,
}

extension PeriodStyle on Period {
  String get getTitle {
    switch (this) {
      case Period.oneDay:
        return "1G";
      case Period.oneWeek:
        return "1H";
      case Period.oneMonth:
        return "1A";
      case Period.threeMonth:
        return "3A";
      case Period.oneYear:
        return "1Y";
      case Period.fiveYear:
        return "5Y";
    }
  }
}
