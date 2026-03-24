import java.io.*;
import java.math.*;
import java.security.*;
import java.text.*;
import java.util.*;
import java.util.concurrent.*;
import java.util.regex.*;



public class Task5 {
    public static void main(String[] args) throws IOException {
        BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(System.in));
        
        System.out.println("N must be a number that fit between 2 and 20");
        int N = Integer.parseInt(bufferedReader.readLine().trim());
        if(N>=2 && N<=20){
            for(int i=1;i<=10;i++){
                System.out.println(N+"x"+i+"="+ (N*i));
            }
        }else{
            System.out.println("Wrong number");
            return;
        }
            bufferedReader.close();
        }

    }

