import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/infrastructure/presentation/bottom-navigator/bottom_navigator_state.dart';
import 'package:trip_planner/infrastructure/presentation/features/settings/settings_screen.dart';
import 'package:trip_planner/infrastructure/presentation/home/home_screen.dart';
import 'package:trip_planner/infrastructure/presentation/trip/list_trips_screen.dart';
import 'package:trip_planner/infrastructure/presentation/trip/trip_register_screen.dart';

class BottomNavigatorScreen extends StatelessWidget {
  BottomNavigatorScreen({super.key});

  final List<Widget> pages = [
    HomeScreen(),
    TripRegisterScreen(),
    ListTripsScreen(),
    SettingsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final index = context.watch<BottomNavigatorProvider>().index;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: pages[index],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          child: BottomNavigationBar(
            currentIndex: index,
            type: BottomNavigationBarType.fixed,
            backgroundColor: theme.colorScheme.primary,
            selectedItemColor: theme.colorScheme.background,
            unselectedItemColor: Colors.grey[500],
            selectedFontSize: 12,
            unselectedFontSize: 11,
            onTap: (newIndex) => context.read<BottomNavigatorProvider>().index = newIndex,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined, size: 26),
                activeIcon: Icon(Icons.home, size: 26),
                label: "Tela Inicial",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_location_alt_outlined, size: 26),
                activeIcon: Icon(Icons.add_location_alt, size: 26),
                label: "Nova Viagem",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt_outlined, size: 26),
                activeIcon: Icon(Icons.list_alt, size: 26),
                label: "Minhas Viagens",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined, size: 26),
                activeIcon: Icon(Icons.settings, size: 26),
                label: "Configurações",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
