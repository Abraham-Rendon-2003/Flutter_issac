import 'package:flutter/material.dart';
import 'api_service.dart';
import 'item_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter CRUD App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ApiService apiService = ApiService();
  List<Item> items = [];

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    try {
      final fetchedItems = await apiService.getItems();
      setState(() {
        items = fetchedItems;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> addItem(Item item) async {
    try {
      await apiService.createItem(item);
      fetchItems();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateItem(Item item) async {
    try {
      await apiService.updateItem(item);
      fetchItems();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteItem(String id) async {
    try {
      await apiService.deleteItem(id);
      fetchItems();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter CRUD App'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            title: Text(item.marca),
            subtitle: Text('${item.modelo} - ${item.tipo}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => deleteItem(item.id),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ItemForm(
                  item: item,
                  onSave: updateItem,
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemForm(
              onSave: addItem,
            ),
          ),
        ),
      ),
    );
  }
}

class ItemForm extends StatefulWidget {
  final Item? item;
  final Function(Item) onSave;

  ItemForm({this.item, required this.onSave});

  @override
  _ItemFormState createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  final _formKey = GlobalKey<FormState>();
  late String id;
  late String marca;
  late String modelo;
  late String tipo;
  late String material;

  @override
  void initState() {
    super.initState();
    id = widget.item?.id ?? '';
    marca = widget.item?.marca ?? '';
    modelo = widget.item?.modelo ?? '';
    tipo = widget.item?.tipo ?? '';
    material = widget.item?.material ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Agregar Item' : 'Editar Item'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Marca'),
                initialValue: marca,
                onChanged: (value) => marca = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la marca';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Modelo'),
                initialValue: modelo,
                onChanged: (value) => modelo = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el modelo';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Tipo'),
                initialValue: tipo,
                onChanged: (value) => tipo = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el tipo';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Material'),
                initialValue: material,
                onChanged: (value) => material = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el material';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final item = Item(
                      id: id.isEmpty ? DateTime.now().toString() : id,
                      marca: marca,
                      modelo: modelo,
                      tipo: tipo,
                      material: material,
                    );
                    widget.onSave(item);
                    Navigator.pop(context);
                  }
                },
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
