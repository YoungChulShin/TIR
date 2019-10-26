## Item 45. 메서드가 실패했음을 알리기 위해서 예외를 이용하라
### 예외 이용의 장점
메서드가 요청된 작업을 제대로 수행할 수 없는 경우 예외를 발생시켜 실패가 발생했음을 알려야 한다. 
1. 오류 코드를 이용하면 사용자가 이를 무시할 수 있다
2. 오류를 보고하는 매커니즘의 관점에서 오류를 보고하는 방식보다 예외를 이용하는 방식이 장점이 더 많다
   - 반환 코드는 원형에 영향을 미치고, 추가적인 정보를 제공하기 어렵다
   - 클래스 타입의 경우는 필요시 사용자 정의 예외를 만들어서 추가적인 정보를 제공할 수 있다
3. 에러의 세부정보를 잃지 않을 수 있다
4. 예외는 무시하기 어렵다

단, 다른 개발자가 사용할 라이브러리를 작성할 경우에는 런타임에 발생하는 예외는 상당히 값비싸고 개발자가 이에 대응하는 코드를 작성하는 것이 쉽지 않다. 이 경우는 개발자가 try/catch 블록을 작성하지 않고도 메서드가 정상 수행될 수 있는지를 확인할 수 있는 API를 제공하는 것이 좋다.  

### 메서드의 기능
오류를 발생시키는 수단으로 예외를 사용하기로 결정했다고 하더라도 항상 예외를 통해서 오류를 보고해야 하는 것은 아니다.<br>
이는 메서드의 사용 목적에 따라서 달라질 수 있다. 
- 예: File.Exists(), File.Open()
    - File.Exists()는 목적이 파일의 존재 여부를 확인하는 것이기 때문에 파일이 없을 경우 예외가 아니라 그 자체가 성공의 결과가 될 수 있다
    - File.Open()은 목적이 파일을 읽는 것이기 때문에 실패할 경우 결과는 그대로 실패가 된다

이러한 차이는 메서드의 명명 방법에도 중대한 영향을 끼친다. 메서드의 이름은 메서드가 어떤 작업을 수행하는지를 명확하게 드러내도록 지어야 한다. 

### 예외를 발생시키는 메서드의 작성
예외를 발생시키는 메서드를 작성할 때에는 항상 예외를 유발하는 조건을 사전에 검사할 수 있는 메서드를 함께 작성하는 것을 권장한다. 

[As-Is]
```c#
// 구현
public void DoWork(){}

// 사용
try
{
   worker.DoWork();
}
catch (WorkerException e)
{
   ReportErrorToUser("XXXXX");
}
```
[To-Be]
```c#
// 구현
public bool TryDoWork()
{
   if (!TestCondtions())
   {
      return false;
   }

   Work();  // 여기서 예외가 발생될 수도 있다. 
            // 여기서 발생될 예외라서 발생시켜서 오류를 알리는 것이 좋다
   return true;
}
public void DoWork()
{
   Work();
}

private bool TestConditions()
{
   return true;
}
private void Work() {}

// 사용
if (!worker.TryDoWork())
{
   ReportErrorToUser("XXXXX");
}
```

### 정리
특정 메서드가 작업을 온전히 완료할 수 없을 경우 예외를 발생시킬지를 결정하는 것은 개발자의 몫이다. 하지만 오류가 발생하면 항상 예외를 발생시키도록 코드를 작성하는 것이 좋다. 다만 예외는 일반적인 흐름제어 메커니즘으로 사용해서는 안된다. 그리고 요청된 작업이 성공적으로 수행될 수 있을지를 사전에 테스트할 수 있는 메서드를 같이 제공하는 것이 좋다. 


## Item 46. 리소스 정리를 위해서 using과 try/finally를 활용하라
### 리소스 정리
관리되지 않는 리소스를 사용하는 모든 타입은 IDisposable 인터페이스를 반드시 구현해야 한다. 더불어 사용자들이 Dispose()를 호출하는 것을 잊어버린 경우를 대비하기 위해서 finalizer를 방어적으로 작성해야 한다. 

Dispose()를 호출해야 하는 객체를 사용할 경우 이를 보장하기 위한 방법은 아래 2가지이다. 
1. using 문을 사용하는 것 (가장 간단)
2. try/finally 문을 사용하는 것

