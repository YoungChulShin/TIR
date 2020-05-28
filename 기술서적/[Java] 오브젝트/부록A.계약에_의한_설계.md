인터페이스로 부족한 점
- 인터페이스만으로는 객체의 행동에 관한 다양한 관점을 전달하기는 어렵다
- 여기서 `계약에 의한 설계`로 눈을 돌려보자.<br>
이를 이용하면 협력에 필요한 다양한 제약과 부수효과를 명시적을 정의하고 문서화 할 수 있다.

## 01. 협력과 계약
### 부수효과를 명시적으로 
인터페이스로 부족한 점을 한번 더!
- 객체지향의 핵심은 협력 안에서 객체들이 수행하는 행동이다
- 프로그래밍 언어로 작성된 인터페이스는 메시지의 이름과 파라미터 목록은 시그니처를 통해서 전달할 수 있지만, 협력을 위해 필요한 약속과 제약은 전달할 수 없기 때문에 협력에 대한 상당한 내용이 암시적으로 남게 된다

계약에 의한 설계 라이브러리를 이용하면, 명확하게 협력을 표현할 수 있다
- C#에서 제공하는 `Code Contracts`가 하나의 예시
- 문서화를 통해서 더 명시적으로 표현할 수 있다 (단순한 if 문과의 차이점)

### 계약
계약의 특성
- 각 계약 당사자는 계약으로부터 `이익`을 기대하고 이익을 얻기 위해 `의무`를 이행한다
- 각 계약 당사자의 이익과 의무는 계약서에 `문서화` 된다

리모델링 예시
- 작업 방식과 상관없이 리모델링 결과가 만족스럽다면 인테리어 전문가가 계약을 정상적으로 이행한 것으로 간주할 수 있다

그럼 이런 계약이라는 개념을 객체들이 협력하는 방식에도 적용할 수 있지 않을까? 라는 의문의 나온다

### 계약의 의한 설계
개념
- `"인터페이스에 대해 프로그래밍하라"`는 원칙을 확장한 것

오퍼레이션 시그니처
```c#
public Reservation reserve(Customer customer, int audienceCount) { ... }
```
- 알 수 있는 것
   - Customer 타입과 int 타입의 인자를 전달해야 한다
   - 성공하면 반환 타입으로 Reservation을 반환해야 한다
- 시그니처 만으로는 여기까지 알 수 있다
- 계약은 한단계 더 나아간다
   - `reserve` 를 호출할 때 클라이언트 개발자는 `customer`의 값으로 `null`을 전달할 수 없다
   - `audienceCount` 의 값은 1보다 크거나 최소한 같아야 한다
   - 만족하는 조건을 전달했따면 반환하는 `Reservation` 인스턴스는 `null`이 아니어야 한다
- 위 내용들은 시그니처 만으로는 알 수 없는 내용들이다

계약에 대한 설계를 구성하는 세가지 조건
1. 사전 조건(precondition)
   - 메서드가 호출되기 위해 만족돼야 하는 조건
   - 사전 조건을 만족시키는 것은 메서드를 실행하는 클라이언트의 의무다
2. 사후 조건(postcondition)
   - 메서드가 실행된 후에 클라이언트에게 보장해야 하는 조건
   - 사전 조건을 만족시키는 것은 서버의 의무다
3. 불변식(invariant)
   - 항상 참이라고 보장되는 서버의 조건
   - 실행 도중에는 불변식을 만족시키기 못할 수도 있지만 메서드를 실행하기 전이나 후에는 불변식은 항상 참이어야 한다

### 사전조건
샘플 코드 - 사전조건 정의 (`Contract.Requires`)
~~~c#
public Reservation Reserve(Customer customer, int audienceCount)
{
    Contract.Requires(customer != null);    // 사전조건을 정의
    Contract.Requires(audienceCount >= 1);  // 만족하지 못하면 ContractException 예외를 발생

    return new Reservation();
}
~~~

### 사후조건
용도
- 인스턴스 변수의 상태가 올바른지 확인하기 위해서 
- 메서드에 전달된 파라미터의 값이 올바르게 변경됐는지를 서술하기 위해
- 반환값이 올바른지를 서술하기 위해

