Step 1 - using 2번 사용
```c#
public void ExecuteCommand(string connString, string commandString)
{
    using(SqlConnection myConnection = new SqlConnection(connString))
    {
        using(SqlCommand mySqlCommand = new SqlCommand(commandString, myConnection))
        {
            myConnection.Open();
            mySqlCommand.ExecuteNonQuery();
        }
    }
    
}
```

Step 2 - Try/finally 2번 사용

```c#
public void ExecuteCommand(string connString, string commandString)
{
    SqlConnection myConnection = null;
    SqlCommand mySqlCommand = null;

    try
    {
        myConnection = new SqlConnection(connString);

        try
        {
            mySqlCommand = new SqlCommand(commandString, myConnection);

            myConnection.Open();
            mySqlCommand.ExecuteNonQuery();
        }
        catch
        {
            mySqlCommand?.Dispose();
        }
    }
    catch
    {
        myConnection?.Dispose();
    }
}
```


Step 2 - ILDASM
```c#
.method public hidebysig instance void  ExecuteCommand(string connString,
                                                       string commandString) cil managed
{
  // 코드 크기       61 (0x3d)
  .maxstack  2
  .locals init ([0] class [System.Data]System.Data.SqlClient.SqlConnection myConnection,
           [1] class [System.Data]System.Data.SqlClient.SqlCommand mySqlCommand)
  IL_0000:  nop
  IL_0001:  ldarg.1
  IL_0002:  newobj     instance void [System.Data]System.Data.SqlClient.SqlConnection::.ctor(string)
  IL_0007:  stloc.0
  .try
  {
    IL_0008:  nop
    IL_0009:  ldarg.2
    IL_000a:  ldloc.0
    IL_000b:  newobj     instance void [System.Data]System.Data.SqlClient.SqlCommand::.ctor(string,
                                                                                            class [System.Data]System.Data.SqlClient.SqlConnection)
    IL_0010:  stloc.1
    .try
    {
      IL_0011:  nop
      IL_0012:  ldloc.0
      IL_0013:  callvirt   instance void [System.Data]System.Data.Common.DbConnection::Open()
      IL_0018:  nop
      IL_0019:  ldloc.1
      IL_001a:  callvirt   instance int32 [System.Data]System.Data.Common.DbCommand::ExecuteNonQuery()
      IL_001f:  pop
      IL_0020:  nop
      IL_0021:  leave.s    IL_002e
    }  // end .try
    finally
    {
      IL_0023:  ldloc.1
      IL_0024:  brfalse.s  IL_002d
      IL_0026:  ldloc.1
      IL_0027:  callvirt   instance void [mscorlib]System.IDisposable::Dispose()
      IL_002c:  nop
      IL_002d:  endfinally
    }  // end handler
    IL_002e:  nop
    IL_002f:  leave.s    IL_003c
  }  // end .try
  finally
  {
    IL_0031:  ldloc.0
    IL_0032:  brfalse.s  IL_003b
    IL_0034:  ldloc.0
    IL_0035:  callvirt   instance void [mscorlib]System.IDisposable::Dispose()
    IL_003a:  nop
    IL_003b:  endfinally
  }  // end handler
  IL_003c:  ret
} // end of method Program::ExecuteCommand

```

Step 3 - try/finally 1번 사용
```c#
public void ExecuteCommand(string connString, string commandString)
{
    SqlConnection myConnection = null;
    SqlCommand mySqlCommand = null;

    try
    {
        myConnection = new SqlConnection(connString);
        mySqlCommand = new SqlCommand(commandString, myConnection);

        myConnection.Open();
        mySqlCommand.ExecuteNonQuery();
    }
    catch
    {
        mySqlCommand?.Dispose();
        myConnection?.Dispose();
    }
}
```
