```c#
public class MyBase
{

}

public interface IMessageWriter
{
    void WriteMessage();
}

public class MyDerived : MyBase, IMessageWriter
{
    void IMessageWriter.WriteMessage() => Console.WriteLine("Inside MyDerived.WriteMessage");
}

public class AnotherType : IMessageWriter
{
    public void WriteMessage() => Console.WriteLine("Inside Another Type.WriteMessage");
}

class Program
{
    static void WriteMessage(MyBase d)
    {
        Console.WriteLine("Inside WriteMessage(MyBase)");
    }

    static void WriteMessage<T>(T obj)
    {
        Console.Write("Inside WriteMssage<T>(T): ");
        Console.WriteLine(obj.ToString());
    }

    static void WriteMessage(IMessageWriter obj)
    {
        Console.Write("Inside WriteMessage(IMessageWriter): ");
        obj.WriteMessage();
    }

    static void Main(string[] args)
    {
        MyDerived d = new MyDerived();
        WriteLine("Calling Program.WriteMessage");
        WriteMessage(d);
        WriteLine();

        WriteLine("Calling through IMessageWriter interface");
        WriteMessage((IMessageWriter)d);
        WriteLine();

        WriteLine("Cast to base object");
        WriteMessage((MyBase)d);
        WriteLine();


        WriteLine("Another type test:");
        AnotherType anObject = new AnotherType();
        WriteMessage(anObject);
        WriteLine();

        WriteLine("Cast to IMessageWriter");
        WriteMessage((IMessageWriter)anObject);

    }
}
```