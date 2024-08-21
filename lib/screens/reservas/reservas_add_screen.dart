import 'package:flutter/material.dart';
import 'package:application_hotel/services/reservas_services.dart';
import 'package:application_hotel/utils/navigation.dart';
import 'package:application_hotel/utils/routes.dart';

class ReservasAddScreen extends StatefulWidget {
  @override
  State<ReservasAddScreen> createState() => _ReservasAddScreenState();
}

class _ReservasAddScreenState extends State<ReservasAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  final _titleController = TextEditingController();
  final _totalAmountController = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _signOut() async {
    //await FirebaseAuth.instance.signOut();
    Navigation.navigateTo(Routes.login); // Redirige a la pantalla de inicio de sesión
  }

  Future<void> _saveReservation() async {
    if (_formKey.currentState!.validate()) {
      try {
        await readReservation(
          _notesController.text,
          _selectedDate!,
          _titleController.text,
          int.parse(_totalAmountController.text),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reserva creada exitosamente')),
        );
        Navigation.navigateTo(Routes.homeReservas); // Vuelve a la pantalla anterior
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear la reserva: $e')),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Reserva'),
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
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(labelText: 'Notas'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa notas';
                  }
                  return null;
                },
              ),
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
                controller: _totalAmountController,
                decoration: InputDecoration(labelText: 'Monto Total'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un monto total';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor ingresa un número válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'Selecciona la fecha de inicio'
                          : 'Fecha de inicio: ${_selectedDate!.toLocal()}',
                    ),
                  ),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Seleccionar Fecha'),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _saveReservation,
                child: Text('Guardar Reserva'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
