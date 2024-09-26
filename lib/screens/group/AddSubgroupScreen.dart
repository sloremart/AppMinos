import 'package:flutter/material.dart';
import 'package:minosapp/helpers/database_helper.dart';

class AddSubgroupScreen extends StatefulWidget {
  @override
  _AddSubgroupScreenState createState() => _AddSubgroupScreenState();
}

class _AddSubgroupScreenState extends State<AddSubgroupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';
  int? _selectedGroupId;
  List<Map<String, dynamic>> _groups = [];

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    var dbHelper = DatabaseHelper();
    var groupsData = await dbHelper.getGroups(); // Obtener los grupos desde la base de datos

    setState(() {
      _groups = groupsData;
    });
  }

  void _saveSubgroup() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var dbHelper = DatabaseHelper();

      // Llama al método para insertar el subgrupo en la base de datos
      int subgroupId = await dbHelper.insertSubgroup({
        'name': _name,
        'description': _description,
        'group_id': _selectedGroupId, // Asocia al grupo seleccionado
      });

      if (subgroupId > 0) {
        // Si el subgrupo se inserta correctamente, vuelve a la pantalla anterior
        Navigator.pop(context, true);
      } else {
        // Mostrar un mensaje de error si la inserción falla
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar el subgrupo')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Subgrupo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre del Subgrupo'),
                onSaved: (value) {
                  _name = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese el nombre del subgrupo';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Descripción del Subgrupo'),
                onSaved: (value) {
                  _description = value!;
                },
              ),
              DropdownButtonFormField<int>(
                value: _selectedGroupId,
                items: _groups.map((group) {
                  return DropdownMenuItem<int>(
                    value: group['id'],
                    child: Text(group['name']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGroupId = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Seleccionar Grupo'),
                validator: (value) {
                  if (value == null) {
                    return 'Por favor seleccione un grupo';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveSubgroup,
                child: Text('Guardar Subgrupo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
