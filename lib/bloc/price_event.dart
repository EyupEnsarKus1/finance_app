import '../model/model.dart';

abstract class PriceEvent {}

class ChangePeriodEvent implements PriceEvent {
  final Period period;
  ChangePeriodEvent(this.period);
}
