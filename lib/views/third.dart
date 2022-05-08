import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:weather_app/bloc/main_bloc.dart';
import 'package:weather_app/services/icon_service.dart';

class ThirdPage extends StatefulWidget {
  const ThirdPage({Key? key}) : super(key: key);

  @override
  State<ThirdPage> createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[300],
          title: const Text("FriFlex Weather App"),
          centerTitle: true,
        ),
        body: BlocConsumer<MainBloc, MainState>(listener: (context, state) {
          if (state is LoadError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.fromLTRB(15, 0, 15, (height / 2) - 20),
                content: const Text('Ошибка получения данных')));
          }
        }, builder: (context, state) {
          if (state is CityLoading) {
            return Center(child: SpinKitFadingCircle(
              itemBuilder: (BuildContext context, int index) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: index.isEven ? Colors.red : Colors.blue,
                  ),
                );
              },
            ));
          }
          if (state is ForecastLoaded) {
            return ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return ListTile(
                    tileColor:
                        index % 2 == 0 ? Colors.blue[100] : Colors.blue[200],
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            "Day: ".text.make(),
                            (state.forecast[index].temp!.day! - 273.15)
                                .toStringAsFixed(1)
                                .text
                                .make(),
                          ],
                        ),
                        Row(
                          children: [
                            "Night: ".text.make(),
                            (state.forecast[index].temp!.night! - 273.15)
                                .toStringAsFixed(1)
                                .text
                                .make(),
                          ],
                        ),
                      ],
                    ).wh(double.infinity, 75),
                    leading: IconService.getIcon(
                            state.forecast[index].weather![0].icon ?? '01d')
                        .wh(75, 75),
                    trailing: OverflowBar(
                      overflowAlignment: OverflowBarAlignment.center,
                      children: [
                        (state.forecast[index].weather![0].description)
                            .toString()
                            .text
                            .size(18)
                            .black
                            .make(),
                      ],
                    ).wh(75, 75),
                  );
                });
          } else {
            return 'Ошибка получения данных'
                .text
                .size(22)
                .bold
                .make()
                .centered();
          }
        }));
  }
}
