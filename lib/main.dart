import 'package:flutter/material.dart';
import './screens/ar_paint_screen.dart';
import './screens/diy_tutorials_screen.dart';
import './screens/affiliate_program_screen.dart';
import './screens/signin_screen.dart';
import './screens/ar_decor.dart';
import 'package:firebase_core/firebase_core.dart';
import './firebaseauth/auth_service.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  void _checkUserStatus() {
    if (_authService.currentUser != null) {
      setState(() {
        _isLoggedIn = true;
      });
    }
  }

  Future<void> _signOut() async {
    await _authService.signOut();
    setState(() {
      _isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Paint and Decor App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 1,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 1,
          children: [
            _buildSection(
              context,
              'AR PAINT',
              'assets/ar_paint.jpeg',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ARPaintScreen()),
              ),
            ),
            _buildSection(
              context,
              'AR Decor',
              'assets/ardecor.jpg',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ARDecorScreen()),
              ),
            ),
            _buildSection(
              context,
              'DIY TUTORIALS',
              'assets/diy_tutorials.jpeg',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DIYTutorialsScreen()),
              ),
            ),
            _buildSection(
              context,
              'AFFILIATE PROGRAM',
              'assets/affiliate_program.jpeg',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AffiliateProgramScreen()),
              ),
            ),
            _buildSection(
              context,
              _isLoggedIn ? 'SIGN OUT' : 'SIGN IN',
              '',
              () {
                if (_isLoggedIn) {
                  _signOut();
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInScreen()),
                  ).then((value) {
                    if (value == true) {
                      setState(() {
                        _isLoggedIn = true; // Update login status on success
                      });
                    }
                  });
                }
              },
              isIcon: true,
              iconData: _isLoggedIn ? Icons.logout : Icons.login,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String imagePath, VoidCallback onPressed, {bool isIcon = false, IconData? iconData}) {
    return Card(
      elevation: 6,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          constraints: isIcon
              ? const BoxConstraints(maxHeight: 200, minHeight: 150)
              : const BoxConstraints(maxHeight: 320, minHeight: 290),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isIcon
                  ? Icon(
                      iconData,
                      size: 50,
                      color: Colors.blueAccent,
                    )
                  : Image.asset(
                      imagePath,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onPressed,
                child: Text(title),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 48),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