사후조건을 정의하는 것이 어려운 이유
- 한 메서드에서 return 문이 여러 번 나올 경우
   - 모든 return 문마다 결과값이 올바른지 검증하는 코드가 추가되어야 한다
- 실행 전과 실행 후의 값을 비교해야 하는 경우
   - 메서드의 실행으로 값이 변경될 수 있기 때문에 비교에 어려움이 있을 수 있다

샘플 코드 #1 - 사후조건 정의 (`Contract.Ensures`)
~~~c#
public Reservation Reserve(Customer customer, int audienceCount)
{
    Contract.Requires(customer != null);
    Contract.Requires(audienceCount >= 1);

    Contract.Ensures(Contract.Result<Reservation>() != null);   // 사후조건 정의

    return new Reservation();
}
~~~

샘플 코드 #2 - 사후조건 이점
~~~c#
public int Test()
{
    // 여기에 사후조건을 정의하면서 분기문마다 코드를 정의하지 않아도 된다
    Contract.Ensures(Contract.Result<int>() >= 0);  

    if (a) 
    {
        return 999;
    }
    else
    {
        return 0;
    }
}
~~~

### 불변식
특성
- 불변식은 클래스의 모든 인스턴스가 생성된 후에 만족돼야 한다. 클래스에 정의된 모든 생성자는 불변식을 준수해야 한다는 것을 의미한다
- 불변식은 클라이언트에 의해 호출 가능한 모든 메서드에 의해 준수돼야 한다.<br>
메서드 실행 전과 종료 후에는 항상 불변식을 만족하는 상태가 유지왜야 한다

샘플 코드 #1 - 사후조건 정의
```c#
private Movie movie;
private int sequence;
private DateTime whenScreened;

[ContractInvariantMethod]
public void Invariant()
{
    Contract.Invariant(movie != null);
    Contract.Invariant(sequence >= 1);
    Contract.Invariant(whenScreened > DateTime.Now);
}
```

## 03. 계약에 의한 설계와 서브타이핑
계약에 의한 설계와 리스코프 치환원칙
- 서브타입이 리스코프 치환 원칙을 만족시키기 위해서는 클라이언트와 슈퍼타입 간에 체결된 계약을 준수해야 한다.<br>
(서브타입이 슈퍼타입을 대체해도 기존에 클라이언트와 슈퍼타입간의 계약을 계속 만족해야한다)

리스코프 치환원칙의 세분화
- 계약 규칙: 협력에 참여하는 객체에 대한 기대를 표현
   - 서브타입에 더 강력한 사전조건을 정의할 수 없다
   - 서브타입에 더 완화된 사후조건을 정의할 수 없다
   - 슈퍼타입의 불변식은 서브타입에서도 반드시 유지돼야 한다
- 가변성 규칙: 파라미터와 리턴 타입의 변형과 관련된 규칙
   - 서브타입의 메서드 파라미터는 반공변성을 가져야한다
   - 서브타입의 리턴 타입은 공변성을 가져야 한다
   - 서브타입은 슈퍼타입이 발생시키는 예외와 다른 타입의 예외를 발생시켜서는 안된다

### 계약 규칙
### 가변성 규칙

![a-1](/Images/오브젝트/a-1.png)

서브타입에 더 강력한 사전조건을 정의할 수 없다
- BasicRatePolicy에 RatePolicy보다 더 강한 사전 조건을 추가한다면?
   - Phone(클라이언트) 입장에서는 RatePolicy와 맺은 계약이 지켜지지 않는 것이기 때문에 계약 위반이 된다
   - 이는 리스코프 치환 원칙을 위반한다
   - 이는 BasicRatePolicy가 RatePolicy의 서브타입이 아니게 되는 것이다
- 사전조건을 보장해야 하는 책임은 클라이언트에게 있다
   - 클라이언트가 계약 내용을 보장해서 전달한 값이, 서버에서 설정된 더 강한 조건에 의해서 실패한다면 협력이 성사되지 않는다

서브타입에 더 완화된 사후조건을 정의할 수 없다
- calculateFee 오퍼레이션의 사후조건이 AdditionalRatePolicy에서 변경한다고 해보자
   - 기존: 반환값이 0보다 커야 한다
   - 변경: 해당 조건 제거
