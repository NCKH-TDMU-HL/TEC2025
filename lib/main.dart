import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart'; // Đã xóa Firebase import
import './Pages/Login/_page_all_login.dart';
import './Pages/home/_page_home.dart';
import 'Pages/menu/_page_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // await Firebase.initializeApp(); // Đã xóa Firebase initialization
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;

  void _onLoginSuccess() {
    setState(() {
      _isLoggedIn = true;
    });
  }

  void _onLogout() {
    setState(() {
      _isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.blue,
          selectionColor: Colors.blueAccent, 
          selectionHandleColor: Colors.blue,
        ),
      ),
      home: _isLoggedIn
          ? MainScreen(onLogout: _onLogout)
          : AllLoginPage(onLoginSuccess: _onLoginSuccess),
    );
  }
}

class MainScreen extends StatefulWidget {
  final VoidCallback onLogout;
  const MainScreen({super.key, required this.onLogout});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _currentIndex = 2;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const Center(child: Text('Lịch sử', style: TextStyle(fontSize: 24))),
      const Center(child: Text('Ví điện tử', style: TextStyle(fontSize: 24))),
      const HomePageContent(),
      const Center(child: Text('Thông báo', style: TextStyle(fontSize: 24))),
      const MenuPage(),
    ];
  }

  Widget _buildIcon(IconData icon, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected
            ? const Color.fromARGB(255, 45, 126, 248)
            : Colors.transparent,
      ),
      child: Icon(
        icon,
        size: isSelected ? 32 : 24,
        color: isSelected ? Colors.white : Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(splashFactory: NoSplash.splashFactory),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          enableFeedback: true,

          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),

          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 11,
          ),

          items: [
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.history, _currentIndex == 0),
              label: 'Lịch sử',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(
                Icons.account_balance_wallet,
                _currentIndex == 1,
              ),
              label: 'Ví điện tử',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.home, _currentIndex == 2),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.notifications, _currentIndex == 3),
              label: 'Thông báo',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.menu, _currentIndex == 4),
              label: 'Menu',
            ),
          ],
        ),
      ),
    );
  }
}