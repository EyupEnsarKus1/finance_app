import 'package:finance_app/bloc/price_event.dart';
import 'package:finance_app/bloc/price_state.dart';
import 'package:finance_app/model/model.dart';
import 'package:finance_app/repository/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PriceBloc extends Bloc<PriceEvent, PriceState> {
  final Repository repo;
  PriceBloc(
    this.repo,
  ) : super(PriceIsNotLoaded(Period.oneMonth)) {
    on<ChangePeriodEvent>((event, emit) async {
      emit(PriceLoading(event.period));
      try {
        final data = await repo.getPriceData();
        if (data == null) {
          emit(PriceError("Veri Yok Data Null", event.period));
        }
        emit(PriceLoaded(data!, event.period));
      } catch (e) {
        emit(PriceError(e.toString(), event.period));
      }
    });
  }
}
