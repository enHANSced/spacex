import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String urilaunches = 'https://api.spacexdata.com/v5/launches';

  //final String uriRockets = 'https://api.spacexdata.com/v4/rockets';

  List data = [];

  //guarda el id del cohete
  //List data2 = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future fetchData() async {
    final response = await http.get(Uri.parse(urilaunches));
    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body);
      });
    }
  }

  //formatea la fecha para que sea mas legible
  String convertirFecha(String date) {
    DateTime dateTime = DateTime.parse(date);
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SpaceX: Lanzamientos'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              elevation: 5.0,
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10.0),
                    Center(
                      child: Image.network(data[index]['links']['patch']
                              ['small'], width: 200,),
                    ),
                    const SizedBox(height: 10.0),
                    ListTile(
                      title: Text(data[index]['name'],
                          style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                      subtitle: Text(
                          'Fecha: ${convertirFecha(data[index]['date_utc'])}',
                          style: const TextStyle(fontSize: 15.0)),
                      trailing: Text(
                          data[index]['success'] ? 'Exitoso' : 'Fallido',
                          style: TextStyle(
                              fontSize: 15.0,
                              color: (data[index]['success']
                                  ? Colors.green
                                  : Colors.red))),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
