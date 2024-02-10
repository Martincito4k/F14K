// ignore_for_file: library_private_types_in_public_api, prefer_collection_literals

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:f14k/models/drivers.dart';

class DriversPage extends StatefulWidget {
  const DriversPage({super.key});

  @override
  _DriversPageState createState() => _DriversPageState();
}

class _DriversPageState extends State<DriversPage> {
  late Future<List<Driver>> _futureDrivers;

  @override
  void initState() {
    super.initState();
    _futureDrivers = getDrivers();
  }

  Future<List<Driver>> getDrivers() async {
  try {
    final dio = Dio();
    final response = await dio.get('https://api.openf1.org/v1/drivers');

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = response.data as List<dynamic>;

      // Filtrar objetos con headshot_url null
      final filteredData = jsonData.where((data) => data['headshot_url'] != null).toList();

      // Crear un conjunto para almacenar los driverNumber únicos
      final uniqueDriverNumbers = Set<int>();
      final List<Driver> drivers = [];

      for (final data in filteredData) {
        final driver = Driver.fromJson(data);
        if (!uniqueDriverNumbers.contains(driver.driverNumber)) {
          drivers.add(driver);
          uniqueDriverNumbers.add(driver.driverNumber);
        }
      }

      return drivers;
    } else {
      throw Exception('Failed to fetch drivers: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Error fetching drivers: $error');
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
        title: const Text('F1 Drivers', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder<List<Driver>>(
          future: _futureDrivers,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
            } else {
              final List<Driver> drivers = snapshot.data!;
              return ListView.builder(
                itemCount: drivers.length,
                itemBuilder: (context, index) {
                  final Driver driver = drivers[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF233f92),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        leading: Image.network(driver.headshotUrl),
                        title: Text(
                          '${driver.fullName} - ${driver.nameAcronym}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(
                          '${driver.countryCode} - ${driver.teamName}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: Text(
                          '#${driver.driverNumber}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
