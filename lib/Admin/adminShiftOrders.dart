import 'package:flutter/material.dart';
import 'package:e_shop/Widgets/customAppBar.dart';




class AdminShiftOrders extends StatefulWidget {
  const AdminShiftOrders({Key key}) : super(key: key);

  @override
  _AdminShiftOrdersState createState() => _AdminShiftOrdersState();
}

class _AdminShiftOrdersState extends State<AdminShiftOrders> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: MyAppBar()
      )
    );
  }
}


