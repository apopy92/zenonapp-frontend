import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ZenonApp/core/routes/app_routes.dart';
import 'package:ZenonApp/features/galpon/presentation/galpon_controller.dart';
import 'package:ZenonApp/features/auth/presentation/login_controller.dart';
import 'package:ZenonApp/features/auth/presentation/widgets/splash_dialog_loading.dart';
import '../../widgets/info_card.dart';
import '../../widgets/pie_chart.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  Future<void> _logout(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(24),
        child: SplashDialogLoading(),
      ),
    );

    final loginController =
        Provider.of<LoginController>(context, listen: false);
    final success = await loginController.logout();

    if (context.mounted) {
      Navigator.of(context).pop(); // Cerrar el diálogo
      if (success) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.login,
            (route) => false,
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al cerrar sesión')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as String?;
    final galponController = Provider.of<GalponController>(context);
    final galpones = galponController.galpones;
    final seleccionado = galponController.galponSeleccionado;

    if (args != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ $args registrada correctamente'),
            backgroundColor: Colors.green,
          ),
        );
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBEA),
      appBar: AppBar(
        title: const Text("Dashboard"),
        centerTitle: true,
        actions: [
          if (galpones.isNotEmpty && seleccionado != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: seleccionado.id,
                  items: galpones.map((galpon) {
                    return DropdownMenuItem<int>(
                      value: galpon.id,
                      child: Text("Galpón ${galpon.nombre}"),
                    );
                  }).toList(),
                  onChanged: (value) {
                    final seleccionado =
                        galpones.firstWhere((g) => g.id == value);
                    galponController.seleccionarGalpon(seleccionado);
                  },
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.brown),
              child: Text(
                'Acciones',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Registrar Producción'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/produccion');
              },
            ),
            ListTile(
              leading: Image.asset(
                'assets/icons/mortal.png',
                width: 24,
                height: 24,
              ),
              title: const Text('Registrar Mortandad'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/mortandad');
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt),
              title: const Text('Registrar Gasto'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/gasto');
              },
            ),
          ],
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Resumen",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                InfoCard(
                  title: "Producción",
                  value: "6,250",
                  icon: Icon(Icons.egg, size: 30, color: Colors.brown),
                ),
                InfoCard(
                  title: "Mortandad",
                  value: "25",
                  icon: Image(
                    image: AssetImage('assets/icons/mortalidad.png'),
                    width: 30,
                    height: 30,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                InfoCard(
                  title: "Stock",
                  value: "1,850",
                  icon: Icon(Icons.inventory, size: 30, color: Colors.brown),
                ),
                InfoCard(
                  title: "Facturación",
                  value: "\$1,250",
                  icon: Icon(Icons.attach_money, size: 30, color: Colors.brown),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                InfoCard(
                  title: "Gastos",
                  value: "800",
                  icon: Icon(Icons.receipt, size: 30, color: Colors.brown),
                ),
              ],
            ),
            SizedBox(height: 16),
            PieChartSection(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
