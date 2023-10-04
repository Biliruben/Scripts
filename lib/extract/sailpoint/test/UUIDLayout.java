package sailpoint.test;

public class UUIDLayout {
    
    /*
     * 
positions 0-8: Hexadecimal representation (hexrep) of the system ip address
8-16: hexrep of the jvm's system time at startup right-shifted 8 bits:
   System.currentTimeMillis() >>> 8
16-20: hiTime
20-28: loTime: hi- and loTime  are hexreps of the system time at generation. 
hiTime is the timestamp right shifted 32 bits while the loTime is the current
time, but coerced to an integer.  This part is interesting in that this
coercion could cause a loss of accuracy.  However, I've already seen that the
duplication always happens within <500ms of each other and so I'm tempted to
rule out integer coercion of a long as a factor.
28-32: a static short counter that rolls over to 0 after hitting the maximum. 
The value is incremented in a sychronized code block within the 'getter'
method, so it doesn't seem possible for two threads of one JVM to get the same
counter value.
     */

    // The Masks (All F's means not terribly meaningful)
    public static long sys_ip  = 0xFFFFFFFFL;
    public static long jvm_time  = 0xFFFFFFFFL;
    public static long time_hi   = 0xFFFFL;
    public static long time_low  = 0xFFFFFFFFL;
    public static long counter   = 0xFFFFL;
    
    
    
    /**
     * @param args
     */
    public static void main(String[] args) {
        if (args == null || args.length != 1) {
            throw new RuntimeException("Need a single argument of a hexidecimal UUID");
        }
        // 8a0b8b083ff63a4b 013ff6414abe025e
        String id = args[0];
        System.out.println("id = " + id);
        System.out.println("------------------------------------------");
        String ipStr = id.substring(0, 8);
        System.out.println("ipStr = " + ipStr);
        long actualSysIp = sys_ip & Long.parseLong(ipStr, 16);
        
        String jvmStr = id.substring(8, 16);
        System.out.println("jvmStr = " + jvmStr);
        long actualJvmTime = jvm_time & Long.parseLong(jvmStr, 16);
        
        String timeHiStr = id.substring(16, 20);
        System.out.println("timeHiStr = " + timeHiStr);
        long actualTimeHi = time_hi & Long.parseLong(timeHiStr, 16);
        
        String timeLowStr = id.substring(20, 28);
        System.out.println("timeLowStr = " + timeLowStr);
        long actualTimeLow = time_low & Long.parseLong(timeLowStr, 16);
        
        String countStr = id.substring(28, 32);
        System.out.println("countStr = " + countStr);
        long actualCounter = counter & Long.parseLong(countStr, 16);
        System.out.println("------------------------------------------");
        System.out.println("actualSysIp = " + actualSysIp + " (where each octect is converted to a short and then hexadecified)");
        System.out.println("actualJVMTime = " + actualJvmTime + " (where the system time is shifted 8 bits and cast to integer");
        System.out.println("actualTimeHi = " + actualTimeHi);
        System.out.println("actualTimeLow = " + actualTimeLow);
        System.out.println("actualCounter = " + actualCounter);
    }

}
