# URI 식별자 설계
## URI 형태
슬래시 구분자(/)는 계층 관계를 나타내는 데 사용한다

URI 마지막 문자로 슬래시(/)를 포함하지 않는다
- URI 경로 마지막에 있는 슬래시는 아무런 의미가 없지만 혼란을 초래할 수 있다.
- REST API에서 URI는 리소스의 유일한 식별자이다

하이픈(-)은 URI 가독성을 높이는데 사용한다
- URI를 쉽게 읽고 해석하기 위해서, 긴 URI 경로에 하이픈을 사용해서 가독성을 높인다
- 예: http://api.example.restapi.org/blogs/mark-masse/entries/this-is-my-first-post

밑줄(_)은 URI에 사용하지 않는다

URI 경로에는 소문자가 적합하다
- RFC3986에서는 URI 스키마와 호스트를 제외하고는 대소문자를 구별하도록 규정한다.
- 예
   1. http://api.example.restapi.org/my-folder/my-doc
   2. HTTP://API.EXAMPLE.RESTAPI.ORG/my-folder/my-doc
   3. http://api.example.restapi.org/My-Folder/my-doc
   - 1, 2는 같은 것으로 간주된다
   - 3은 대문자가 섞여있기 때문에 1, 2와는 다른 URI이다

파일 확장자는 URI에 포함시키지 않는다

## 리소스 원형
도큐먼트
- 객체 인스턴스나 데이터베이스 레코드와 유사한 단일 개념
- 도큐먼트 리소스는 자식 리소스를 가질 수 있는데, 이 자식 리소스는 특정한 종속 개념을 표현한다. 
- 예
   - http://api.soccer.restapi.org/leagues/seattle
   - http://api.soccer.restapi.org/leagues/seattle/teams/trebuchet
   - http://api.soccer.restapi.org/leagues/seattle/teams/trebuchet/players/mike

컬렉션
- 서버에서 관리하는 디렉토리 리소스
- 예
   - http://api.soccer.restapi.org/leagues
   - http://api.soccer.restapi.org/leagues/seattle/teams
   - http://api.soccer.restapi.org/leagues/seattle/teams/trebuchet/players

스토어 (p.19)
- _개념이 잘 이해가 안되어서 정리 pass_

__컨트롤러__
- 절차적인 개념을 모델링한 것. 실행가능한 함수와 같아서 입력 값과 반환 값이 있다.
- URI 경로의 제일 마지막 부분에 표시되며, 계층적으로 뒤따르는 자식 리소스는 없다.
- 예: 클라이언트가 사용자에게 경고를 재전송하게 하는 컨트롤러 리소스
   - POST /alrerts/123123/resend

## URI 경로 디자인
도큐먼트 이름으로는 단수 명사를 사용해야 한다. 

컬렉션 이름으로는 복수 명사를 사용해야 한다. 

__컨트롤러 이름으로는 동사나 동사구를 사용해야한다__
- 프로그램에서 사용하는 함수처럼 컨트롤 리소스를 나타내는 URI는 동작을 포함하는 이름으로 지어야한다
- 예
   - http://api.example.restapi.org/students/mogran/register
   - http://api.example.restapi.org/dbs/reindex

__CRUD 기능을 나타내는 것은 URI에 사용하지 않는다__
- URI는 리소스를 식별하는 데만 사용해야한다. 
- 예시
   - Good: DELETE /users/1234
   - Bad: DELETE /deleteUser/1234

## URI Query 디자인
특징
- RFC 3869에서 URI 쿼리는 선택 사항이고, 다른 선택사항인 프래그먼트 사이에 온다
- 클라이언트에 검색이나 필터링 같은 추가적인 상호작용 능력을 제공한다. 
- URI의 쿼리 유무에 따라 캐시의 작용이나 기능이 바뀌어서는 안된다.

URI 쿼리 부분으로 컬렉션이나 스토어를 필터링할 수 있다
- URI 쿼리는 컬렉션이나 스토어의 검색 기준으로 사용하기에 적합하다
- 예: 
   - GET /users : 컬렉션에 있는 모든 사용자의 리스트
   - GET /users?role=admin: 컬렉션에 있는 사용자 중, role 값이 amdin인 사용자의 리스트

__URI 쿼리는 컬렉션이나 스토어의 결과를 페이지로 구분하여 나타내는데 사용해야 한다__
- URI 쿼리로 클라이언트의 페이지나 필터링의 요구 사항에 대응할 수 없다면 컨트롤러를 생각해봐야한다. 
- 예: POST /users/search - request body에 좀 더 복잡한 입력을 받을 수 있다

# HTTP를 이용한 인터랙션 설계
## 요청 메서드
GET 메서드는 리소스의 상태 표현을 얻는 데 사용해야 한다
- 클라이언트의 GET 요청 메시지는 바디 없이 헤더로만 구성된다

응답 헤더를 가져올 때는 반드시 HEAD 메서드를 사용해야한다
- HEAD메서드는 GET메서드와 동일한 응답을 주지만 바디가 없다
- 클라이언트에서는 리소스의 존재 여부 또는 메타 데이터만 확인하고 싶을 때 사용한다.

PUT 메서드는 리소스를 삽입하거나 저장된 리소스를 갱신하는 데 사용해야한다. 
- PUT 메서지에는 클라이언트에서 저장하려는 리소스를 표현하는 부분이 포함되어야 한다. 그 응답이 GET 요청을 통해서 받는 것과 같을 수도 있고 다를 수도 있다.

POST 메서드는 컬렉션에 새로운 리소스를 만드는 데 사용해야 한다.

__POST 메서드는 컨트롤러를 실행하는 데 사용해야 한다__
- REST API 디자인은 컨트롤러 리소스로 모든 동작을 실행하기 위해 POST 메서드를 사용하는데, 각 기능 및 동작은 직관적으로 HTTP 메서드들과 매핑되지 않는다. 
- 다시 말해 POST 메서드는 리소스를 가지고 오거나, 저장하거나, 지우는 데 사용하지는 않는다. 

DELETE 메서드는 그 부모에서 리소스를 삭제하는 데 사용해야 한다
- DELETE는 의미가 매우 명확하기 때문에 오버로드 되거나 확장될 수 없다. 예를 들어서, 어떤 API에서 리소스를 임시 삭제하거나, 상태만으로 변경하기로 했다면 컨트롤러 리소스를 채택하고 DELETE 메서드 대신 POST를 사용해야 한다. 

## 응답 상태 코드
200(OK)는 일반적인 요청 성공을 나타내는 데 사용해야한다
- 클라이언트의 요청을 서버가 성공적으로 수행했음을 나타낸다

200(OK)는 응답 바디에 에러를 전송하는 데 사용해서는 안된다
- _200이지만 본문 내에서 result를 fail로 가져가는 케이스일까?_

201(Created)는 성공적으로 리소스를 생성했을 때 사용해야한다. 




