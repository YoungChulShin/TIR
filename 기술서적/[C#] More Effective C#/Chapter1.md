# 데이터 타입
## 아이템1: 접근 가능한 데이터 멤버 대신 속성을 사용하라
아직토 타입의 필드를 public으로 선언한다면 그만두는 게 좋다. get이나 get 메서드를 직접 작성하고 있었다면 이 역시 그만두자. 

### 속성 특징
- 데이터 필드에 접근하는 것처럼 실행되면서도 메서드가 주는 이점을 그대로 취할 수 있다
- 향후 요구 사항이 변경되어 코드를 수정해야 하는 경우에도 용이하다
    ```c#
    public class Customer 
    {
        private string name;
        public string Name
        {
            get => name;
            set
            {
                // 처리 로직  <- 수정 포인트
                name = value;
            }
        }
    }
    ```
- 속성은 메서드로 구현되므로 멀티스레드도 쉽게 지원할 수 있다
    ```c#
    public class Customer 
    {
        private object syncHandle = new object();

        private string name;
        public string Name
        {
            get
            {
                lock(syncHandle)
                    return name;
            } 
            set
            {
                // 처리 로직  <- 수정 포인트
                lock(syncHandle)
                    name = value;
            }
        }
    }
    ```
- `virtual`로도 선언 가능하다
- `interface`를 정의할 때도 사용 가능하다
- `get`/`set`의 접근 한정자를 다르게 지정해서 데이터의 노출방식을 다양하게 제어할 수 있다
- `indexer`를 사용할 수 있다
    ```c#
    // 정의
    public int this[int index]
    {
        get => theValues[index];
        set => theValues[index] = value;
    }
    private int[] theValues = new int[100];

    // 접근
    int val = someObject[i];
    ```

    ```c#
    // 정의
    public Address this[string name]
    {
        get => addressValues[name];
        set => addressValues[name] = value;
    }
    private Dictionary<string, Address> addressValues;
    ```
- 암묵적 속성 문법 (get;set;)을 이용하면 코드를 줄일 수 있다
- 데이터 바인딩을 사용할 수 있다
   - 데이터 바인딩을 할 때 대상 값이 public 데이터 필드이면 안된다. 클래스 라이브러리의 설계자가 public 데이터 멤버를 사용하는 것을 나쁜 예로 간주하고, 속성을 사용하도록 설계했기 때문이다. 

### 필드를 속성으로 바꿀 때 고려사항
- 데이터 멤버와 속성은 소스 수준에서는 호환성이 있지만 바이너리 수준에서는 전혀 호환성이 없다
   - 속성은 데이터가 아니므로 C# 컴파일러는 멤버에 접근할 때와는 다른 중간언어를 생성한다
   - 이런 이유로 public 데이터 멤버를 public 속성으로 수정하면, 데이터 멤버를 사용하는 모든 코드를 다시 컴파일 해야 한다. 
- 속성이 데이터 멤버보다 빠르지는 않지만 그렇다고 크게 느리지도 않다
   - JIT 컴파일러는 속성 접근자를 포함하여 일부 메서드 호출코드를 인라인화 하곤 한다. 인라인화 되면 데이터 멤버를 사용했을 때와 성능이 같아지며, 설사 인라인화 되지 않더라도 함수 하나를 덤으로 호출하는 정도이므로 무시할 만하다. 
   - 하지만 속성을 사용하는 코드는 마치 데이터 필드에 접근하는 것처럼 보이므로 성능면에서 큰 차이를 보여서는 안된다. 따라서 속성 접근자 내에서는 시간이 오래 걸리는 연산이나 DB 쿼리 같은 작업을 수행해서는 안된다. 이는 사용자가 기대하는 일관성이 결여된다. 

### 정리
- public이나 protected로 데이터를 노출할 때는 항상 속성을 사용하라
- Sequence나 Dictionary를 노출할 때는 인덱서를 사용하라
- 모든 데이터 멤버는 예외 없이 private으로 선언하라.


## 아이템2: 변경 가능한 데이터에는 암묵적 속성을 사용하는 것이 낫다
### 암묵적 속성(implicit Property) 특징
- 개발자의 생산성과 클래스의 가독성을 높인다
- 명시적 속성과 동일한 접근자 지원
- 향후 데이터 검증을 위해서 암묵적 속성을 명시적 속성으로 구현부를 추가해도 클래스의 바이너리 호환성이 유지된다
    ```c#
    // Original
    public string FirstName {get; set;}

    // Update
    private string firstName;
    public string FirstName
    {
        get => firstName;
        set
        {
            if (string.IsNullOrEmpty(value))
                throw new ArgumentNullException("First name cannot be null or empty");

            firstName = value;
        }
    }

    ```
- 데이터 검증 코드를 한 군데만 두면 된다 (=속성의 장점)
- _Serializable 특성을 사용한 타입에는 사용할 수 없다_

## 아이템3: 값 타입은 변경 불가능한 것이 낫다
### 불변 타입 (Immutable Type)
- 한번 생성된 후에는 그 값을 변경할 수 없는 타입
- 변경 불가능한 타입으로 객체를 생성할 때 매개변수를 검증했다면, 그 객체의 상태는 항상 유효하다고 할 수 있다
- 생성 후에 상태가 변경되지 않기 때문에 불필요한 오류 검증을 줄일 수 있다
- 멀티스레드에 대해서도 안전하다
   - 여러 스레드가 동시에 접근해도 내부 상태를 변경할 수 없으므로 항상 동일한 값에 접근한다

### 모든 타입을 변경 불가능한 타입으로 만드는 것은 매우 어렵다
이번 아이템은 `원자적으로 상태를 변경하는 타입` 과 `변경 불가능한 타입`에 적용할 수 있다

`원자적으로 상태를 변경하는 타입`
- 다수의 연관된 필드로 구성된 객체이지만, 하나의 필드를 수정하면 다른 필드도 함께 수정해야 하는 타입
- 예) 주소: 이사를 했을 때 `시`, `도`, `군` 과 같은 정보를 바꿨는데, `우편번호`를 변경하지 않으면 이 객체는 잘못된 정보를 가지게 된다
- 반대 예) 고객: `주소`, `이름`, `전화번호` 등으로 구성되어 있다고 할 때, 각각의 값들은 독립적이어서 `주소`를 바꾼다고 해서 `이름`이 같이 변경되어야하 하는 것은 아니다

