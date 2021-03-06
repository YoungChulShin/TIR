# 1장 C# 언어 요소

## 아이템1: 지역변수를 선언할 때는 var를 사용하는 것이 낫다
- 타입을 명시적으로 지정할 경우 타입 안정성이 향상될 것이라 생각하지만 이 또한 사실이 아니다. 
- C#에서 특정 변수를 var로 선언하면 동적 타이핑이 수행되는 것이 아니라 할당 연산자 오른쪽의 타입을 확인하여 왼쪽 변수의 타입을 결정하게 된다. 
- _물론 var를 사용할 경우 반환 타입을 짐작하기 어려운 경우도 있다_<br>
실제 코드 작성 시에는 이보다 훨씬 명확하게 메서드의 이름을 지을 것이며 또한 반드시 그래야만 한다. 하지만 이 경우에도 변수명을 조금 달리하면 그 의미를 더 명확하게 드러낼 수 있다. 
- C#이 제공하는 내장 숫자 타입들은 매우 다양한 형변환 기능을 가지고 있고 정밀도도 각기 다르다. 이로 인해 숫자 타입과 var를 함께 사용하면 가독성 문제뿐 아니라 정밀도와 관련된 혼돈스러운 문제를 유발할 가능성이 있다. 
- 코드를 읽을 때 지연변수의 타입을 명확히 유추할 수 없고 모호함을 불러일으킬 가능성이 있따면 차라리 타입을 명시적으로 선언하는 것이 좋다. 하지만 대부분의 경우에 변수의 이름을 통해서 그 역할을 명확하게 드러내도록 코드를 작성하는 것이 훨씬 낫다.
- 개발자가 변수의 타입을 짐작할 수 없는 경우라면 명시적으로 사용하는 것이 좋다. 내장 숫자 타입(int, double, float)이 그 예이다. 

- IQueryable, IEnumerable
<br>- IEnumerable의 경우 LINQ Query가 즉시 수행된다
<br>- IQueryable의 경우 LINQ Query가 단일의 SQL 쿼리로 합산된 후 한번에 수행된다. 
<br>- 서버에서 데이터를 가져오는 경우 IEnumerable이라면 뒤에 where 조건의 LINQ 함수가 있더라도, 첫번째 선언문에서 전체 데이터를 한번에 가져오면서 서버에 영향을 줄 수 있다

## 아이템2: cosnt 보다는 readonly가 좋다
- C#은 컴파일타임 상수와 런타임 상수 두 유형의 상수를 가진다.
  1. 컴파일타임: const
  2. 런타임: readonly

- 컴파일타임 상수
  - 컴파일 시점에 변수가 값으로 대체되기 때문에, 일반 값을 사용했을 때와 동일한 IL(Intermediate Language) 코드로 변경된다. 
  - 내장된 문자열, enum 문자열, null에 대해서만 사용될 수 있다
  - 선언 시점에만 초기화 가능하다
- 런타임 상수
  - 컴파일 시점에는 상수에 대한 참조로 컴파일 된다. 
  - 어떤 타입과도 함께 사용될 수 있다. 
  - 선언 시점과 생성자에서 초기화 가능하다

- public 으로 선언된 컴파일타임 상수의 값을 수정할 때는 타입의 인터페이스를 변경하는 것 만큼이나 신중해야 하며, 해당 상수를 참조하는 모든 코드를 반드시 재 컴파일해야 한다. 
- readonly 대신 cosnt를 사용했을 때 얻을 수 있는 장점은 성능이 빠르다는 것이다. 상숫값으로 코드를 대체하면 readonly 변수를 통해 값을 참조하는 것보다 빠를 수 밖에 없다.<br>하지만 이를 통해 얻을 수 있는 성능 개선 효과가 크지 않고 무엇보다 유연성을 해치는 단점이 있다. 
- 컴파일할 때 사용되는 상숫값을 정의할 때는 반드시 const를 사용해야 한다. 특성 (Attribute)의 매개변수, switch/case 문의 레이블, enum 정의 시 사용되는 상수 등은 컴파일시에 사용돼야 하므로 반드시 const를 통해 초기화 되어야 한다. 

## 아이템3. 캐스트보다는 is, as가 좋다


## 아이템4. string.Format()을 보간 문자열로 대체하라
- 보간 문자열의 특징
<br>- C# 6.0에 도입된 기능
<br>- 컴파일 시점에 정적 타입 검사를 수행한다.
<br>* string.format()은 runtime에서 예외가 발생할 수 있다.
<br>- 보간 문자열 내에 보간 문자열을 중첩해서 사용 가능하다.
<br>- LINQ 쿼리에서도 사용 가능하다. 
- _실제로 사용해 봤을 때도 string.format 보다는 편리하게 느껴졌다. 하지만 대응되는 변수의 값이 너무 길 경우에는 기존 코드의 가독성을 해치는 경우가 있어서 string.format이 더 펀려힐 때도 있었다._


## 아이템5. 문화권 별로 다른 문자열을 생성하려면 FormattableString을 사용하라
- 보간 문자열 '$'를 사용할 때 특정 문화권에 대응되면 문자열을 사용해야 할 때가 있다.
- 보간 문자열의 리턴 값은 string 또는 FormattableString의 객채로 만들어 진다. 
- var를 사용해서 보간 문자열을 사용한다면, 컴파일러는 특정 조건에 기준하여 이를 판단한다. 
- FormatableString을 사용하려면, FormatableString 타입만 파라미터로하는 함수를 사용해서 처리해야 한다. (43page 예제 참조)

## 아이템9. 박싱과 언박싱을 최소화 하라
정의
- 박싱: 값 타입의 객체를 타입이 정해져있지 않은 임의의 참조타입 내부에 포함시키는 방법
   - 익명의 참조타입이 힙에 생성되고 값 타입은 이 참조타입 내에 저장된다
- 언박싱: 박싱되어 있는 참조 타입의 객체로부터 값 타입의 객체의 복사본을 가져오는 방법

박싱과 언박싱은 자동으로 이뤄진다. System.Object 같이 참조타입을 요구하는 곳에 값 타입을 사용하면 컴파일러는 자동으로 박싱과 언박싱을 수행하는 코드를 작성한다

예시 코드 - 박싱
   ```c#
   int i = 25;

   //1. 보간문자 사용
   Console.WriteLine($"{i}");

   //2. 박싱 사용
   object o = i; // 박싱
   Console.WriteLine(o.ToString());
   ```

예시 코드 - 언박싱
   ```c#
   object firstParm = 5;
   object o = firstParm;
   int i = (int)o; //  언박싱
   string output = i.ToString();
   ```

