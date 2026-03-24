public class CodingBat{
    public String BackAround(String str){
        String last =str.substring(str.length()-1);
        return last + str + last;
    }
    public boolean SleepIn(boolean weekday, boolean vacation){
        if(!weekday|| vacation){
            return true;
        }
        return false;
    }
    public int diff21(int n){
        if(n<21){
            return 21-n;
        }
        return(n-21)*2;
    }
    public int CountHi(String str){
        int count=0;
        for(int i=0; i<str.length()-1;i++){
            if(str.charAt(i)=='h' && str.charAt(i+1)=='i'){
                count++;
            }
        }
        return count;
    }

    public boolean XyzThere(String str){
        for(int i=0; i<str.length()-2;i++){    
            if(str.substring(i,i+3).equals("xyz")){
                if(i==0||str.charAt(i-1)!='.'){
                    return true;
                }
            }
        }
        return false;
    }

    public static void main(String[] args){
        CodingBat codingBat = new CodingBat();
        System.out.println(codingBat.BackAround("cat"));
        System.out.println(codingBat.SleepIn(false,false));
        System.out.println(codingBat.diff21(7));
        System.out.println(codingBat.CountHi("hi hello hi"));
        System.out.println(codingBat.XyzThere("abc.xyzxyz"));
    }
}