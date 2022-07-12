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
          appBar: AppBar(title: Text("AKBANK"), centerTitle: true),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .5,
                child: BlocBuilder<PriceBloc, PriceState>(builder: (context, state) {
                  if (state is PriceLoading) {
                    return const CircularProgressIndicator(
                      strokeWidth: 10,
                      color: Colors.red,
                    );
                  } else if (state is PriceLoaded) {
                    final List<GraphPoint>? data = state.price!.points![state.period];
                    print(data);
                    return LineChart(
                      LineChartData(
                        maxY: data!.map((price) => price.price).reduce((curr, nextTime) => curr! >= nextTime! ? curr : nextTime),
                        minY: data.map((price) => price.price).reduce((curr, nextTime) => curr! <= nextTime! ? curr : nextTime),
                        titlesData: FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        gridData: FlGridData(show: false),
                        backgroundColor: Colors.grey,
                        lineBarsData: [
                          LineChartBarData(
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
                    );
                  } else if (state is PriceError) {
                    return Text(state.errorMessage);
                  }
                  return Container();
                }),
              ),
              SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (final period in Period.values)
                      PeriodButton(
                          onTap: () {
                            context.read<PriceBloc>().add(ChangePeriodEvent(period));
                          },
                          title: period.toString()),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