using문을 사용할 경우 컴파일러가 try/finally로 변경하기 때문에 동일하다고 볼 수 있다.<br>
아래 두 코드는 IL 코드가 동일하다
```c#
SqlConnection myConnection = null;

// Using 사용
using(myConnection = new SqlConnection(connString))
{
   myConnection.Open();
}
// try/finally 사용
try
{
   myConnection = new SqlConnection(connString);
   myConnection.Open();
}
finally
{
   myConnection.Dispose();
}

```

### Object 타입의 Dispose()
using문은 IDisposable Interface를 지원하는 타입에 대해서만 사용할 수 있기 때문에 object 타입은 사용할 수 없다. 이 경우 `as`를 사용하면 안전한 코드를 작성 가능하다.

```C#
object obj = Factory.CreateResource();
using (obj as IDisposable)
{
   // Do dit
}
```

따라서 임의의 객체에 대해서 using 문을 사용할 수 있을지 확실치 않다면 IDisposable을 구현했을 거라 가정하고 앞의 코드와 같이 작성해주는 것이 좋다.

### 2개의 using 문
중첩된 using을 사용하는 경우에 대해서는 이러한 경우가 많이 없기 때문에 크게 문제되는 것은 없지만, 최적화된 코드는 아니기 때문에 try/finally 블록을 자체적으로 구현해주는 것도 좋은 방법이다. 

