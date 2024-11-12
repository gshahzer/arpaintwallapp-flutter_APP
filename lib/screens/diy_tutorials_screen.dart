import 'package:flutter/material.dart';

class DIYTutorialsScreen extends StatelessWidget {
  const DIYTutorialsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DIY Tutorials'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Welcome to DIY Tutorials!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildVideoCard(context, 'Tutorial 1', 'assets/tutorial.png'),
                  const SizedBox(height: 16),
                  _buildVideoCard(context, 'Tutorial 2', 'assets/tutorial.png'),
                  const SizedBox(height: 16),
                  _buildVideoCard(context, 'Tutorial 3', 'assets/tutorial.png'),
                  const SizedBox(height: 16),
                  _buildVideoCard(context, 'Tutorial 4', 'assets/tutorial.png'),
                  const SizedBox(height: 16),
                  _buildVideoCard(context, 'Tutorial 5', 'assets/tutorial.png'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoCard(BuildContext context, String title, String thumbnailPath) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.asset(
              thumbnailPath,
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    // Add video playing functionality here
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Play Video'),
                  style: ElevatedButton.styleFrom(
                    // backgroundColor: Colors.blueAccent,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
