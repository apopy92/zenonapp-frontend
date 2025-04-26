import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../features/galpon/presentation/galpon_controller.dart';
import '../features/produccion/presentation/produccion_controller.dart';

class ProduccionPage extends StatefulWidget {
  const ProduccionPage({super.key});

  @override
  State<ProduccionPage> createState() => _ProduccionPageState();
}

class _ProduccionPageState extends State<ProduccionPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cantidadController = TextEditingController();

  DateTime _fechaSeleccionada = DateTime.now();
  String _tipoHuevo = 'Comercial';

  Future<void> _guardarProduccion() async {
    final produccionController =
        Provider.of<ProduccionController>(context, listen: false);

    final cantidadTexto = _cantidadController.text.trim();
    final cantidad = int.tryParse(cantidadTexto);

    if (!_formKey.currentState!.validate() || cantidad == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Ingrese un número válido')),
      );
      return;
    }

    await produccionController.guardarProduccion(
      context: context,
      cantidad: cantidad,
      tipo: _tipoHuevo,
      fecha: _fechaSeleccionada,
    );
  }

  Future<void> _seleccionarFecha() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _fechaSeleccionada = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final galponController = Provider.of<GalponController>(context);
    final galpon = galponController.galponSeleccionado;
    final produccionController = Provider.of<ProduccionController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Producción')),
      body: galpon == null
          ? const Center(child: Text('⚠️ No hay galpón seleccionado'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Text("Galpón seleccionado: ${galpon.nombre}",
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 16),
                    Text(
                      "Fecha: ${_fechaSeleccionada.toLocal().toString().split(' ')[0]}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _seleccionarFecha,
                      child: const Text('Seleccionar Fecha'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _cantidadController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: 'Cantidad de Huevos',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese una cantidad';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Ingrese un número válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _tipoHuevo,
                      items: ['Comercial', 'Incubable', 'Roto']
                          .map((tipo) => DropdownMenuItem(
                                value: tipo,
                                child: Text(tipo),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _tipoHuevo = value!;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Tipo de Huevo',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: produccionController.isLoading
                            ? null
                            : _guardarProduccion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                        ),
                        child: produccionController.isLoading
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : const Text('Guardar',
                                style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