### 코드 예시
변경 가능한 주소 코드
```c#
// 구현
public struct Address 
{
    private string state;
    private int zipCode;

    public string City {get;set;}
    public string State
    {
        get => state;
        set
        {
            ValidateState(value);
            state = value;
        }
    }
    public int ZipCode
    {
        get => zipCode;
        set 
        {
            ValidateState(value);
            zipCode = value;
        }
    }
}

// 사용
Address a1 = new Address();
a1.City = "서울";
a1.State = "송파구";
a1.ZipCode = 7777777;
// 변경 -> 이사를 갔다
a1.City = "부산"; // 아직 Zip, State가 유효하지 않다
a1.State = "북구"; // State가 유효하지 않다
a1.ZipCode = 0000000; // 정상
```

발생할 수 있는 문제
- 멀티스레드 환경에서 `City` 값을 변경 후에 `State`, `ZipCode`가 변경되기 전에 다른 스레드로 Context Switch가 되면 잘못된 값을 참조할 수 있다
- 우편번호가 유효하지 않은 경우 예외를 던진다고 하면, 주소의 일부가 변경된 상태라 시스템이 불완전한 상태가 된다
- 2경우 모두 동기화 코드를 사용해서 막을 수 있지만 추가 작업 및 코드량이 증가한다

변경 불가능한 타입으로 변경
```c#
// 구현
public struct Address
{
    public string City { get; }
    public string State { get; }
    public int Zip { get; }

    public Address(string city, string state, string zip) : this()
    {
        City = city;
        ValidateState(state);
        State = state;
        ValidateZip(zip);
        Zip = zip;
    }
}

// 사용
Address a1 = new Address("서울", "송파구", 7777777);
a1 = new Address("부산", "북구", 0000000);
```

- 기존 처럼 주소를 수정하다가 잘못된 임시 상태에 놓이는 일은 일어나지 않는다

### 변경 불가능한 타입 내에 변경 가능한 참조 타입 필드가 있을 경우
예: 배열 
- 변경 불가능한 타입에 참조타입의 배열이 있으면 이를 통해서 내부 상태를 변경할 수 있다
- `ImuutableArray` (System.Collections.Immutable) 로 변경해준다

