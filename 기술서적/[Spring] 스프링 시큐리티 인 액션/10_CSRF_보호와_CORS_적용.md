# CSRF 보호와 CORS 적용
## CSRF(사이트 간 요청 위조) 보호 적용
### 스프링 시큐리티의 CSRS 보호가 작동하는 방식
CSRF 공격 예시
1. 사용자가 웹 애플리케이션에 로그인한다. 
2. 음악을 듣기 위해서 특정 사이트를 접속한다. 
3. 음악 사이트에는 악의적인 문제가 있으며, 음악 외에 위조 스크립트를 전달 받는다. 
4. 스크립트는 로그인한 사용자 대신 특정 작업을 수행해서 원치않는 변경을 적용할 수 있다. 

CSRF 보호는 어떻게 작동할까?
- 사용자가 적어도 한번은 HTTP GET으로 웹 페이지를 요청한다는 것을 가정한다. 
- 이때 애플리케이션은 고유한 토큰을 생성한다. 
- 이후부터 애플리케이션은 변경 작업에 대해서 고유한 토큰을 검증한다. 

`CsrfFilter` 필터
- CSRF 보호 역할을 하는 필터.
- `CsrfTokenRepository` 를 이용해서 토큰을 생성/저장/검증에 필요한 값을 관리한다. 
   - 기본 구성은 토큰을 HTTP 세션에 저장하고, UUID로 토큰을 생성한다.

CSRF보호는 브라우저에서 실행되는 웹 앱에 이용되며, 앱의 표시된 콘텐츠를 로드하는 브라우저가 변경 작업을 수행할 수 있다고 예상될 때 필요하다.
- 모바일 클라이언트가 있거나 프론트엔드를 별도의 프레임워크로 개발했을 경우에는 작동하지 않는다. 
- 기본적으로 GET, HEAD, TRACE, OPTIONS 외의 HTTP 방식으로 호출되는 엔드포인트에 적용된다. 

__CSRF 보호 샘플 코드__
- https://github.com/YoungChulShin/book-spring-security-in-action/tree/master/ch10-ex1-csrf

애플리케이션이 맞춤으로 CSRF 토큰을 관리하는 방식을 변경해야할 경우 아래 내용을 확인한다. 
- 스프링 시큐리티의 연관 클래스
   - CsrfToken: 토큰 정보를 기술한다.
      - 헤더 이름: X-CSRF-TOKEN
      - 토큰의 값을 저장하는 요청의 특성 이름: _csrf
      - 토큰의 값
   - CsrfTokenRepository: CSRF 토큰을 생성, 저장, 로드하는 객체를 기술한다.

## CORS(공유 출처 리소스 공유) 이용
CORS란?
- 기본적으로 브라우저는 사이트가 로드된 도메인 이외의 도메인에 대한 요청을 허용하지 않는다. 
   - 예: example.com에서 사이트를 열였다면 브라우저는 이 사이트에서 api.example.com에 대한 요청을 허용하지 않는다. 
- __브라우저는 CORS 매커니즘으로 이 정책을 완화하고 일부 조건에 다른 출처간의 요청을 허용한다고 볼 수 있다.__

### CORS 동작방식
HTTP 헤더에 정의되는 CORS 정보
- Access-Control-Allow-Origin: 도메인의 리소스에 접근할 수 있는 외부 도메인을 지정
- Access-Control-Allow-Methods: 다른 도메인에 대한 접근은 허용하지만 특정 HTTP 방식만 허용하고 싶을 때 지정한다
- Access-Control-Allow-Headers: 특정 요청에 이용할 수 있는 헤더에 제한을 추가한다

__스프링 시큐리티는 기본적으로 헤더에 응답을 추가하지 않는다.__

__CORS 매커니즘은 브라우저에 관한 것이며 CSRF처럼 엔드포인트를 보호하는 것은 아니다__
- 브라우저는 요청을 수행하지만 출처가 응답에 지정되지 않으면 응답을 수락하지 않는다. 

__구현 샘플 코드__
- https://github.com/YoungChulShin/book-spring-security-in-action/tree/master/ch10-ex2-cors

