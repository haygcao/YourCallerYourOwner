import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // 导入 http 包

// ...

class CardWidget extends StatelessWidget {
  const CardWidget({
    Key? key,
    this.title,
    this.description,
    this.image,
    this.content,
    this.githubRawUrl,
  }) : super(key: key);

  final String? title;
  final String? description;
  final Image? image;
  final Widget? content;
  final String? githubRawUrl;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          if (title != null) Text(title),
          if (description != null) Text(description),
          if (image != null) image,
          if (content != null) content,
          if (githubRawUrl != null) _buildGithubRawContent(githubRawUrl),
        ],
      ),
    );
  }

  Widget _buildGithubRawContent(String url) {
    return FutureBuilder<String>(
      future: _fetchGitHubRaw(url),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Future<String> _fetchGitHubRaw(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load GitHub Raw content.');
    }
  }
}
