# OAuth2 권한부여 서버 구현
_책의 구현이 Spring-Cloud-Oauth2를 이용하는데, 부트 3.x가 나온 시점에서는 해당 기능이 더 이상 유효하지 않습니다. 그래서 코드 관련된 부분은 대부분 제외되었습니다._

권한 부여 서버의 역할
- 사용자를 인증
- 클라이언트에게 토큰을 제공
- Keycloak이나 Okta 같은 타사 툴을 선택할 수도 있다

## 권한 부여 서버에 클라이언트 등록
기본 흐름
```
범레
- ->: implement
- -->: use

InMemoryClientDetailsService -> <<ClientDetailsService>>  --> <<ClientDetails>> <- BaseClientDetails
JdbcClientDetailsService     ->
```
- ClientDetailsService: 클라이언트 세부 정보를 검색하는 구성 요소를 나타내는 계약. UserDetailsService와 유사하다. 
- ClientDetails: 시프링 시큐리티가 이해할 수 있게 클라이언트를 나타내는 계약
- BaseClientDetails: ClientDetails 계약의 간단한 구현

## Password grant 유형 이용
엔드포인트
- `/oauth/token` 엔드포인트를 통해서 토큰을 호출할 수 있다. 시큐리티가 자동으로 만들어준다. 
