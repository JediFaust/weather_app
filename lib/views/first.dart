import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:weather_app/bloc/main_bloc.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final _cityController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        title: const Text("FriFlex Weather App"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          "Enter city name: ".text.bold.blue400.make(),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter a city",
              ),
              onSubmitted: (data) {
                if (data.isEmpty) {
                  data = "London";
                }
                // We adding event with given city name
                context.read<MainBloc>().add(LoadCity(city: data.trim()));
                Navigator.of(context).pushNamed('second');
              },
            ),
          ),
          10.widthBox,
        ],
      ),
    );
  }
}
