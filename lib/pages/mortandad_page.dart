import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../features/galpon/presentation/galpon_controller.dart';
import '../features/mortandad/presentation/mortandad_controller.dart';

class MortandadPage extends StatefulWidget {
  const MortandadPage({super.key});

  @override
  State<MortandadPage> createState() => _MortandadPageState();
}

class _MortandadPageState extends State<MortandadPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _causaController = TextEditingController();
  DateTime _fechaSeleccionada = DateTime.now();

  Future<void> _guardarMortandad() async {
    final mortandadController =
        Provider.of<MortandadController>(context, listen: false);

    final cantidadTexto = _cantidadController.text.trim();
    final cantidad = int.tryParse(cantidadTexto);

    if (!_formKey.currentState!.validate() || cantidad == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Ingrese un número válido')),
      );
      return;
    }

    await mortandadController.guardarMortandad(
      context: context,
      cantidad: cantidad,
      causa: _causaController.text.trim(),
      fecha: _fechaSeleccionada,
    );
  }

  Future<void> _seleccionarFecha() async {
    final picked = await showDatePicker(
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
    final mortandadController = Provider.of<MortandadController>(context);
    final galpon = galponController.galponSeleccionado;

    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Mortandad')),
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
                        labelText: 'Cantidad de bajas',
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
                    TextFormField(
                      controller: _causaController,
                      decoration: const InputDecoration(
                        labelText: 'Causa (opcional)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: mortandadController.isLoading
                            ? null
                            : _guardarMortandad,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                        ),
                        child: mortandadController.isLoading
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : const Text('Guardar',
                                style: TextStyle(color: Colors.white)),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