예시 코드 - [Link](https://github.com/YoungChulShin/DayByDay/blob/master/BookMemo/%EA%B8%B0%EC%88%A0%EC%84%9C%EC%A0%81/%5BC%23%5D%20Effective%20C%23/Source/Item46_DoubleUsing.md)


### Dispose() 와 Close()
일부 타입의 경우 Dispose()와 Close() 2개의 메서드를 제공하는 경우가 있다. 
- 예: SqlConnection

Dispose()
- 리소스 해제 작업 (이 시점에서 메모리에는 남아 있다)
- GC.SuppressFinalize()를 호출해서 가비지 수집기에게 이 객체에 대해서는 finalizer를 호출할 필요가 없음을 알리는 작업을 수행

Close()
- SqlConnection의 경우 연결을 닫는 작업
- finalizer에서 리소스가 해제된다
   - finalizer를 호출할 필요가 없음에도 finalizer 큐에 객체가 남게 된다
   - GC에 의해서 리소스가 해제될 때 1세대 늦게 메모리에서 제거된다

두 메서드를 모두 사용할 수 있다면, Dispose()를 호출하는 것이 좋다 (앞으로 더 사용을 안할 경우에)

    
## Item 47. 사용자 지정 예외 클래스를 완벽하게 작성하라
- 예외 클래스를 개발하는 개발자는 다른 에외와는 달리 별도의 조치가 필요하다고 생각되는 경우에만 추가적으로 예외 클래스를 만드는 것이 좋다. 그렇지 않으면 쓸모없는 예외 클래스를 만드는 꼴이 될 뿐이다. 
- 다시 말하지만 서로 다른 예외 클래스를 활용하여 예외를 발생시키는 유일한 이유는 catch문을 사용하여 예외를 다루는 코드를 작성할 개발자가 그 각각을 구분하여 서로 다른 작업을 수행할 수 있도록 해주기 위함이다. 따라서 에러가 발생한 시점에 복구 가능성을 염두해 두고 추가적인 정보를 담도록 예외 클래스를 작성하는 것이 좋다. 특정 파일이나 디렉터리가 존재하지 않는 경우 응용 프로그램을 복구할 수 있는가? 부적절한 보안 권한에 대한 문제는 복구 가능한가? 네트워크 접속이 불가능한 경우는? 이처럼 다른 작업이나 복구 메커니즘으로 이어질 가능성이 있는 오류가 발생한 경우라면 새로운 예외 클래스를 만들자. 
- ThirdParty Library에서 예외를 발생시킬 때, 이 정보를 InnerClass에 전달하면 더 많은 정보를 전달할 수 있다.<br>
이러한 기법을 예외 변환(Exception Translation)이라고 하는데, 저수준의 예외에 대해서 보다 세부적인 상태 정보를 포함하는 고수준의 예외로 변경하는 작업. 
   ```c#
   try
   {
      // third party action
   }
   catch (ThirdPartyException e)
   {
      var msg = $"Problem with {e.ToString()} using library";
      throw new DoingSomeWorkException(msg, e); // 예외를 매개변수로 전달
   }
   ```


## Item 48. 강력한 예외 보증을 준수하는 것이 좋다
- 데이브 에이브람스는 예외에 대한 보증을 기본 보증(basic guarantee), 강력한 보증(strong guarantee), 예외 없음 보증(no-throw guarantee) 세가지로 구분하여 정의 했다
1. 기본 보증 (basic guarantee)
   - 특정 함수 내에 발생한 예외가 이 함수를 빠져나오더라도 어떤 리소스도 누수되지 않으며, 모든 객체의 상태가 유효한 상태를 유지함을 의마한다. 이는 예외가 발생한 메서드 내에서 finally 구문이 구현되어 있음을 의미하는 것이기도 하다. 
2. 강력한 예외 보증 (strong guarantee)
   - 기본 보증에 더하여 예외 발생 시에도 프로그램의 상태가 변경되지 않음을 추가로 보증하는 것을 의미한다. 
   - 즉, 작업이 온전히 완료되거나 혹은 응용프로그램의 상태가 그대로 유지되거나 둘 중 하나의 경우만 가능해야 하며, 그 중간은 존재하지 않음을 의미한다. 
   - LINQ는 기본적으로 강력한 예외 보증 요건을 주수한게 된다. 
   - 데이터 수정 과정
      1. 방어적인 프로그램을 위해 수정할 데이터에 대한 복사본을 마련한다. 
      2. 복사해둔 데이터를 수정한다. 수정 과정에서 예외가 발생할 수도 있다. 
      3. 수정된 복사본과 원본 데이터를 교환한다. 이 교환 작업은 예외를 일이켜서는 안된다. 
   - 복사본을 만들지 않으면 일정 수준의 성능을 발휘할 수 있지만, 개인적으로는 크기가 큰 컨테이너 객체를 복사해야 하는 경우에도 가능하면 강력한 예외 보증을 준수하도록 복사본을 이요하는 방식을 선호한다. 
3. 예외 없음 보증 (no-throw guarantee)
   - 작업이 결코 실패하지 않으며 따라서 예외가 발생하지도 않음을 보증하는 것.
   - 예시
      1. finalizer
      2. Dispose()
      3. 예외 필터의 when 절
      4. 델리게이트 대상 메서드 
         - 멀티캐스트 델리게이트의 경우 메서드 중 하나가 예외를 일으키면 다른 대상 메서드가 호출되지 않는 문제가 있다. 

## Item 49. catch 후 예외를 다시 발생시키는 것보다 예외 필터가 낫다
- 예외 필터는 catch 문 이후에 when 키워드를 이용하여 구성하게 되는데 catch 문에 지정한 예외 타입에 대해서만 필터가 수행된다. 
- 명시적으로 새로운 예외 객체를 생성한 후 이 예외를 발생시키면 예외 발생 위치가 바뀌므로 그렇게 해서는 안된다.
- 스택되감기(Stack unwinding) 작업이나 catch 문의로의 진입과정은 수행 성능에 상당한 영향을 미친다. 예외 필터를 사용하면 스택 되감기와 catch 문의로의 진입 자체가 제한적으로 이뤄지기 때문에 성능이 개선되는 것이다. 최소한 성능이 나빠지지는 않는다. 
- when 절이 있으면 컴파일러는 스택 되감기를 수행하기 이전에 예외 필터를 수행하도록 코드를 생성한다. 

## Item 50. 예외 필터의 다른 활용 예를 살펴보라
- 예외에 대한 로그 처리시 유용하게 활용 가능하다
- 예시
   ```c#
   public static bool ConsoleLogException(Exception e)
   {
      WriteLine("Error: {0}", e);
      return false;  // 항상 False를 반환한다.
   }

   // 예시 1. 모든 상황에 대한 로그 처리
   try
   {
      data = MakeWebRequest();
   }
   catch (Exception e) when (ConsoleLogException(e))
   {
      // ConsoleLogException은 항상 False를 반환하기 때문에 Exception이 수행되지 않는다
      // 이렇게 되면 catch문에 진입하기 위한 비용을 줄이면서 모든 에러에 대해서 로깅이 가능하다. 
   }
   catch (TimeoutException e) when (failures++ < 10)
   {
      WriteLine("Timeout error: trying again");
   }

   // 예시 2. 특정 상황에 대한 로그 처리
   try
   {
      data = MakeWebRequest();
   }
   catch (TimeoutException e) when (failures++ < 10)
   {
      WriteLine("Timeout error: trying again");
   }
   catch (Exception e) when (ConsoleLogException(e))
   {
      // ConsoleLogException은 항상 False를 반환하기 때문에 Exception이 수행되지 않는다
      // 앞에서 처리되지 않은 예외에 대해서만 로그를 기록한다
   }
   ```
