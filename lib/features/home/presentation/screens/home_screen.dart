import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/order_controller.dart';
import '../../../../core/constants/hindi_strings.dart';
import '../../../../core/constants/darzi_colors.dart';
import '../../../orders/presentation/screens/add_order_screen.dart';
import '../../../orders/presentation/screens/orders_list_screen.dart';

/// Main home screen with 2-tab bottom navigation.
///
/// Tab 1: नया ऑर्डर  — AddOrderScreen
/// Tab 2: सभी ऑर्डर — OrdersListScreen
///
/// Uses IndexedStack to preserve state when switching tabs.
/// RegistersOrderController once here for the whole app.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;

  @override
  void initState() {
    super.initState();
    // Register GetX controller here — accessible from all child screens
    Get.put(OrderController());
  }

  final List<Widget> _tabs = const [
    AddOrderScreen(),
    OrdersListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack keeps both screens alive (preserves scroll + form state)
      body: IndexedStack(
        index: _navIndex,
        children: _tabs,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: DarziColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
        border: const Border(
          top: BorderSide(color: DarziColors.divider, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: BottomNavigationBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            currentIndex: _navIndex,
            onTap: (i) => setState(() => _navIndex = i),
            iconSize: 32,
            selectedFontSize: 16,
            unselectedFontSize: 14,
            selectedItemColor: DarziColors.primary,
            unselectedItemColor: DarziColors.textGray,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.add_circle_outline),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.add_circle),
                ),
                label: HindiStrings.newOrder,
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.list_alt_outlined),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.list_alt),
                ),
                label: HindiStrings.allOrders,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
