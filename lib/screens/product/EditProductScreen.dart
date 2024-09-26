import 'package:flutter/material.dart';
import 'package:minosapp/helpers/database_helper.dart';
import 'package:minosapp/models/product.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  EditProductScreen({required this.product});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _code;
  late String _description;

  @override
  void initState() {
    super.initState();
    _name = widget.product.name;
    _code = widget.product.code;
    _description = widget.product.description;
  }

  void _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var dbHelper = DatabaseHelper();
      await dbHelper.updateProduct({
        'id': widget.product.id,
        'name': _name,
        'code': _code,
        'description': _description,
        'applies_iva': widget.product.appliesIva ? 1 : 0,
        'vat_percentage_id': widget.product.vatPercentageId,
        'unit_id': widget.product.unitId,
        'category_id': widget.product.categoryId,
        'subgroup_id': widget.product.subgroupId,
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Nombre del producto'),
                onSaved: (value) {
                  _name = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _code,
                decoration: InputDecoration(labelText: 'Código'),
                onSaved: (value) {
                  _code = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese un código';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Descripción'),
                onSaved: (value) {
                  _description = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese una descripción';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateProduct,
                child: Text('Actualizar Producto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
