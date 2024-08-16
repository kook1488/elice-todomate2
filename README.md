# Todomate 엘리스 프로젝트 3팀 

## 참여 멤버
- 팀장 고규화
- 팀원
- - 국한
- - 김기태
- - 정원교
- - 정희진


## 디렉토리 구조 및 파일명
### Chat 파트 
- /lib/chat 챗기능 메인 화면
    - chat.dart  메인 파일
    - /core 컨트롤러 디렉토리
        - scroll_controller_mixin.dart  스크롤을 위한 컨트럴러
        - database_helper.dart DB 웹소켓 연결을 대비한 헬퍼파일.. 미작동 상태
    - /view 뷰 디렉토리
        - chat_screen.dart 채팅방 목록 화면(메인 화면)
        - chat_inner_screen.dart 채팅방 메인뷰
        - chat_input_section.dart 채팅방 입력창을 위한 디자인 뷰
        - /widgets 뷰용 위젯 디렉토리
            - chats_item_widget.dart 채팅방 목록 디자인 위젯
            - chat_inner_screen_widgets.dart 채팅방 디자인 위젯
    - /models 모델 디렉토리
        - chat_model.dart  채팅목록 창에서 데이터를 연결하기 위하 모델
        - message_model.dart  채팅방에서 데이터를 연결하기 위한 모델
        - user_info.dart 메인파일에서 로그인 사용자 정보를 가져오는 모델
- /lib/assets 참조용 파일 디렉토리
    - chat_x.json id 별 채팅 내역
    - /images
        - avata_x.png 아바타 파일들 숫자는 등록된 친구 알파벳은 신규 등록 가능 친구
