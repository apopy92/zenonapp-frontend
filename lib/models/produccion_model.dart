import 'package:flutter/material.dart';

import '../../widgets/info_card.dart';
import '../../widgets/pie_chart.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.brown),
              child: Text('Acciones',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Registrar Producción'),
              onTap: () => Navigator.pushNamed(context, '/produccion'),
            ),
            ListTile(
              leading: Image.asset(
                'assets/icons/mortal.png',
                width: 24,
                height: 24,
              ),
              title: const Text('Registrar Mortandad'),
            ),
            const ListTile(
              leading: Icon(Icons.receipt),
              title: Text('Registrar Gasto'),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Resumen",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const InfoCard(
                    title: "Producción",
                    value: "6,250",
                    icon: Icon(Icons.egg, size: 30, color: Colors.brown),
                  ),
                  InfoCard(
                    title: "Mortandad",
                    value: "25",
                    icon: Image.asset(
                      'assets/icons/mortalidad.png',
                      width: 30,
                      height: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: const [
                  InfoCard(
                    title: "Stock",
                    value: "1,850",
                    icon: Icon(Icons.inventory, size: 30, color: Colors.brown),
                  ),
                  InfoCard(
                    title: "Facturación",
                    value: "\$1,250",
                    icon:
                        Icon(Icons.attach_money, size: 30, color: Colors.brown),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: const [
                  InfoCard(
                    title: "Gastos",
                    value: "800",
                    icon: Icon(Icons.receipt, size: 30, color: Colors.brown),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const PieChartSection(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