- 클라이언트 입장에서는 RatePolicy와 계약할 때 0보다 커야 한다는 조건이 있는데, 변경되는 계약으로 인해서 마이너스 값을 받을 수 있다. 이는 계약 위반이다.
- 서버가 계약을 위반했기 때문에, 클라이언트 입장에서 AdditionalRatePolicy는 더이상 RatePolicy가 아니다

반대로 서브타입에사 더 강화된 사후조건을 제시한다면?
- 이건 상관없다. Phone은 반환된 요금이 0보다 크다는 조건만 만족한다면 불만이 없을 것이기 때문이다.

슈퍼타입 불변식은 서브타입에서도 반드시 유지돼야 한다
- 샘플코드를 보자
    ~~~java
    public abstract class AdditionalRatePolicy implements RatePolicy {

        // 다음 요금제를 가리키는 next는 null이어서는 안된다
        // 따라서 AdditionalRatePolicy는 이 값이 null이 안된다는 불변식을 만족해야 한다
        // 현재는 protected로 선언되어 있기 때문에 자식클래스에서 변경 가능성이 존대한다
        protected RatePolicy next;

        // 생략
    }
    ~~~
- 어떻게 막을까?
   - `protected` 를 `private` 으로 변경한다
   - 부모클래스에 `protected` 로 next를 변경할 수 있는 함수를 제공하고, 여기서 불변식을 체크한다
   ~~~java
   protected void changeNext(RatePolicy next) {
       this.next = next;
       // 불변식
       assert next != null;
   }
   ~~~

### 가변성 규칙
서브타입은 슈퍼타입이 발생시키는 예외와 다른 타입의 예외를 발생시켜서는 안된다
- _지금까지 내용을 들어왔다면 당연한 이야기_
- 해당 예외가 부모클래스가 던지는 예외의 상속 계층의 예외라면 상관없다
- 클라이언트의 입장에서는 계약에 명시된 `A`라는 예외가 올 지 알고 준비하고 있는데, 갑자기 `B`라는 예외가 온다면 예외처리를 할 수 없을 것이기 때문이다
- 추가적인 변형도 존재한다
   1. 부모클래스에서 정의하지 않은 예외를 던지는 경우
   2. 예외를 던지지 않는 경우

서브타입의 리턴 타입은 공변성을 가져야 한다
- 공변, 반공변, 무공변부터 알아보자
   - `S`가 `T`의 서브타입이라고 하자. 이때 프로그램의 어떤 위치에서 두 타입 사이의 치환 가능성을 보면
   - 공변성(covariance)
      - `S`와 `T`사이의 서브타입 관계가 그대로 유지된다
      - 이 경우 해당 위치에서 서브타입인 `S`가 슈퍼타입인 `T` 대신 사용될 수 있다
      - 리스코프 치환 원칙이 공변성과 관련된 원칙이라고 생각하면 된다
   - 반공변성(contracovariance)
      - `S`와 `T`사이의 서브타입 관계가 역전된다
      - 슈퍼타입인 `T`가 서브타입인 `S` 대신 사용될 수 있다
   - 무공변성(invariance)
      - 둘 사이에 아무런 관계도 존재하지 않는다
      - 서로를 대신할 수 없다

- 예제 그럼
![a-1](/Images/오브젝트/a-2.png)
   - 배경
      - 지금까지 서브타이핑은 단순히 서브타입이 슈퍼타입의 모든 위치에 대체 가능하다는 것이다
      - 공변과 반공변의 영역으로 들어가기 위해서는 타입의 관계가 아니라 메서드의 리턴 타입과 파라미터 타입에 초점을 맞춰야한다
   - 리턴 타입 공변성
      ```java
      // Customer Class
      public class Customer {
         public void order(BookStall bookstall) {
            this.book = bookstall.sell(new IndependentPublisher())
         }
      }

      // 일반적인 구매 방법
      // 리턴 타입: Book
      new Customer().order(new BookStall());

      // MagazineStore는 BookStall의 서브타입이기 때문에 BookStall을 대신해서 협력할 수 있다
      // Customer가 Bookstall에서 책을 구매할 수 있으면, MagazineStore에서도 구매할 수 있다
      // 리턴타입: MagazineStore
      new Customer().order(new MagazineStore());
      ```
      - 위의 경우 sell 메서드의 return 타입이 `Book`에서 `MagazineBook`으로 변경되는데 Customer 입장에서는 동일하다
      - 부모클래스에서 구현된 메서드를 자신 클래스에서 오브라이딩할 때 부모 클래스에서 선언한 반환타입의 서브타입으로 지정할 수 있는 특성을 `리턴 타입 공변성` 이라고 한다
      - 리스코프 치환원칙과 함께 보면, 서브타입에서 메서드의 사후조건이 강화되어도 클라이언트 입장에서는 영향이 없다는 개념과 같다.<br>
      슈퍼타입 대신 서브 타입을 반환하는 것은 더 강력한 사후 조건을 정의하는 것과 같다. 

