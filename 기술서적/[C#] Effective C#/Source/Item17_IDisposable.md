```c#
public class MyResourceHog : IDisposable
{
    private bool alreadyDisposed = false;

    // IDisposable을 구현
    public void Dispose()
    {
        Dispose(true);
        GC.SuppressFinalize(this);
    }

    protected virtual void Dispose(bool isDisposing)
    {
        if (alreadyDisposed)
        {
            return;
        }

        if (isDisposing)
        {
            // 관리 리소스를 정리
        }

        // 비 관리 리소스를 정리

        alreadyDisposed = true;
    }
}

public class DerivedResourceHog : MyResourceHog
{
    private bool disposed = false;

    protected override void Dispose(bool isDisposing)
    {
        if (disposed)
        {
            return;
        }

        if (isDisposing)
        {
            // 관리 리소스 제거
        } 

        // 비 관리 리소스 정리

        base.Dispose(isDisposing);

        disposed = true;
    }
}
```