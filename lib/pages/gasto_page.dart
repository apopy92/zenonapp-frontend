import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../features/galpon/presentation/galpon_controller.dart';
import '../features/gasto/presentation/gasto_controller.dart';

class GastoPage extends StatefulWidget {
  const GastoPage({super.key});

  @override
  State<GastoPage> createState() => _GastoPageState();
}

class _GastoPageState extends State<GastoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _conceptoController = TextEditingController();
  final TextEditingController _montoController = TextEditingController();
  DateTime _fechaSeleccionada = DateTime.now();

  Future<void> _guardarGasto() async {
    final gastoController =
        Provider.of<GastoController>(context, listen: false);

    final montoTexto = _montoController.text.trim();
    final monto = double.tryParse(montoTexto);

    if (!_formKey.currentState!.validate() || monto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Ingrese un número válido')),
      );
      return;
    }

    await gastoController.guardarGasto(
      context: context,
      cantidad: monto.toInt(),
      descripcion: _conceptoController.text.trim(),
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
    final gastoController = Provider.of<GastoController>(context);
    final galpon = galponController.galponSeleccionado;

    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Gasto')),
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
                      controller: _montoController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'),
                        ),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Monto',
                        prefixText: 'Gs ',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese un monto';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Ingrese un número válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _conceptoController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^[a-zA-Z\s]+$'),
                        ),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Concepto',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese un concepto';
                        }
                        if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                          return 'Solo letras y espacios permitidos';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            gastoController.isLoading ? null : _guardarGasto,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                        ),
                        child: gastoController.isLoading
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
