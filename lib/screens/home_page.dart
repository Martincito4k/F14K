// ignore_for_file: prefer_interpolation_to_compose_strings
import 'package:dio/dio.dart';
import 'package:f14k/models/grandprix.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<List<GrandPrix>> getRaces() async {
    try {
      final dio = Dio();
      final response = await dio.get('https://api.openf1.org/v1/sessions');
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.data;

        final Map<int, Set<String>> uniqueSessions = {};

        // Iteramos sobre los datos recibidos y almacenamos solo las entradas únicas basadas en 'circuit_key' y 'session_name'
        for (final data in jsonData) {
          final int circuitKey = data['circuit_key'];
          final String sessionName = data['session_name'];
          
          if (!uniqueSessions.containsKey(circuitKey)) {
            uniqueSessions[circuitKey] = {sessionName};
          } else {
            uniqueSessions[circuitKey]?.add(sessionName);
          }
        }

        // Convertimos los datos únicos de nuevo a una lista de mapas
        final List<Map<String, dynamic>> uniqueRaces = [];
        uniqueSessions.forEach((circuitKey, sessions) {
          for (var sessionName in sessions) {
            final sessionData = jsonData.firstWhere((data) => data['circuit_key'] == circuitKey && data['session_name'] == sessionName);
            uniqueRaces.add(sessionData);
          }
        });

        // Ahora puedes procesar 'uniqueRaces' como lo hacías con 'races' anteriormente
        final races = List<GrandPrix>.from(uniqueRaces.map((data) => GrandPrix.fromJson(data)));

        return races;
      } else {
        throw Exception('Failed to fetch races: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching races: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFe40e18),
        // ignore: prefer_const_constructors
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: const Image(image: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/3/33/F1.svg/2560px-F1.svg.png'),),
        ),
        title: FutureBuilder(
          future: getRaces(),
          builder: (context, AsyncSnapshot<List<GrandPrix>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('F1 Season', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400));
            } else if (snapshot.hasError) {
              return const Text('Error', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400));
            } else {
              // Obtener el año de la primera carrera
              final int year = snapshot.data![0].dateStart.year;
              return Text('F1 Season $year', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500,));
            }
          },
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: getRaces(),
          builder: (context, AsyncSnapshot<List<GrandPrix>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
              final races = snapshot.data;
              return ListView.builder(
                itemCount: races!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFe40e18),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        leading: Text(
                          DateFormat('dd/MM').format(races[index].dateStart),
                          style: const TextStyle(color: Colors.white),
                        ),
                        title: Text(
                          races[index].countryName + ' GP ',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(
                          races[index].circuitShortName + ' - ' + races[index].location,
                          style: const TextStyle(color: Colors.white,),
                        ),
                        trailing: Text(
                          races[index].sessionName,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
