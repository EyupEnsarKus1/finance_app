import '../model/model.dart';

abstract class PriceState {
  Period period;
  PriceState({required this.period});
}

class PriceIsNotLoaded implements PriceState {
  @override
  Period period;
  PriceIsNotLoaded(this.period);
}

class PriceLoading implements PriceState {
  @override
  Period period;
  PriceLoading(this.period);
}

class PriceLoaded implements PriceState {
  final PriceModel? price;
  @override
  Period period;
  PriceLoaded(this.price, this.period);
}

class PriceError implements PriceState {
  final String errorMessage;
  @override
  Period period;

  PriceError(this.errorMessage, this.period);
}
