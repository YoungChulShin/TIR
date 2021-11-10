### 책 정보
- 저자: 김민장

### 1. 프로그래머가 프로세서도 알아야 해요?
- 프로세서
   - 흔히 CPU라는 표현을 자주 쓴다. 그러나 명확하게 말하면 현대 CPU는 하나의 집적회로로 만들어진 마이크로 프로세서로 표현하는 것이 더 바람직하다
- 집적회로
   - Intergrated Circuit; IC
   - 특정 기능을 수행하는 전기회로와 반도체 소자(주로 트랜지스터)를 하나의 칩에 모아 구현한 것

### 2. 프로세서의 언어: 명령어 집합구조
- 레지스터
   - 컴퓨터가 계산을 하기 위해 필수적으로 필요한, 작은 용량이지만 매우 빠른 임시 기억 장치를 가리킨다
   - 현대 컴퓨터는 모든 계산을 메모리에서 레지스터로 값을 옮겨온 후에 해야 한다. 
- ISA
   - Instruction Set Architecture
   - 기계어 명령어 집합 구조
- Instruction
   - 프로세서가 이해하는 명령어 하나하나
- 예시: 4바이트 정수 변수 A에 상수 7을 더해 다시 A에 쓰라
   - x86 코드: add dword prt [A], 0x07
   - C 코드: *ptrA = *ptrA + 7
   - add: 더하다
   - dword: double word. x86에서는 4바이트
   - prt [A]: A의 주소값. (&a)
   - 0x07: 7

- CISC
   - Complex Instruction Set Computer
   - 예: 인텔의 x86, DEC의 VAX(Virtual Adress Extention)
   - 명령어의 길이가 주로 가변적이며, 여러 복잡한 형태의 주소 모드를 지원
   - 범용 레지스터(General Purpose Register, GPR)의 개수가 비교적 작다
   - x86 32비트는 EAX, EBX와 같은 레지스터로 8개만 제공한다

- RISC
   - Reduced Instruction Set Computer
   - 기존에 CISC를 사용해보니 실제로 사용하는 명령어의 종류는 그렇게 많지 않다는 것을 확인.<br>
   명령어 크기를 고정하고, 그 개수를 대폭줄인 RISC가 탄생
   - 예: ARM, IBM의 Power PC, MIPS (Microprocessor without Interlocked Pipeline Stage)

- opcode: operation code, 어떤 명령어인가를 기술하는 옵코드
- RISC와 CISC의 차이
   - RISC의 경우 CISC에 비해서 명령어가 매우 직관적이고, 분석이 쉽다 (=32비트 고정이기 때문).<br>하지만 이러한 점 때문에 CISC가 간단히 처리할 수 있는 것도 단계적으로 처리해야하는 단점이 있다
   - 설계의 차이
      - CISC는 컴퓨터 프로그램의 복잡함을 하드웨어가 도맡아 처리한다. 복잡한 수학 함수를 지원하기도하고 메모리 주소를 바로 피연산자로 받을 수도 있다. 과거 프로그래머들이 x86으로 작업을 많이 했기 때문에 이런 기능은 유용했다
      - RISC는 하드웨어의 복잡함을 일부 소프트웨어, 컴파일러로 넘겼다. 이제는 기계어로 프로그래밍 하는 경우는 드물기 때문에 굳이 ISA에 많은 명령어를 제공할 필요가 없게 되었다<br>
      대신 하드웨어의 복잡함을 줄여서 성능향상에 투자할 수 있었다.<br>
      대표적으로 RISC의 범용 레지스터 개수는 CISC보다 많다. x86은 8개 x86-64는 16개만 지원하지만 대부분 RISC 구조는 32개 이상의 레지스터를 제공한다. 

- 간단한 기계어 해석
   1. RISK - ARM
      - ldr: Load
      - mov: move
      - str: store
      - mul: mulication
      - add: add
      - sp: Stack pointer
      - ldr r1, [sp, #4]: r1레지스터에 스택포인터로부터 4바이트 떨어진 곳에 있는 값을 저장하라
   2. CISC - x86
      - rsp: stack pointer (r은 64비트라서 붙은 값, e는 32비트)
      - imul: 정수의 곱셈
      
   - 동일 코드를 CISC와 RISC로 작성해 보면 CISC가 프로그램의 크기가 작다. 대신 해독이 더 복잡하다

### 3. 프로세서의 기본 부품과 개념들
마이크로아키텍쳐
- 프로세서를 만드는데도 여러 방법론이 있다
- 마이크로프로세서 하나를 만드는데 필요한 알고리즘 및 회로 수준의 구조를 자세히 정의하는 것
- 마이크로를 뜻하는 'u'를 따서 uarch라고 부르기도 한다
- 대표적인 마이크로아키텍쳐
   - 인텔 펜티엄 프로의 P6구조

마이크로프로세서 설계 단계
1. 마이크로아키텍쳐 설계
   - RTL(Register-Transfer Level) 
2. 로직 설계
   - HDL(Hardware Description Language)

산술 논리 장치 (Arithmetic Loggcal Unit)
- 정의: 
