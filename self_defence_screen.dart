// import 'package:flutter/material.dart';
//
// class SelfDefenceScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Self Defence'),
//         automaticallyImplyLeading: false,
//       ),
//       body: const Center(
//         child: Text('Self Defence Resources Coming Soon'),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher

class SelfDefenceScreen extends StatefulWidget {
  @override
  _SelfDefenceScreenState createState() => _SelfDefenceScreenState();
}

class _SelfDefenceScreenState extends State<SelfDefenceScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Security'),
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.shield), text: "Self-Defense Tools"),
            Tab(icon: Icon(Icons.video_library), text: "Self-Defense Videos"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildToolsTab(),
          _buildVideosTab(),
        ],
      ),
    );
  }

  Widget _buildToolsTab() {
    final tools = [
      {
        "name": "Pepper Spray",
        "description": "Portable and effective self-defense spray.",
        "url": "https://www.flipkart.com/sfine-pepper-gel-spray/p/itma15e3b20db721?pid=PSFH42YNEZEFMTEH&lid=LSTPSFH42YNEZEFMTEH5TRWRZ&marketplace=FLIPKART&store=hlc%2Fiwt&srno=b_1_1&otracker=browse&fm=organic&iid=5a9f9478-b1ed-4fdd-9ede-0426a1971170.PSFH42YNEZEFMTEH.SEARCH&ppt=browse&ppn=browse&ssid=2gpbor9mkw0000001727958226984"
      },
      {
        "name": "Tactical Flashlight",
        "description": "Bright flashlight with a stun feature.",
        "url": "https://www.amazon.in/Smithsons-Rechargeable-Tactical-Flashlight-Waterproof/dp/B0BLT2TNVT/ref=sr_1_1?crid=1VBB6V6Z70BT4&dib=eyJ2IjoiMSJ9.OV_GPGoTIP4FLa8DX5SaKYFUXkRVXz_-1cVOWAo-2d2PD0iMhgFf6992W-Y49Dbs1vufMcXNz0Z_LXKV928vEl3SsbdAWRqMmoUVpNqWEizCqFGjmmb80XJiUjc-PLDQYMlFmqOANadkO0GBWcZxbRiDYOXispEGTEWkWnrHgU3Jkw47seTcWq0fjt0HbsqgwdZ9UIKDDa8ZLWrofC-leZ9FWjdfoABhsTNQcvEidAXZUoW7Jj2j-_UcXxuSJOVIEci76FQl0IBYsP_3H4BZ9AtnV5U60n0FkdMauZMuUWs.axSegwQWGXPmwlAysX9mc880t6JHPx6cH6ZtdXTBQj4&dib_tag=se&keywords=Tactical+Flashlight%22%2C+%22description%22%3A+%22Bright+flashlight+with+a+stun+feature.&nsdOptOutParam=true&qid=1727958402&sprefix=tactical+flashlight+%2C+description+bright+flashlight+with+a+stun+feature.%2Caps%2C203&sr=8-1"
      },
      {
        "name": "Personal Alarm",
        "description": "Compact alarm to alert others.",
        "url": "https://www.amazon.in/Devil-Will-Emergency-Keychain-Protection/dp/B0BPPZFZJD/ref=pd_lpo_sccl_1/259-1592364-6304810?pd_rd_w=WIUrn&content-id=amzn1.sym.e0c8139c-1aa1-443c-af8a-145a0481f27c&pf_rd_p=e0c8139c-1aa1-443c-af8a-145a0481f27c&pf_rd_r=H3C809J65S55HP6WK7HE&pd_rd_wg=G4nJ1&pd_rd_r=6997d5e7-7afc-48de-9aac-d571b84776a3&pd_rd_i=B0BPPZFZJD&th=1"
      },
    ];

    return ListView.builder(
      itemCount: tools.length,
      itemBuilder: (context, index) {
        final tool = tools[index];
        return Card(
          margin: EdgeInsets.all(8),
          child: ListTile(
            leading: Icon(Icons.security, color: Colors.blue),
            title: Text(tool['name']!),
            subtitle: Text(tool['description']!),
            onTap: () {
              _launchURL(tool['url']!);  // Open the URL when the tool is tapped
            },
            trailing: Icon(Icons.link, color: Colors.blue),  // Add a link icon for better UX
          ),
        );
      },
    );
  }

  Widget _buildVideosTab() {
    final videos = [
      {"title": "Basic Self-Defense Techniques", "youtubeUrl": "https://www.youtube.com/watch?v=K5UO9zA3GK4&list=PLLALQuK1NDrigB-xTBLJV4vZwOXfxbPnM"},
      {"title": "Defending Against an Attacker", "youtubeUrl": "https://www.youtube.com/watch?v=_tiQwDdttBo"},
      {"title": "Self-Defense for Women", "youtubeUrl": "https://www.youtube.com/watch?v=KVpxP3ZZtAc"},
    ];

    return ListView.builder(
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return Card(
          margin: EdgeInsets.all(8),
          child: ListTile(
            leading: Icon(Icons.play_circle_filled, color: Colors.red),
            title: Text(video['title']!),
            onTap: () {
              _launchURL(video['youtubeUrl']!); // Launch YouTube URL
            },
          ),
        );
      },
    );
  }

  // Method to launch the URL in the browser
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