### 변경 불가능한 타입을 초기화 하는 방법
1. 생성자를 정의
   ```c#
   Address a1 = new Address("서울", "송파구", 7777777);
   ```
2. 구조체를 초기화하는 Factory Method를 만드는 것
   ```c#
   Color color = Color.FromKnownColor(KnownColor.AliceBlue);
   Color color2 = Color.FromName("Yellow");
   ```
3. 불변 타입의 인스턴스를 단번에 만들 수 없을 때는 변경 가능한 동반 클래스를 만들어 사용할 수 있다. 
   ```charp
   StringBuilder stringBuilder = new StringBuilder();
   stringBuilder.Append("Hello");
   stringBuilder.Append("World");
   string helloWorld = stringBuilder.ToString();
   ```

### 정리
- 변경 불가능한 타입은 작성하기가 쉽고 관리가 용이하다
- 무작성 속성에 get, set 접근자를 만들지 말자
- 데이터를 저장하기 위한 타입이라면 변경 불가능한 원자적 값 타입으로 구현하자

## 아이템4: 값 타입과 참조 타입을 구분하라
### 선택 기준
- 값 타입
   - 다형성이 없으므로 애플리케이션이 사용하는 데이터를 저장하는 데 적합하다
   - 구조체(Struct)는 데이터를 저장한다
- 참조 타입
   - 다형성을 지니므로 애플리케이션의 동작을 정의할 때 사용해야 한다
   - 클래스(Class)는 동작을 정의한다

### 값 타입과 참조타입의 등장 배경
- C++에서는 모든 것이 값으로 전달. 여기에는 한가지 문제가 있는데 부분 복사
   - 베이스 객체가 요구되는 곳에 파생 객체를 넘긴다면 베이스 부분만 복사
- 자바에서 모든 사용자 정의 타입은 참조타입
   - 일관적이라는 장점이 있지만, 성능을 저하시키는 요인이 된다

### 사용 예시
```c#
private MyData myData;
public MyData Foo() => myData;

// 호출
MyData v = Foo();
TotalSum += v.Value;
```
- MyData가 값 타입이라면 v의 고유 저장소에 복사
- MyData가 참조 타입이라면 myData를 가리키는 참조를 반환한다
   - 호출자가 API를 우회하여 객체를 변경할 수 있음을 뜻한다
- public 메서드나 속성을 통해 데이터를 외부로 노출하는 경우는 가능한 값 타입을 사용하는 것이 좋다

```c#
public MyType myType;
public IMyInterface Foo3() => myType as IMyInterface;

// 호출
// 반환된 객체의 내부데이터에 접근하는 것이 아니라, 사전 정의된 인터페이스를 통해서 메서드를 호출한다
IMyInterface iMe = Foo3();  
iMe.DoWork(); 
```
- 값 타입은 값을 저장하고, 참조 타입은 동작을 정의한다는 예
- 클래스로 정의된 참조타입은 복잡한 동작을 정의할 수 있는 당야한 매커니즘 (예: 상속)을 지원한다

(메모리 할당 차이는 생략)

### 데이터를 저장하는 것 이외에 추가적인 동작을 정의한다면 참조 타입을 선택한다
값 타입은 객체 지향에서 말하는 객체라기 보다는 저장소 컨테이너라고 생각하는 것이 좋다
- 메모리 관리 면에서 효율적
   - 힙 조각화를 줄이고, GC와 간접 참조도 줄어든다
   - 데이터 자체를 복사해 준다
- 외부에 노출 위험이 없고, 예상치 못한 상태 변화가 일어날 가능성이 매우 낮다
- 상속 관계를 만들 수 없고, 인터페이스를 사용할 수 있지만 박싱이 필요해서 성능 저하가 일어난다

### 판단 기준
아래의 질문에 모두 '예'라고 답할 수 있다면 값 타입을 사용하는 것이 맞다
1. 주요 용도가 데이터 저장인가?
2. 변경 불가능하게 만들 수 있는가?
3. 크기가 작을 것으로 기대하는가?
4. public 인터페이스가 데이터 멤버 접근용 속성뿐인가?
5. 자식 클래스를 절대 갖지 않는다고 확신하는가?
6. 다형성이 필요한 일은 없을 것으로 확신하는가?

