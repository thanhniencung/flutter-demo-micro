import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Demo Micro"),
        ),
        body: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        UserInfo(),
        OrderList(),
      ],
    );
  }
}

class UserInfo extends StatelessWidget {
  Future<Response> getUserInfo() async {
    return await Dio().get("http://192.168.1.91:8000/user-service/user/info");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Response>(
        future: getUserInfo(),
        initialData: null,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              child: Container(
                  width: 50, height: 50, child: CircularProgressIndicator()),
            );
          }

          dynamic userData = snapshot.data.data;

          return Container(
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.all(10.0),
            decoration:
                BoxDecoration(border: Border.all(color: Colors.blueAccent)),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 20),
                  width: 90.0,
                  height: 90.0,
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new NetworkImage(userData['avatar']),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      userData['fullName'],
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      userData['email'],
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
}

class OrderList extends StatelessWidget {
  Future<Response> getOrderByUserId() async {
    return await Dio()
        .get("http://192.168.1.91:8000/order-service/order/list/1");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
      child: FutureBuilder<Response>(
          future: getOrderByUserId(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                child: Container(
                    width: 50, height: 50, child: CircularProgressIndicator()),
              );
            }

            dynamic orderData = snapshot.data.data;

            var user = orderData['user'];
            var order = orderData['items'];

            return ListView(
              shrinkWrap: true,
              children: <Widget>[
                Text(
                  user['fullName'],
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  height: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '#${order[0]['orderId']}',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        order[0]['price'].toString(),
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '#${order[1]['orderId']}',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        order[1]['price'].toString(),
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                )
              ],
            );
          }),
    );
  }
}
