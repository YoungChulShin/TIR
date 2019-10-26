# 3장. WPF 애플리케이션 생성
## 3.4 단순 컨트롤
### 기본 컨트롤
종류
- TextBlock
- TextBox
- ProgressBar
- Slider
- PasswordBox
### 멀티미디어 컨트롤
종류
- Image: 그림 표시
- MediaElement: 동영상 표시
   ```c#
   <Image Source="Images/main.PNG" Height="200" Stretch="Uniform"/>
   ```

WPF는 장치 독립적 픽셀로 제공된다. 하나의 픽셀은 약 0.5밀리미터다. 즉 50은 화면에서 2.5센티를 나타낸다. 

### 그리기 컨트롤
종류
- Ellipse: 타원
- Rectangle: 사각형
- Path: 경로?

### 콘텐츠 컨트롤
종류
- Button
   - Button
   - ToggleButton
   - CheckBox
   - RadioButton 
- Border
- ScrollViewer
- ViewBox
   - ViewBox에 들어가는 Control의 크기를 조절 가능하다. (Stretch 속성 이용)

복잡한 콘텐츠를 지정해야 하는 경우에는 Content 요소를 사용하는 대신 하위 요소를 콘텐츠 컨트롤에 제공할 수 있다. 
   ```xml
   <Button>
      <CheckBox IsChecked="True">
         <TextBlock Text="test"/>
      </CheckBox>
   </Button>
   ```

## 3.5 탐색
각 화면은 Page이고, Page는 Frame 내부에 표시된다. 

1. 코드에서 탐색
   ```c#
   NavigationService.Navigate(new Uri("Location", UriKind.Relative));
   ```

2. XAML에서 탐색
   ```xml
   <Label>
      <Hyperlink NavigateUri="Location">
         Pay Now
      </Hyperlink>
   </Label>
   ```

## 3.9 XAML 이해
### XAML Namespace
- c#코드에서 using과 비슷한 개념
- WPF 컨트롤: http://schemas.microsoft.com/winfx/2006/xaml/presentation
- XAML 키워드: http://schemas.microsoft.com/winfx/2006/xaml 

### 객체 생성
네임스페이스 맵핑
- xmlns:접두어="clr-namespace:네임스페이스명;assembly:어셈블리명"
- 예시: xmlns:local="clr-namespace:BikeShop.Pages"

### 속성 정의
C# Code에서 Object를 생성하고 속성을 정의하는 것 처럼, XAML에서도 적용 가능

   ```c#
   public class Car
   {
      public int Speed { get; set; }
      public Color Color { get; set; }
   }
   ```

   ```xml
   <Label>
      <car:Car Speed="100" Color="Beige" />
   </Label>
   ```

### 명명 규칙
x:name 속성을 사용해서 명명 가능

Code에서 'InitializeComponent()' 호출은 'XAML 상태에 대한 수행'을 의미한다.

## 3.10 이벤트

## 3.13 레이아웃
WPF는 컨트롤의 자식, 부모에 의해 제약된 크기를 조회하고 마지막에 컨트롤 자체의 Width, MinWidth 또는 MaxWidth 속성을 확인한다. 부모 제한 크기는 자식 필수 크기보다 우선이고, Width 속성은 부모나 자식의 값보다 우선한다. 

### Canvas
- Canvas 컨트롤은 자식 크기를 제한하지 않기 때문에, Button을 하위에 정의하면 Button이 Canvas를 벗어날 수 있다
- Canvas.Left, Canvas.Top으로 자식 컨트롤의 위치를 정의
   ```xml
   <Canvas>
      <Button Canvas.Top="0" Canvas.Left="0">A</Button>
      <Button Canvas.Top="25" Canvas.Left="0">B</Button>
      <Button Canvas.Top="25" Canvas.Left="25">C</Button>
      <Button Canvas.Top="0" Canvas.Left="500">C</Button>
   </Canvas>
   ```

### StackPanel
- Orientation 제어를 사용해서 Stack 과 같이 컨트롤르 쌓을 수 있다
- 기본적으로 자식 컨트롤은 StackPanel에 맞게 지정되지만, HorizontalAlignment 또는 VertialAlignment를 통해서 크기를 조정가능하다
   ```xml
   <StackPanel Orientation="Vertical">
      <Button>A</Button>
      <Button>B</Button>
      <Button>C</Button>
      <Button>D</Button>
   </StackPanel>
   ```

### DockPanel
- 데스크탑 애플리케이션과 같은 화면 레이아웃을 빠르게 얻을 수 있다
   ```xml
   <DockPanel>
      <Button DockPanel.Dock="Left" Content="Left" />
      <Button DockPanel.Dock="Right" Content="Right" />
      <Button DockPanel.Dock="Top" Content="Top" Height="30"/>
      <Button DockPanel.Dock="Bottom" Content="Bottom" />
      <Button Content="Takes waht's left" Height="100"/>
   </DockPanel>
   ```

