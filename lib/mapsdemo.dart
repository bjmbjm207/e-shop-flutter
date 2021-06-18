import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'ePage.dart';
import 'route.dart';


final List<EPage> _allPages = <EPage>[
  RoutePage(),
];

class MapsDemo extends StatelessWidget {
  void _pushPage(BuildContext context, page) async {
    final location = Location();
    final hasPermissions = await location.hasPermission();
    if (hasPermissions != PermissionStatus.granted) {
      await location.requestPermission();
    }

    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => Scaffold(body: page)));
  }

  @override
  Widget build(BuildContext context) {
    return RoutePage();
  }
}