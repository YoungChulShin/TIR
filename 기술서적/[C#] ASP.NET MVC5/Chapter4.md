# 4장. 필수 언어 기능

### 인터페이스에 확장 메서드 적용하기
Before
```c#
// 모델 클래스
public class ShoppingCard 
{
    public List<Product> Products { get; set; }
}

// 익스텐션 메서드
public static class MyExtensionMethod
{
    public static decimal TotalPrices (this ShoppingCard cartParam)
    {
        decimal total = 0;
        foreach (Product prod in cardParam.Products)
        {
            total += prod.Price;
        }

        return total;
    }
}

// 사용
ShoppingCart cart = new ShoppingCart{ ... }
cart.TotalPrices();
```

After
```c#
// 모델 클래스
public class ShoppingCart : IEnumerable<Product>
{
    public List<Product> Products { get; set; }

    public IEnumerator<Product> GetEnumerator()
    {
        return Products.GetEnumerator();
    }

    IEnumerator IEnumerable.GetEnumerator()
    {
        return GetEnumerator();
    }
}

// 익스텐션 메서드
public static class MyExtensionMethod
{
    public static decimal TotalPrices(this IEnumerable<Product> productEnum)
    {
        decimal total = 0;
        foreach (Product prod in productEnum)
        {
            total += prod.Price;
        }

        return total;
    }
}

// 사용
IEnumerable<Product> products = new ShoppingCard {...}
Product[] productArray = {...}

products.TotalPrices();
productArray.TotalPrices();
```

**Product 개체들의 컬렉션을 생성하는 방식과는 무관하게 확장메서드로 부터 동일한 결과를 얻을 수 있다**

IEnumerable<Product>를 사용함으로써 추가 확장 함수도 사용 가능
```c#
public static IEnumerable<Product> FilterByCategory(
            this IEnumerable<Product> productEnum, string categoryParam)
{
    foreach (Product prod in productEnum)
    {
        if (prod.Category == categoryParam)
        {
            yield return prod;
        }
    }
}
```