서브타입의 메서드 파라미터는 반공변성을 가져야한다
- MagazineStore의 `sell` 메서드 파라미터를 `Publisher`로 변경한다면 어떻게 될까?
- 예시 코드
   ```java
   public class MagazineStore extends Bookstall {
      @override
      public Magazine sell(Publisher publisher) {  // IndependentPublisher -> Publisher
         return new Magazine(publisher);
      }
   }

   // Customer의 `order` 메서드는 BookStall의 `sell` 메서드에 `IndependentPublisher` 인스턴스를 전달한다
   // BookStall 대신 MagazineStore 인스턴스와 협력한다면 `IndependentPublisher` 인스턴스가 MagazineStore의 파라미터로 전달된다
   ```
- `Publisher`가 `IndependentPublisher`의 슈퍼타입이기 때문에 문제가 없다
- 부모 클래스에서 구현된 메서드를 자식 클래스에서 오버라이딩 할 때 파라미터 타입을 부모 클래스에서 사용한 파라미터의 슈퍼타입으로 지정할 수 있는 특성을 `파라미터 타입 반공변성`이라고 부른다
- 리스코프 치환원칙에서 서브타입에서 사전조건이 약화되더라도 클라이언트 입장에서는 영향이 없다. <br>
연관지어보면 서브타입 대신 슈퍼타입을 파라미터로 받는 것은 더 약한 사후조건을 정의하는 것과 같다. <br>
_파라미터 입장에서는 더 약한 조건이 들어오는 건데, 약한조건이 들어와도 클라이언트 입장에서는 영향이 없으니까_

### 함수와 서브타이핑

파라미터 타입이 IndependentPublisher이고, Book인스턴스를 반환하는 sell 메서드
```scala
def sell(publisher:IndependentPublisher): Book = new Book(publisher)
```

위 함수를 이름을 통해 참조하거나 호출할 필요가 없다면?
```scala
(publisher:IndependentPublisher)=> new Book(publisher)
```

파라미터 타입과 리턴 타입을 이용해서 함수를 정의할 수 있다
```scala
// 'IndependentPublisher 타입을 받으면 Book을 리턴한다' 겠지?
IndependentPublisher => Book
```

Customer에 적용해보면
```scala
class Customer {
   var book: Book = null

   // BookStall 클래스를 정의하지 않고 함수형으로 선언
   def order(store: IndependentPublisher => Book): Unit = {
      book = store(new IndependentPublisher())
   }
}
```

이렇게 사용할 수 있다
```scala
// book이 리턴되겠지?
new Customer().order((publisher: IndependentPublisher) => new Book(publisher))
```

여기서도 서브타입 메서드가 슈퍼타입 메서드를 대체할 수 있을까? : 그렇다
```scala
new Customer().order((publisher: Publisher) => new Magazine(publisher))
```
- `IndependentPublisher` -> `Publisher`: 파라미터 타입의 반공변성
- `Book` -> `Magazine`: 리턴 타입의 공변성
- 따라서 `Publisher => Magazine` 타입은 `IndependentPublisher => Book` 의 서브타입이다



### 결론
진정한 서브타이핑 관계를 만들고 싶다면..
- 서브타입에 더 강력한 사전 조건을 정의해서는 안된다
- 서브타입에 더 완화된 사후조건을 정의해서는 안된다
- 슈퍼타입의 불변식을 유지하기 위해 항상 노력해야 한다
- 서브타입에서 슈퍼타입에서 정의하지 않은 예외를 던져서는 안된다