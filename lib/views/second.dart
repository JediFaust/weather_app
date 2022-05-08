import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:weather_app/bloc/main_bloc.dart';
import 'package:weather_app/services/icon_service.dart';
import 'package:weather_app/utils/capitalize_extension.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  int currentTab = 0;
  // Default latitude and longitude
  // in case we get wrong data from the API
  double latitude = 51.5073219;
  double longitude = -0.1276474;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: const [0, 0.5, 1],
          colors: [
            Colors.blue[300] as Color,
            Colors.blue[400] as Color,
            Colors.blue[500] as Color,
          ],
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[600],
          title: Text(widget.title),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('first');
              },
              icon: const Icon(Icons.location_city)),
          actions: [
            IconButton(
              onPressed: () {
                context
                    .read<MainBloc>()
                    .add(LoadForecast(lat: latitude, lon: longitude));
                Navigator.of(context).pushNamed('third');
              },
              icon: const Icon(Icons.list_alt_outlined),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        body: BlocConsumer<MainBloc, MainState>(
          listener: (context, state) {
            if (state is LoadError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.fromLTRB(15, 0, 15, (height / 2) - 20),
                  content: const Text('Ошибка получения данных')));
            }
          },
          builder: (context, state) {
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
            if (state is CityLoaded) {
              var weather = state.city;

              latitude = weather!.coord!.lat ?? 51.5073219;
              longitude = weather.coord!.lon ?? -0.1276474;
              String cityTitle = weather.name ?? "City";
              String temperature =
                  ((weather.main!.temp! - 273.15).toInt()).toString();
              String humidity = (weather.main!.humidity!).toString();
              String windSpeed = ((weather.wind!.speed!)).toString();
              String description =
                  weather.weather![0].description!.capitalize();

              DateTime now = DateTime.now();
              String formattedDate = DateFormat('dd MMMM y').format(now);
              String formattedDayNTime = DateFormat('EEEE | kk:mm').format(now);

              return Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: 100,
                            height: 100,
                            child: IconService.getIcon(
                                weather.weather![0].icon ?? '01d')),
                        Text(cityTitle),
                        //IconButton(onPressed: () {}, icon: const Icon(Icons.location_on))
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(temperature,
                                style: const TextStyle(fontSize: 150)),
                            const Text('o', style: TextStyle(fontSize: 50)),
                          ],
                        ),
                        Text(description),
                        20.heightBox,
                        "Влажность: $humidity".text.make(),
                        20.heightBox,
                        "Скорость ветра: $windSpeed".text.make(),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formattedDate,
                          style: const TextStyle(fontSize: 24),
                        ),
                        Text(
                          formattedDayNTime,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ],
                    )
                  ],
                ),
              );
            } else {
              return 'Ошибка получения данных'
                  .text
                  .size(22)
                  .bold
                  .make()
                  .centered();
            }
          },
        ),
      ),
    );
  }
}
