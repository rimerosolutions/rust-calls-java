import org.graalvm.nativeimage.IsolateThread;
import org.graalvm.nativeimage.c.function.CEntryPoint;
import org.graalvm.nativeimage.c.type.CCharPointer;
import org.graalvm.nativeimage.c.type.CTypeConversion;
import org.graalvm.word.Pointer;

public class HelloApi {

  @CEntryPoint(name="print_hello")
  public static void printHello(@CEntryPoint.IsolateThreadContext long isolateId) {
    System.out.println("Hello World");
  }

}
