import 'package:finance_app/bloc/price_bloc.dart';
import 'package:finance_app/bloc/price_event.dart';
import 'package:finance_app/bloc/price_state.dart';
import 'package:finance_app/model/model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'repository/repository.dart';

class StockPage extends StatelessWidget {
  const StockPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Repository priceService = Repository();

    return BlocProvider<PriceBloc>(
      create: (context) => PriceBloc(priceService),
      child: Builder(builder: (context) {
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<PriceBloc, PriceState>(builder: (context, state) {
                if (state is PriceLoading) {
                  return const Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      color: Colors.greenAccent,
                    ),
                  );
                } else if (state is PriceLoaded) {
                  final List<GraphPoint>? data = state.price!.points![state.period];
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * .5,
                    child: Center(
                      child: LineChart(
                        LineChartData(
                          maxY: data!.map((price) => price.price).reduce((curr, nextTime) => curr! >= nextTime! ? curr : nextTime),
                          minY: data.map((price) => price.price).reduce((curr, nextTime) => curr! <= nextTime! ? curr : nextTime),
                          titlesData: FlTitlesData(
                            show: false,
                          ),
                          borderData: FlBorderData(show: false),
                          gridData: FlGridData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              isCurved: true,
                              barWidth: 2.0,
                              dotData: FlDotData(show: false),
                              color: Colors.greenAccent,
                              spots: data
                                  .map(
                                    (e) => FlSpot(
                                      double.parse(e.dateTime!.millisecondsSinceEpoch.toString()),
                                      double.parse(e.price!.toStringAsFixed(2)),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else if (state is PriceError) {
                  return Text(state.errorMessage);
                }
                return Container();
              }),
              const SizedBox(
                height: 20,
              ),
              const PeriodButtonsWidget(),
            ],
          ),
        );
      }),
    );
  }
}

class PeriodButtonsWidget extends StatelessWidget {
  const PeriodButtonsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (final period in Period.values)
            PeriodButton(
                onTap: () {
                  context.read<PriceBloc>().add(ChangePeriodEvent(period));
                },
                title: period.getTitle),
        ],
      ),
    );
  }
}

class PeriodButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;

  const PeriodButton({Key? key, required this.onTap, required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: const BoxDecoration(
          color: Colors.blueGrey,
        ),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
    );
  }
}