### UniformGrid
- Grid의 Columns 속성을 이용해서 자동으로 필요한 컨트롤의 행과 열을 계산
   ```xml
   <UniformGrid Columns="2">
      <Label>Name</Label>
      <TextBox Width="70" />
      <Label>Age</Label>
      <ComboBox />
   </UniformGrid>
   ```

### Grid
- RowDefinition, ColumnDefinition을 통해서 레이아웃 정의 가능하다
- Grid는 컨트롤은 자식 크기를 제한하기 때문에, Button을 하위에 정의하면 Grid에 맞게 너비가 지정된다
- 컨트롤은 Grid.RowSpan 및 Grid.ColumnSpan 연결 속성을 이용해서 몇개의 열이나 행을 채울 수 있다
- Width, Height 속성
   1. 고정 숫자: 열/행에 픽셀의 수가 할당
   2. Auto: 열/행이 자체 콘텐츠에 대한 크기로 적용
   3. 별 또는 별이 붙은 숫자: 남은 높이/너비에 비례한 비율로 지정된다

   ```xml
   <Grid>
      <Grid.ColumnDefinitions>
            <ColumnDefinition Width="30" />
            <ColumnDefinition Width="*" />
            <ColumnDefinition Width="2*" />
            <ColumnDefinition Width="auto" />
      </Grid.ColumnDefinitions>
      <Button Grid.Column="0">0</Button>
      <Button Grid.Column="1">1</Button>
      <Button Grid.Column="2">2</Button>
      <Button Grid.Column="3">3</Button>
   </Grid>
   ```

## 3.14 목록 컨트롤
### 선택 컨트롤
- ListBox, ComboBox
   ```xml
   <ListBox Height="150">
      <Label>Element 1</Label>
      <Label>Element 2</Label>
      <GroupBox Header="Element3">
            With some contents
      </GroupBox>
      <Label>Element 4</Label>
   </ListBox>
   
   <ComboBox>
      <Label>Element 1</Label>
      <Label>Element 2</Label>
      <GroupBox Header="Element3">
            With some contents
      </GroupBox>
      <Label>Element 4</Label>
   </ComboBox>
   ```

# 4장. WPF 애플리케이션에서 데이터 관리
## 4.1 데이터 바인딩
- WPF에서는 Binding을 처리하는 XAML 코드를 통해서 동일한 동작을 C# code로 작성할 때에 비해서 더 짧고 직관적으로 처리 가능하다
   ```xml
   <StackPanel>
      <Slider Maximum="100" Value="10" x:Name="slider" />
      <ProgressBar Value="{Binding Value, ElementName=slider}"/>
      <TextBox Text="{Binding Value, ElementName=slider}"/>
      <TextBox Text="Yellow" x:Name="color" />
   </StackPanel>
   ```
- 바인딩 모드

   |모드|대상 변경|값 변경|
   |--|--|--|
   |TwoWay|Yes|Yes|
   |OneWay|No|Yes|
   |OneWayToSource|Yes|No|
   |OneTime|No|No|

## 4.3 변환기
- XAML 엔진은 데이터 바인딩 시 객체 유형을 반환하는 작업을 수행한다
- IValueConverter를 이용해서 확장 가능하다
   ```c#
   public class TwiceConverter : IValueConverter
   {
      public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
      {
         double colorValue = double.Parse(value.ToString());
         if (colorValue > 10)
         {
               return Colors.Red;
         }
         else if (colorValue >= 4 && colorValue <= 10)
         {
               return Colors.Green;
         }
         else
         {
               return Colors.Yellow;
         }
      }

      public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
      {
         return null;
      }
   }
   ```
## 4.4 목록 컨트롤을 사용하는 컬렉션 표시
c# 코드
```c#
var cars = new List<Car>();
for (int i = 0; i < 10; i++)
{
      cars.Add(new Car()
      {
         Speed = i * 10,
         Color = Colors.Red
      });
}

this.DataContext = cars;
```
XAML 코드
```xml
<ListBox ItemSource="{Binding}" />
```

하지만 이렇게 하면 ListBox에 표시할 방법이 정해져있지 않기 때문에 ToString으로 표시가 된다. 결국 Class명이 표시된다

## 4.5 목록 컨트롤 사용자 정의
사용자 정의 속성
- ItemPanel: 요소를 배치하는 방법 설명. 항목 레이아웃
- ItemTemplate: 각 요소에 대해 반복이 필요한 템플릿을 제공한다. 각 항목의 모양
- ItemContainerStyle: 항목을 선택하거나 마우스를 올릴 때의 동작 방법을 설명
- Template: 컨트롤 자체를 렌더링하는 방법을 설명한다. 목록 주위(테두리, 배경, 스크롤바)

