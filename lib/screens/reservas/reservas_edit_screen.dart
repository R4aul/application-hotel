import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:application_hotel/services/reservas_services.dart';
import 'package:application_hotel/utils/navigation.dart';
import 'package:application_hotel/utils/routes.dart';

class ReservasEditScreen extends StatefulWidget {
  final Map<String, dynamic> reservation;

  ReservasEditScreen({required this.reservation});

  @override
  State<ReservasEditScreen> createState() => _ReservasEditScreenState();
}

class _ReservasEditScreenState extends State<ReservasEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _notesController;
  late TextEditingController _titleController;
  late TextEditingController _totalAmountController;
  late DateTime _startDate;

  Future<void> _signOut() async {
    //await FirebaseAuth.instance.signOut();
    Navigation.navigateTo(Routes.login); // Redirige a la pantalla de inicio de sesión
  }

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.reservation['notes']);
    _titleController = TextEditingController(text: widget.reservation['title']);
    _totalAmountController = TextEditingController(text: widget.reservation['total_amount'].toString());
    _startDate = (widget.reservation['start_date'] as Timestamp).toDate();
  }

  Future<void> _updateReservation(String id) async {
    if (_formKey.currentState!.validate()) {
      await updateReservation(
        id,  // Pasar el id del documento
        _titleController.text,
        _notesController.text,
        _startDate,
        int.parse(_totalAmountController.text),
      );
      Navigation.navigateTo(Routes.homeReservas); // Regresa a la pantalla anterior después de la edición
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Reserva'),
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un título';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(labelText: 'Notas'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una nota';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _totalAmountController,
                decoration: InputDecoration(labelText: 'Cantidad Total'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa la cantidad total';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _updateReservation(widget.reservation['uid']),
                child: Text('Guardar Cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
