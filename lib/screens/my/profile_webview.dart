import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

//연결은 안된 상태. 터미널에 에러 난다.
class GoogleSearchPage extends StatefulWidget {
  @override
  _GoogleSearchPageState createState() => _GoogleSearchPageState();
}

class _GoogleSearchPageState extends State<GoogleSearchPage> {
  late WebViewController _controller;
  bool isLoading = true;
  final TextEditingController _urlController =
      TextEditingController(text: 'https://www.google.com');

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // JavaScript 활성화
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true; // 페이지 로딩 시작 시 로딩 상태 true
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false; // 페이지 로딩 완료 시 로딩 상태 false
            });
          },
        ),
      )
      ..loadRequest(Uri.parse('https://www.google.com')); // 초기 URL 로드
  }

  void _loadUrl(String url) {
    final uri = Uri.parse(url);
    if (uri.scheme.isEmpty) {
      _controller.loadRequest(Uri.parse('https://$url'));
    } else {
      _controller.loadRequest(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google WebView'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _urlController,
                    decoration: const InputDecoration(
                      hintText: 'Enter URL',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: _loadUrl,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _loadUrl(_urlController.text);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                WebViewWidget(
                  controller: _controller,
                ),
                if (isLoading)
                  const Center(
                    child: CircularProgressIndicator(), // 로딩 인디케이터 표시
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
