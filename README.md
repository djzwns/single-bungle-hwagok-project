서울기술교육센터 프로젝트
==============
IoT Smart Home 
-------------
0. 시연 예시
	- qt ui 영상
	- <img src="https://user-images.githubusercontent.com/17754057/139478657-8058e0aa-275a-462e-98ec-8a9be24e2f7f.gif" height="480">
	- qml 을 활용한 스와이프탭, 컬러셀렉터, 애니메이션
	-------------
	- 서버 구동 및 qt 실행
	- <img src="https://user-images.githubusercontent.com/17754057/139481137-f33c2229-e1c3-4d7b-b070-cb9f6f699d36.gif" height="480">
	- 라즈베리파이 서버 동작 이후 관리자(qt) 컨트롤러 실행
	-------------
	- 미등록 카메라 기기 연결 및 카메라 실행
	- <img src="https://user-images.githubusercontent.com/17754057/139481169-ad35976a-5b10-46be-b0bd-fe52f8d8a091.gif" height="480">
	- 미등록 기기 연결 시도 시에 qt화면에 팝업창 출력 후 수락, 거절 선택
	-------------
	- 침입자 감지
	- <img src="https://user-images.githubusercontent.com/17754057/139481196-2c730963-6fc9-4b98-9503-f41a47ca10fb.gif" height="480">
	- 침입자 발생시 팝업
	-------------
	- 스마트홈 동작
	- <img src="https://user-images.githubusercontent.com/17754057/139482277-09f0800c-d20f-4e35-92df-683ecdb8be02.gif">
	- qt앱을 통한 커튼 제어
	-------------
	- 무드등 조명 설정
	- <img src="https://user-images.githubusercontent.com/17754057/139482937-467b0b29-c1a9-46b5-9f7f-115b970c68a9.gif">
	- qt앱을 통한 조명 on/off 및 색상 설정
	-------------


1. raspberry-client
	- qt를 활용해 관리자 컨트롤러 구현
	- 등록된 기기와 통신해 제어 및 입력을 받음

2. raspberry-server
	- mariadb 를 통해 기기 및 데이터 관리
	- 연결된 기기들의 통신을 받아 처리
	
3. raspberry-image-processing
	- 웹캠을 활용해 영상처리를 진행
	- 침입자 감지 및 영상 캡쳐 등을 처리
