import 'package:flutter/material.dart';
import 'package:minosapp/helpers/database_helper.dart';

class AddGroupScreen extends StatefulWidget {
  @override
  _AddGroupScreenState createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends State<AddGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';

  void _saveGroup() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var dbHelper = DatabaseHelper();
      
      // Llama al método para insertar el grupo en la base de datos
      int groupId = await dbHelper.insertGroup({
        'name': _name,
        'description': _description,
      });

      if (groupId > 0) {
        // Si el grupo se inserta correctamente, vuelve a la pantalla anterior
        Navigator.pop(context, true);
      } else {
        // Mostrar un mensaje de error si la inserción falla
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar el grupo')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Grupo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre del Grupo'),
                onSaved: (value) {
                  _name = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese el nombre del grupo';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Descripción del Grupo'),
                onSaved: (value) {
                  _description = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveGroup,
                child: Text('Guardar Grupo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