그런데도 쓰임새를 예상하기 어려운 경우라면 우선 참조 타입을 사용하자

## 아이템5: 값 타입에서는 0이 유효한 상태가 되도록 설계하라
### 요약
- 값 타입에서는 모든 객체를 0으로 초기화 한다. 이를 막을 수는 없기 때문에 0이 기본값이 되도록 설계하는 것이 좋다.
- 특별한 사례로 Flags를 사용하는 Enum에서는 0을 어떤 플래그도 설정하지 않았음을 뜻하는 값으로 정의해야 한다

### Enum Type
- 열겨형에서는 반드시 0을 유효한 값으로 선언해야 한다
   ```c#
   public enum Planet
   {
      Mercury = 1,
      Venus = 2
   }

   // 사용
   Planet planet = new Planet(); // 0 => 유효한 값이 아니다
   Planet anotherPlanet = default(Planet); // 0 => 유효한 값이 아니다
   ```
- `Planet`이 다른 타입의 필드로 사용될 경우에도 문제가 발생할 수 있다. Struct는 기본 생성자를 가질 수 있기 때문에 Planet 변수가 `0`으로 초기화 될 수 있다.<br>
이런 경우라면 0을 `초기화 되지 않았음`을 뜻하는 의미로 사용하고 나중에 원하는 값으로 수정을 유도하자.
   ```c#
   public struct OvservationData
   {
       Planet planet;
       double magnitude;
   }

   public enum Planet
   {
      None = 0,
      Mercury = 1,
      Venus = 2
   }
   ```
- Planet을 사용하는 구조체가 None에 대해서 문제가 되는 것으로 판단을 한다면, `OvservationData`를 기본 생성자가 없는 class로 바꾸는 것도 하나의 방법이다. 
- 열겨형을 Flags로 사용할 때에는 None을 0으로 설정하는 것이 좋다
   - 예: 비트 And 연산자를 할 때 0으로 인해서 문제가 될 수 있다

### String
- 문자열의 경우 초기 값은 null이다
- Struct일 경우 강제로 초기화 할 수 있는 방법은 없지만, 속성을 통해서 빈 문자열로 반환하도록 할 수 있다
   ```c#
   public struct LogMessage
   {
       private int ErrLevel;
       private int msg;
       public string Message
       {
           get => msg ?? string.Empty;
           set => msg = value;
       }
   }
   ```

## 아이템 6: 속성을 데이터처럼 동작하게 만들라
### 요약
- 사용자들은 속성이 메서드와는 다르게 동작할 것이라 기대한다
   - 속성이 메서드보다 빠르다
   - 동작방식도 데이터 필드와 동일하다
- 이러한 기대에 부합하도록 속성을 만들 수 없다면 차라리 해당 작업을 별도의 메서드로 제공하고 public 인터페이스를 수정하는 편이 낫다
- 속성은 **객체의 상태를 보여주는 원래의 용도**로만 사용하자

### 속성 작성 
- 다른 변경사항이 없다면 `get` 접근자를 반복해서 호출할 때 늘 같은 값을 반환해야 한다
   - 멀티스레드 환경에서는 다를 수 있다
- `get` 접근자가 너무 많은 작업을 수행하지 않도록 하고, `set` 접근자는 유효성 검증 정도의 작업만 처리하도록 하는 것이 좋다
   ```c#
   for (int index = 0; index < myArray.Length; index++)
   ```
- `get` 접근자에서 간단한 작업만을 수행하고 있지만, 혹시 그 작업도 부담이 될 경우(=성능저하)는 캐싱을 적용할 수도 있다
   ```c#
   // As-Is
   public int X { get; set; }
   public int Y { get; set; }
   public double Distance => Math.Sqrt(X * X + Y * Y);

   // To-Be
   private int xValue
   public int X 
   {
        get => xValue; 
        set 
        {
            xValue = value;
            distance = default(double?);    // 캐싱 초기화
        }
   }
   // Y 생략
   private double? distance;
   public double Distance
   {
       get
       {
           if (!distance.HasValue)
           {
               distance = Math.Sqrt(X * X + Y * Y);
           }
           return distance.Value;
       }
   }
   ```
- `get` 접근자가 값을 반환하는데 시간이 오래 걸린다면 public interface 를 다시 생각해봐야 한다
    - public interface를 통해서 함수로 분리하는 방식
