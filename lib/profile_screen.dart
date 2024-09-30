import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:exercisecoach/screens/IntroPage.dart'; // Import the IntroPage

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Stream<DocumentSnapshot> _userStream;
  String _name = '';
  String _email = '';
  String _bio = '';
  String _profilePhotoUrl = '';
  List<Map<String, dynamic>> _progressData = [];

  @override
  void initState() {
    super.initState();

    // Fetch user data from Firebase
    _userStream = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .snapshots();
    _userStream.listen((snapshot) {
      setState(() {
        _name = snapshot.get('name');
        _email = snapshot.get('email');
        _bio = snapshot.get('bio');
        _profilePhotoUrl = snapshot.get('profile_photo_url');
      });
    });

    // Fetch progress data from Firebase
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('progress')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _progressData = snapshot.docs.map((doc) => doc.data()).toList();
      });
    });
  }

  void _logout() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const IntroPage()),
            (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set the background color to black
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/profile_background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(_profilePhotoUrl),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Profile',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Set text color to white
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Set text color to white
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _email,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Bio: $_bio',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white, // Set text color to white
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Progress',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Set text color to white
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _progressData.length,
              itemBuilder: (context, index) {
                final progressData = _progressData[index];
                return _buildSportProgress(
                  progressData['sport'],
                  progressData['distance'],
                  progressData['percentage'],
                );
              },
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white24, // Semi-transparent white for contrast
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.person, color: Color(0xFF40D876)), // Primary accent color
                    title: const Text('Personal Information', style: TextStyle(color: Colors.white)), // White text color
                    trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFF40D876)), // Primary accent color
                    onTap: () {
                      // TODO: Navigate to personal information page
                    },
                  ),
                  const Divider(color: Colors.white24),
                  ListTile(
                    leading: const Icon(Icons.settings, color: Color(0xFF40D876)), // Primary accent color
                    title: const Text('Settings', style: TextStyle(color: Colors.white)), // White text color
                    trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFF40D876)), // Primary accent color
                    onTap: () {
                      // TODO: Navigate to settings page
                    },
                  ),
                  const Divider(color: Colors.white24),
                  Container(
                    color: Colors.redAccent.withOpacity(0.3), // Light red background for critical action
                    child: ListTile(
                      leading: const Icon(Icons.logout, color: Colors.redAccent), // Red accent color for icon
                      title: const Text('Logout', style: TextStyle(color: Colors.redAccent)), // Red text color
                      onTap: _logout,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSportProgress(String sport, String distance, int percentage) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color(0xFF40D876), // Primary accent color
        child: Text(
          sport.substring(0, 2),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      title: Text(
        sport,
        style: const TextStyle(color: Colors.white), // White text color
      ),
      subtitle: Text(
        distance,
        style: const TextStyle(color: Colors.white70), // Light white text color for subtitle
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: <Widget>[
            Expanded(
              child: LinearProgressIndicator(
                value: percentage / 100,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF40D876)), // Primary accent color
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$percentage%',
              style: const TextStyle(color: Colors.white), // White text color
            ),
          ],
        ),
      ),
    );
  }
}
