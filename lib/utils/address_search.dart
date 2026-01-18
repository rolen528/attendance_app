import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AddressSearch extends StatelessWidget {
  const AddressSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("주소 검색"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: InAppWebView(
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true, // 자바스크립트 실행 허용
          useHybridComposition: true, // 안드로이드 키보드/렌더링 문제 해결
        ),
        initialData: InAppWebViewInitialData(
          data: _htmlContent,
          // 중요: baseUrl을 설정해야 보안 문제 없이 스크립트가 실행
          baseUrl: WebUri("https://spi.maps.daum.net"),
        ),
        onWebViewCreated: (controller) {
          // 자바스크립트 통신 채널 연결
          controller.addJavaScriptHandler(
            handlerName: 'onAddressSelected',
            callback: (args) {
              // 주소 선택 시 데이터 받아서 창 닫기
              Navigator.pop(context, args[0]);
            },
          );
        },
      ),
    );
  }

  final String _htmlContent = """
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        /* 화면을 꽉 채우기 위한 강제 스타일 */
        html, body {
            width: 100%;
            height: 100%;
            margin: 0;
            padding: 0;
            overflow: hidden; /* 스크롤바 제거 */
        }
        #layer {
            width: 100%;
            height: 100%;
            border: none; /* 테두리 제거 */
        }
    </style>
</head>
<body>
    <div id="layer"></div>

    <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script>
        // 우편번호 찾기 화면을 layer div에 끼워넣기
        new daum.Postcode({
            oncomplete: function(data) {
                // 주소를 선택했을 때 Flutter로 데이터 전송
                window.flutter_inappwebview.callHandler('onAddressSelected', data);
            },
            width: '100%',
            height: '100%'
        }).embed(document.getElementById('layer'));
    </script>
</body>
</html>
  """;
}