// ignore_for_file: unnecessary_null_comparison, prefer_if_null_operators, library_private_types_in_public_api

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:f14k/models/realtime.dart';

class RealtimePage extends StatefulWidget {
  const RealtimePage({super.key});

  @override
  _RealtimePageState createState() => _RealtimePageState();
}

class _RealtimePageState extends State<RealtimePage> {
  late Future<List<RealtimeData>> futureRealtimeData;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    futureRealtimeData = getRealtimeData();
  }

  Future<List<RealtimeData>> getRealtimeData() async {
  try {
    final dio = Dio();
    final response = await dio.get('https://api.openf1.org/v1/intervals');

    if (response.statusCode == 200) {
      return realtimeDataFromJson(json.encode(response.data!));
    } else {
      // Si la respuesta no es 200, lanzamos una excepción con el código de estado de la respuesta
      throw Exception('Failed to fetch realtime data: ${response.statusCode}');
    }
  } on DioException catch (e) {
    // Capturamos la excepción DioError
    // ignore: avoid_print
    print('Dio Error: ${e.response?.statusCode}');
    // Aquí puedes mostrar tu mensaje personalizado
    return Future.error('There is no race today');
  } catch (error) {
    // Cualquier otra excepción que no sea DioError
    throw Exception('Error fetching realtime data: $error');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFe40e18),
        leading: const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Image(
            image: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/3/33/F1.svg/2560px-F1.svg.png'),
          ),
        ),
        title: const Text('F1 Realtime', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: errorMessage.isEmpty
            ? FutureBuilder<List<RealtimeData>>(
                future: futureRealtimeData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)),
                    );
                  } else {
                    final List<RealtimeData> realtimeData = snapshot.data!;
                    if (realtimeData.isEmpty) {
                      return const Center(
                        child: Text(
                          'There is no race today',
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: realtimeData.length,
                      itemBuilder: (context, index) {
                        final RealtimeData data = realtimeData[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFe40e18),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              leading: Text(
                                '#${data.driverNumber}',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18),
                              ),
                              title: Text(
                                'Interval: ${data.interval != null ? data.interval : 'Race'}',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 13),
                              ),
                              trailing: Text(
                                'Gap to Leader: ${data.gapToLeader != null ? data.gapToLeader : 'Leader'}',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 13),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              )
            : Center(
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
      ),
    );
  }
}
