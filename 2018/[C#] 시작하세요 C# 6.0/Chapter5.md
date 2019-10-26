
# 5.1 문법 요소
## 5.1.1 구문
### 전처리기
- C#의 전처리기 지시문(preprocessor directive)는 특정 소스코드를 상황에 따라 컴파일 과정에서 추가/제거하고 싶을 때 사용한다. 
- #if, #endif 를 이용해서 사용 가능하다.
- #elif, #else 를 통해서 구문을 분리해서 처리 가능하다

- #define을 이용하면 컴파일 기호를 넣지 않고도 코드에서 사용 가능하다. 
  - '#define X86'

### 특정 (Attribute)
- 특성도 하나의 Class이다. System.Attribute를 상속받는다
- 이름은 뒤에 'Attribute'를 붙여서 생성한다. 
  - class TestAttribute : System.Attribute 
- ['AttributeName'] 로 사용하는데, 이는 'new AttributeName()'과 동일하다
- Attribute Class는 'System.AttributeUsageAttribte'라는 또 다른 특성을 사용할 수 있다.
  - enum 타입의 'AttributeTarget' 값을 인자로 받는 생성자가 있다
  - 이는 Attribute를 특정 특성 (예: Assembly, Module, Class, Struct, Enum)에 사용될 수 있도록 제한한다. 

## 5.1.2 연산자
### 시프트 연산자
- 비트 단위로 제어할 때 사용
- '>>' : 오른쪽으로 n 비트 이동
- '<<' : 왼쪽으로 n 비트 이동 
### 비트 연산자
- & : And
- | : Or
- ^ : XOR
- ~ : 보수 연산자

## 5.1.3 예약어
### 가변 매개변수: params
- 함수의 파라미터를 전달 받을 때, 정확히 수를 모르는 경우 params를 파라미터 앞에 붙여서 n개의 값을 받을 수 있다
- 타입이 서로 다르다면, object 타입을 받아서 처리할 수 도 있다

### Win32 API 호출: extern
- ManagedCode에서 C, C++로 만들어진 함수(UnManagedCode)를 호출할 때 사용
  - P/Invoke: platform invocation
- extern을 위해서는 3가지의 내용이 필요
  1. DLL 이름 : User32.dll
  2. 함수 이름 : MessageBeep
  3. 함수 형식 : BOOL WINAPI MessageBeep (_In_ UINT uType)
- extern은 메서드에 코드가 없어도 실행될 수 있게 해주는 기능
- Win32 API와 C# 코드를 연결하는 것은 [DLLImport] 특성을 이용해서 사용 가능하다. 
- www.pinvoke.net 사이트에서 win32 API를 확인 가능하다

### unsafe
- C#에서 C/C++ 언어의 포인터를 사용할 때 unsafe 예약어를 이용해서 사용
- 포인터 연산 (*, &)
- unsafe 추가 
  1. 함수 정의 
  2. 함수를 호출해서 사용할 때, 관련 범위를 unsafe로 묶어서 사용한다
- 컴파일
  1. 커맨드라인: csc /unsafe programs.cs
  2. 비주얼스튜디오: 속성에서 '안전하지 않은 코드 허용' 사용


# 5.2 프로젝트 구성
## 5.2.2 라이브러리
### csc.exe
- 사용법: csc 'filename'.cs
- 옵션을 넣지 않으면 기본적으로 /target:exe 로 설정
- 라이브러리 파일을 만드려면 옵션에 csc /target:library 'filename'.cs 로 생성한다

### app.config 파일
- 닷넷 프로그램을 실행하면 처음 CLR 환경이 초기화 되고, 이후에 개발자가 작성한 코드가 실행된다.
- CLR 초기화 과정에서 값을 전달해야할 때가 있는데, 프로그램 코드로는 전달할 수가 없기 때문에 app.config 파일을 이용해서 전달한다. 
- 빌드가 되면 *.exe.config 로 생성된다. 
- 닷넷 프로그램을 실행하면 CLR을 로드하고 초기화하는 코드가 실행된다.<br>
초기화 하는 코드에서 *.exe.config 파일이 있으면 해당 파일을 로드해서 비교한다. 
- SupportedRuntime
  - 이 항목을 명시적으로 지정하면 반드시 해당 프레임워크 버전이 설치돼 있어야 응용 프로그램이 동작한다. 
- appSetting
  - 응용프로그램에 값을 전달하는 목적으로 사용
  - 정의: configuration -> appSettings -> add key="ddd" value = "ddd" 
  - 사용: System.Configuration!System.Configuration.ConfigurationManager.AppSettings

## 5.2.4 디버그 빌드와 릴리즈 빌드
- 인라인
  - 호출하는 측(Caller)의 코드에 대상 메서드(Callee)의 코드가 포함되는 것
  - 매서드의 코드를 인라인 시키는 이유는 속도를 빠르게 하기 위해서
- 릴리즈 빌드
  - 최적화를 허용하는 빌드
  - 오류파악의 관점에서 볼 때 2가지의 주요 문제점이 있다. 
     1. 소스라인의 정보가 없다
     2. 최적화를 통한 메서드가 인라인 되었다. 


- PDB (Program database) 파일
  - 디버그 모드(=debug)로 빌드하면 생성된다
  - 오류가 발생하면 CLR은 program.pdb 파일을 로드해서 문제가 발생한 소스코드의 라인 정보를 함께 추력해준다. 
  - 일반적으로 배포는 릴리즈 빌드로 하는데, 소스 코드 라인정보를 얻기 위해서 /debug:pdbonly 옵션을 적용한다. 

- Trace, Debug
  - Trace: 디버그 데이터 출력
  - Debug: 디버그 모드에서 디버그 데이터 출력
  - DebugView 프로그램


  