```xml
 <ListBox ItemsSource="{Binding}">
   <ListBox.ItemTemplate>
         <DataTemplate>
            <StackPanel>
               <TextBlock Text="Speed" />
               <TextBox Text="{Binding Speed}" />
               <Slider Value="{Binding Speed}" Maximum="100" />
               <TextBlock Text="Color" />
               <Border Height="10">
                     <Border.Background>
                        <SolidColorBrush Color="{Binding Color}" />
                     </Border.Background>
               </Border>
               <TextBox Text="{Binding Color}"/>
            </StackPanel>
         </DataTemplate>
   </ListBox.ItemTemplate>
</ListBox>
```

## 4.8 INotifyPropertyChanged
컨트롤을 통해 사용자가 속성을 업데이트 하면 동일한 속성에 바인딩된 다른 컨트롤이 작성된 코드가 전혀 없어도 업데이트 된다. 그러나 코드 자체로 인해 속성이 변경되면 해당 속성에 바인딩된 컨트롤이 업데이트 되지 않는다. 이런 종류의 시나리오가 작동하려면 속성이 변경되기 시작할 때 이벤트를 발생시켜야 한다. 

속성 변경 이벤트는 INofityProperyChanged 이벤트로 대응 가능하다

```c#
public class Notifier : INotifyPropertyChanged
{
   public event PropertyChangedEventHandler PropertyChanged;

   protected void OnPropertyChanged (string propertyName)
   {
      PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
   }
}
```

## 5장. 빛나게 만들기 모양 사용자 정의
### 5.1 컨트롤 모양 변경
Template 속성
- 모든 WPF 컨트롤은 Template 속성이 있다
- 컨트롤에 새로운 모양을 제공하라면 ControlTemplate 인스턴스를 속성에 할당해야 한다
- 예시
   ```xml
    <Button Content="Press me" Background="DarkSalmon"  >
      <Button.Template>
            <ControlTemplate TargetType="{x:Type Button}">
               <Grid>
                  <Ellipse Fill="{TemplateBinding Background}" Width="100" Height="100" />
                  <Label Content="{TemplateBinding Content}" 
                           HorizontalAlignment="Center" 
                           VerticalAlignment="Center" />
               </Grid>
            </ControlTemplate>
      </Button.Template>
   </Button>
   ```
- TargetType 속성은 ControlTemplate이 Button에 적용된 다는 것을 알 수 있다

TemplateBinding
- ControlTemplate만 적용하면, Control에 적용한 값이 반영되지 않는다. 이를 반영하기 위해서는 TemplateBinding을 사용해서 ControlTemplate 항목에 할당해줘야 한다
- 예시
   ```xml
   <Button Grid.Column="1" Grid.Row="1" Margin="5" Content="Send">
      <Button.Template>
            <ControlTemplate TargetType="Button">
               <Grid>
                  <Ellipse Fill="#AA000000" Margin="10,10,0,0" />
                  <Ellipse Fill="{TemplateBinding Background}" Margin="0,0,10,10" />
                  <Viewbox Margin="5,5,15,15">
                        <ContentPresenter />
                  </Viewbox>
               </Grid>
            </ControlTemplate>
      </Button.Template>
   </Button>
   ```
### 5.4 리소스
리소스
- 애플리케이션 전체에서 사용가능한 XAML을 구현. 최상단의 public static 개념인듯?
- 저장 위치
   - 화면: 페이지, 사용자 정의 컨트롤 같이 단일 화면으로 범위가 지정된 리소스
   - 애플리케이션: App.xaml에 선언된 Application요소와 같이 애플리케이션 전반에 걸쳐 사용되는 리소스
- 예시
   ```xml
   <Application.Resources>
      <LinearGradientBrush x:Key="background">
         <GradientStop Color="#FFDBFFE7" Offset="0" />
         <GradientStop Color="#FF03882D" Offset="1" />
      </LinearGradientBrush>
   </Application.Resources>
   ```

   ```xml
   
   ```
### 5.7 스타일
스타일
- 다중 속성 설정자로 생각하면 된다. (=Multi property setters)
- 하나의 컨트롤에 여러개의 속성을 정의할 때 리소스를 사용한다면 n번 설정해야하는 것을 스타일을 이용하면 하나의 스타일에 n개의 리소스를 설정 가능하다
- App.xml에 구현 가능
   ```xml
   <Style x:Key="niceButton" TargetType="Button">
      <Setter Property="Width" Value="50" />
      <Setter Property="Height" Value="50" />
      <Setter Property="Background">
            <Setter.Value>
               <LinearGradientBrush>
                  <GradientStop Color="Red" />
                  <GradientStop Color="Yellow" Offset="1" />
               </LinearGradientBrush>
            </Setter.Value>
      </Setter>
   </Style>
   ```

