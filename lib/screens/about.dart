import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatelessWidget {
  static String id = "about_us";

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('About Us'),
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'License',
                icon: Icon(Icons.description),
              ),
              Tab(
                text: 'Credits',
                icon: Icon(Icons.people),
              ),
            ],
            indicatorColor: Colors.green, // Customize tab indicator color
            labelColor: Colors.green, // Customize tab label color
          ),
        ),
        body: TabBarView(
          children: [
            // License Tab
            LicenseTab(),
            // Credits Tab
            CreditsTab(),
          ],
        ),
      ),
    );
  }
}

class LicenseTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TalkinPics',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Text(
            'This app is licensed under GNU General Public License Version 1',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          TextButton(
            onPressed: () {
              launch('https://www.gnu.org/licenses/gpl-3.0.html');
            },
            child: Text(
              'https://www.gnu.org/licenses/gpl-3.0.html',
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CreditsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Credits',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          buildPersonTile(context, 'YUVARAJ T', 'yuvaraj_photo.jpg'),
          buildPersonTile(context, 'BHARATH VARSH S', 'bharath_photo.jpg'),
          buildPersonTile(context, 'KAVI RAM', 'kavi_photo.jpg'),
          SizedBox(height: 16.0),
          Row(
            children: [
              Text(
                'Guidance ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('DR.BAMA SRINIVASAN'),
            ],
          ),
          SizedBox(height: 16.0),
          Text(
            'B.Tech IT at CEG, 2021 - 2025 Batch',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('Dept of IST, Anna University'),
        ],
      ),
    );
  }

  Widget buildPersonTile(BuildContext context, String name, String imageName) {
    return ListTile(
      leading: Container(
        width: 60, // Adjust the width of the container as needed
        height: 60, // Adjust the height of the container as needed
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit
                .contain, // Adjust how the image fits within the container
            image: AssetImage('./lib/assets/$imageName'),
          ),
        ),
      ),
      title: Text(name),
    );
  }
}
