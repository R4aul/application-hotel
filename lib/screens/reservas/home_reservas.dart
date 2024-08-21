import 'package:flutter/material.dart';
import 'package:application_hotel/services/reservas_services.dart';
import 'package:application_hotel/utils/navigation.dart';
import 'package:application_hotel/utils/routes.dart';

class HomeReservas extends StatefulWidget {
  @override
  State<HomeReservas> createState() => _HomeReservasState();
}

class _HomeReservasState extends State<HomeReservas> {
  Future<void> _signOut() async {
    //await FirebaseAuth.instance.signOut();
    Navigation.navigateTo(Routes.login); // Redirige a la pantalla de inicio de sesión
  }
  Future<void> _deleteReservation(String uid) async {
    try {
      await deleteReservation(uid);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reserva eliminada exitosamente')),
      );
      setState(() {}); // Refresca la pantalla
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar la reserva: $e')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservas'),
        automaticallyImplyLeading: false, //para desactivar la felcha de retorceso
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _signOut();
            },
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: FutureBuilder<List>(
        future: getReservations(), // Llama a la función que obtiene las reservas
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Muestra un indicador de carga mientras esperas la respuesta
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Muestra un mensaje de error si hay un problema con la carga de datos
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Muestra un mensaje si no hay datos disponibles
            return Center(child: Text('No hay reservas disponibles'));
          } else {
            // Muestra la lista de reservas si los datos se cargan correctamente
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var reservation = snapshot.data![index];
                var uid = reservation['uid']; // Ahora tienes acceso al UID
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(reservation['title'] ?? 'Sin título'),
                    subtitle: Text(reservation['notes'] ?? 'Sin descripción'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Navegar a la pantalla de edición
                            Navigation.navigateTo(Routes.reservasEdit, arguments: reservation);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                          await _deleteReservation(uid);
                          },
                        ),
                      ],
                    ),
                    // Añade más detalles según las propiedades de tus objetos de reserva
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar a la pantalla de creación de reserva
          Navigation.navigateTo(Routes.reservasAdd);
        },
        child: Icon(Icons.add),
        tooltip: 'Crear nueva reserva',
      ),
    );
  }
}
