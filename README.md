# daenglog_fe

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

설치 방법

flutter SDK 설치 후 , App store -> Xcode 다운로드
zshrc -> export PATH=$HOME/development/flutter/bin:$PATH
zshrc -> export PATH=$HOME/.gem/bin:$PATH

First
1. open -a Simulator
2. flutter run (2) -> iphone 16 pro
3. 'r' 을 통해서 refresh
- cf) 특정 dart파일을 실행하고 싶다면 dart run "경로"

모든 작업은
lib/main.dart 

세부 기능 (각 device별)은 해당 폴더에서 작업

📁 폴더 구조
1. ✨ lib/features/ 부터 기능 작업
2. ⚙️ lib/common/ + lib/core -> 공용 component

        common -> 유틸리티, 위젯, 상수
        core -> 앱의 핵심 구조, 설정, 의존성, 아키텍쳐
    
Flutter 
1. 기본적으로 파일명->  snacke_case.dart (camelCase 사용 x)
2. 클래스명 -> PascalCase

충돌시 
1. flutter clean
2. flutter pub-get
3. flutter doctor

alias sim16='open -a Simulator --args -CurrentDeviceUDID 92675CE6-3DE5-4B60-90ED-E2B8899EFE89'

초기화면 설정
lib/main.dart -> 49번 라인 수정하면 됨
ex) initialRoute: '/splash.dart'