암시적 스타일
- 앞에서 설명한 스타일이 명시적이라면 암시적 스타일을 키를 사용하지 않는다. 그리고 그 범위가 스타일을 선언하는 범위에 한정된다
- 암시적으로 선언된 스타일은 해당 범위안에 있는 컨트롤에 별도로 Key를 선언하지 않아도 자동으로 반영 된다
- 예시
   ```xml
   <Window.Resources>
      <Style TargetType="Button">
         <Setter Property="Width" Value="50" />
         <Setter Property="Height" Value="50" />
         <Setter Property="Background">
               <Setter.Value>
                  <LinearGradientBrush>
                     <GradientStop Color="Red" />
                     <GradientStop Color="Yellow" Offset="1" />
                  </LinearGradientBrush>
               </Setter.Value>
         </Setter>
      </Style>
   </Window.Resources>
   ```

컨트롤에 리소스를 적용하는 방법
1. 해당 컨트롤에 직접 정의
2. 해당 페이지에만 영향을 미치도록 정의: 암시적 스타일
3. 솔루션 전역 위치에 정의: App.xaml에 정의. 명시적 스타일


### 5.11 변형
WPF에서는 컨트롤을 쉽게 변경,회전 또는 기울일 수 있다. 

변경을 위한 속성에는 RenderTransform 및 LayoutTransform 이 있다
1. RenderTransform
   - 필요한 크기를 계산할 때 변환을 고려하지 않는다
   - 따라서 컨트롤을 회전했을 때 겹쳐일 수 있다
   - 더 자주 사용
2. LayoutTransform
   - 필요한 크기를 계산할 때 변환을 고려한다

### 5.13 애니메이션
애니메이션
- 상태를 이용하면 쉽게 애니메이션 생성이 가능하지만, 상태는 컨트롤의 최종 상태에 집중하기 때문에 전환을 여러 단계로 변경하고자 할 때에는 애니메이션을 만들어서 대응 가능하다
- 애니메이션은 StoryBoard를 사용해서 만들 수 있다

Blend for visual studio
- 애니메이션을 XAML로 작성하는 방법도 있지만, Blend를 이용하면 쉽게 생성 가능하다

## 6. WPF MVVM 패턴
### 6.1 스파게티 코드
코드와 디자인 이벤트가 함께 구현되어 있는 소스 코드
- 예: Winforms의 Code behind
- 문제점
   - 거대한 파일을 만들어내고 유보수 하기가 갈수록 어렵다
   - 테스트가 어렵다. 컨트롤과 논리적코드가 많이 섞여 있기 때문에 테스트를 하려면 UI를 인스턴스화 해야 한다
   - 재사용이 어렵다. 

### 6.2 MVC
MVC
- 뷰: 순수 XAML
- 모델: InotifyPropertyChanged 및 INotifyCollectionChanged를 구현하는 클래스
- 컨트롤러: 명령, 트리거, 관련 이벤트, NavigationService

SOC
- Separation of Concerns

### 6.3 MVVM
DataModel
- 비니지스 클래스
- UI에 제공된 데이터를 가지고 있다

View
- UI
- 이상적으로 View는 순수 XAML로 구성
- View는 자동화된 테스트를 사용해 테스트가 어렵기 때문에 View의 코드양을 줄여야 하는 이유다

ViewModel
- 하나의 뷰에 대한 메소드로 속성 및 액션을 사용해 데이터를 노출한다
- View를 참조하지 않아야 하지만 View에 크게 의존
- 단위 테스트를 쉽게 할 수 있다
- INotifyPropertyChanged를 구현한다
- 단순한 클래스. 각 화면당 하나의 ViweModel은 좋은 출발점이다
- 명명은 클래스의 이름에 + ViewModel로 하면 좋다

구현 순서
1. ViewModel을 생성
2. ViewModel이 공개해야 하는 속성과 메소드를 찾는다
3. 알림 속성(Property)를 선언하고 공용 메소드를 추가한다 (=ViewModel를 구현)
   ```c#
   private double speed;
   public double Speed
   {
      get
      {
         return speed;
      }
      set
      {
         speed = value;
         OnPropertyChagned("Speed");
         OnSpeedChanged();
      }
   }

   private void OnSpeedChanged()
   {
      // 기능 코드 추가
   }
   ```
4. ViewModel의 View를 DataContext로 사용한다
5. View를 ViewModel 속성에 데이터 바인딩한다
6. View에 VieeModel 메소드를 호출하는 트리거를 추가한다
7. 기능적 논리를 코딩한다

### 6.9 MVVM 프레임워크
종류
- Prism
- MVVM Light
- Caliburn.Micro

# 오타
- p.38: Strike -> Stroke
- p.114: Static/Resouce -> StaticResouce
- View ? 뷰? 용어 혼재
