# jboss-configuration-files
JBoss 운영에 필요한 파일들입니다.
---
## Jboss-configuration
### 파일 구성
- env.sh
- - 환경설정 값 기입 (포트, ip 주소, 로그 경로, java 옵션 등)
- start.sh
- - nohup으로 jboss 기동(background 실행)
- stop.sh
- - 해당 인스턴스 process 종료
- add-user.sh
- - jboss admin 접근 위한 계정 생성
- jboss-cli.sh
- - jboss admin 권한으로 접근하는 console 실행
- oracleDS.txt
- - 예제 DB 설정값
---
## Jboss-test-applications
### 파일 구성
jboss_upload.war / jboss.war
- 스프링부트 기반 어플리케이션 / upload 기능 / dbtest(select 조회 확인) / session 정보 확인