- 원격 DB에서 데이터를 가져오거나 변경 내용을 다시 저장하는 경우에는 속성 보다는 작업 내용을 잘 표현하는 이름으로 메서드를 작성하는 것이 사용자의 기대에 더 부합할 수 있다. 
   ```c#
   public class MyType
   {
       public void LoadFromDatabase() { } 
       public void SaveToDatabase() { }

       public string ObjectName{ get; set; }
   }
   ```

## 아이템 7: 튜플을 사용해서 타입의 사용 범위를 제한하라
### 요약
- `익명 타입(=anonymous type)`이나 `튜플 타입(=tuple type)`은 인스턴스 구문에서 새롭게 정의되는 **경량 타입**
   - c#에서 제공하는 사용자 정의 타입: 클래스, 구조체, 튜플 타입, 익명 타입
- 데이터를 저장하지만, 동작을 포함하지 않는 타입을 간단히 정의하고 싶다면 둘 중 하나를 사용할 수 있다
- 제대로 사용하면 가독성을 해치지 않는다
- 중간 결과를 저장해야하고, 변경 불가능한 타입과 궁합이 잘 맞는다면 익명 타입을 사용하고, 중간 결과가 독립적으로 변경 가능해야 한다면 튜플을 사용하자

### 익명 타입
- 구현
   ```c#
   var point = new { X = 5, Y = 6 };
   ```
- 컴파일러가 생성하는 변경 불가능한 타입
   - 내부적으로는 sealed 클래스를 생성하고, X, Y에 대한 get 속성 및 생성자 초기화 코드를 만들어준다
   - 컴파일러가 생성해주기 때문에 쉽게 작성 가능하고, 코드에 오류가 없으며, 관리할 코드의 양이 줄어든다
- 타입의 이름을 알 수 없음으로 매개변수 전달이나, 반환값 타입으로 사용할 수 없다
   - Generic 메서드를 이용해서 처리 가능
   ```c#
   static T Transform<T>(T element, Func<T, T> transformFunc)
   {
       return transformFunc(element);
   }

   var anotherPoint = Transform(point, (p) => new { X = p.X * 2, Y = p.Y * 2});
   ```
- 중간 결과를 저장하기에 안성맞춤이다
- 범위는 그것을 정의한 메서드 내로 제한된다 
   - Namespace를 더럽히지 않을 수 있다
- 객체 초기화 구문을 지원하는 변경 불가능한 타입을 만드는 유일한 방법이다
   - 직접 코드를 만들 때는 변경 불가능하므로 Set접근자가 없을 것이고, 그렇기 때문에 객체초기화 구문을 지원할 수 없다
- 런타임 비용이 크지 않다. -> 컴파일러 최적화로 똑같은 익명 타입을 요청하면 이전에 만든 타입을 재사용한다
   - 동일 어셈블리 내에 선언
   - 속성 이름, 타입 그리고 순서가 일치해야 한다

### 튜플 (System.ValueTuple)
- 구현
   ```c#
   var point = (X: 5, Y: 6);
   var anotherPoint = point;   // anotherPoint는 X, Y 필드 이름을 가진다
   (int Rise, int Run) pointThree = point;   // pointThree는 Rise, Run을 필드 이름으로 가진다
   ```
- public 필드를 포함하는 변경 가능한 타입이라는 점에서 익명 타입과 차이가 있다
- `구조적 타이핑(structural typing)`
   - c#에서는 일반적으로 객체간의 타입 호환성을 확인하기 위해서 타입의 이름을 사용한다. 이를 `이름 기반 타이핑 (nominative typing)`이라고 한다
   - 튜플에서는 구조적 타이핑을 사용하는데, 형태를 확인해서 타입이 같은지 확인한다
      - 위 예시에서 point는 `System.ValueTuple<int,int>` 형태이다

### 선택
- 튜플은 구조적 타이핑을 따르므로 메서드의 반환 타입이나 매개변수 타입으로 사용하기에 적합하다
- 익명타입은 변경 불가능한 타입을 정의할 때나, 컬렉션의 복합키로 사용하기 좋다
- 튜플은 값 타입의 장점을 모두 가지는 반면, 익명 타입은 참조타입이 가지는 장점을 모두 가진다