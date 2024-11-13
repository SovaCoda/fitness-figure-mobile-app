import 'package:ffapp/components/robot_image_holder.dart';
import 'package:flutter/material.dart';
import 'package:ffapp/services/routes.pb.dart' as Routes;

class ProfilePage extends StatelessWidget {
  final Routes.User user;

  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header Section
            Container(
              color: Theme.of(context).primaryColor,
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Profile Image
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Name
                  Text(
                    user.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Profile Menu Items
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildMenuItem(
                      context,
                      Icons.email,
                      'Email',
                      user.email,
                    ),
                    const Divider(height: 1),
                    _buildRobotImage(
                      context,
                      Icons.person_outline,
                      'Current Figure',
                    ),
                    const Divider(height: 1),
                    _buildMenuItem(
                      context,
                      Icons.star,
                      'Premium Status',
                      user.premium == 1 ? 'Premium Member' : 'Standard Member',
                      iconColor: user.premium == 1 ? Colors.amber : null,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    String value, {
    Color? iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 24,
            color: iconColor ?? Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRobotImage(
    BuildContext context,
    IconData icon,
    String title,
    ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        
        children: [

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4), // cannot currently display skin from user, so we will show the default skin
                RobotImageHolder(url: "${user.curFigure}/${user.curFigure}_skin0_evo0_cropped_happy", height: 200, width: 200),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
