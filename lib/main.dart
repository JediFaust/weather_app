import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/config.dart';
import 'package:weather_app/views/first.dart';
import 'package:weather_app/views/second.dart';
import 'package:weather_app/views/third.dart';

import 'bloc/main_bloc.dart';

/*

I am using VelocityX to make the code look more clean and readable.
All the widgets are defined in the views folder.
For network calls, I am using Dio, requests stored in the services folder.

For requests I am using api_status.dart to check the status of the request.
All data is stored in the models folder.
*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          // Loading default city as London
          create: (context) => MainBloc()..add(const LoadCity(city: 'London')),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: Colors.white70),
          textTheme: const TextTheme(
            bodyText2: TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
            bodyText1: TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          'first': (context) => const FirstPage(),
          'second': (context) => const SecondPage(title: appName),
          'third': (context) => const ThirdPage(),
        },
        title: appName,
        home: const FirstPage(),
      ),
    );
  }
}
