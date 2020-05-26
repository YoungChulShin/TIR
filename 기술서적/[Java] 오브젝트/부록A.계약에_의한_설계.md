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

