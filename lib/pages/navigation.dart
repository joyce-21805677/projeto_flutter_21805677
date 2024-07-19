import 'package:flutter/material.dart';
import 'package:projeto_flutter_21805677/pages/pages.dart';
import 'package:provider/provider.dart';

class NavigationViewModel extends ChangeNotifier{

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }
}

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {



  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NavigationViewModel>();

    return Scaffold(
      body: pages[viewModel.selectedIndex].widget,
      bottomNavigationBar: NavigationBar(
        selectedIndex: viewModel.selectedIndex,
        onDestinationSelected: (index) => viewModel.selectedIndex = index,
        destinations: pages.map((p) => NavigationDestination(icon: Icon(p.icon), label: p.title)).toList(),
      ),
    );
  }
}
