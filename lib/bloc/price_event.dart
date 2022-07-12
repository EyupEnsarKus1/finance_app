import '../model/model.dart';

abstract class PriceEvent {}

class FetchPriceEvent implements PriceEvent {
  final Period period;
  FetchPriceEvent(this.period);
}

class ChangePeriodEvent implements PriceEvent {
  final Period period;
  ChangePeriodEvent(this.period);
}
