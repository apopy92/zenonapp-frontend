import 'package:flutter/material.dart';
import 'package:zenon_app/features/galpon/data/galpon_service.dart';
import 'package:zenon_app/features/galpon/domain/galpon_model.dart';
import 'package:zenon_app/features/auth/data/token_provider.dart';

class GalponController with ChangeNotifier {
  final GalponService _galponService;

  GalponController({required TokenProvider tokenProvider})
      : _galponService = GalponService(tokenProvider: tokenProvider);

  List<Galpon> _galpones = [];
  Galpon? _galponSeleccionado;

  List<Galpon> get galpones => _galpones;
  Galpon? get galponSeleccionado => _galponSeleccionado;
  int? get galponIdSeleccionado => _galponSeleccionado?.id;

  /// Establece los galpones manualmente (usado luego del login)
  void setGalpones(List<Galpon> galponList) {
    _galpones = galponList;
    if (_galpones.isNotEmpty) {
      _galponSeleccionado = _galpones.first;
    } else {
      _galponSeleccionado = null;
    }
    notifyListeners();
  }

  /// Carga galpones asignados desde la API
  Future<void> cargarGalponesAsignados() async {
    try {
      final galponesCargados = await _galponService.obtenerGalponesAsignados();
      if (galponesCargados.isNotEmpty) {
        _galpones = galponesCargados;
        _galponSeleccionado = _galpones.first;
      } else {
        _galpones = [];
        _galponSeleccionado = null;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error al cargar galpones: $e');
    }
  }

  /// Cambia el galpón seleccionado manualmente
  void seleccionarGalpon(Galpon galpon) {
    _galponSeleccionado = galpon;
    notifyListeners();
  }
}
