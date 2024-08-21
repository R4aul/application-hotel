import 'package:flutter/material.dart';

//RUTAS DE AUTHENTICACION
import 'package:application_hotel/screens/login_screen.dart';
import 'package:application_hotel/screens/register_screen.dart';

import 'package:application_hotel/screens/reservas/home_reservas.dart';
import 'package:application_hotel/screens/reservas/reservas_add_screen.dart';
import 'package:application_hotel/screens/reservas/reservas_edit_screen.dart';

class Routes {

  static const String login = '/login';
  static const String register = '/register'; 

  static const String homeReservas = '/homeReservas';
  static const String reservasAdd = '/reservasAdd';
  static const String reservasEdit = '/reservasEdit';

  static Route<dynamic> generateRoute(RouteSettings settings){
    switch (settings.name){
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case homeReservas:
        return MaterialPageRoute(builder: (_) => HomeReservas());
      case reservasAdd:
        return MaterialPageRoute(builder: (_) => ReservasAddScreen());
      case reservasEdit:
        final reservation = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ReservasEditScreen(reservation: reservation),
        );
      default:
        return MaterialPageRoute(builder: (_) => LoginScreen());
    }
  }  
}