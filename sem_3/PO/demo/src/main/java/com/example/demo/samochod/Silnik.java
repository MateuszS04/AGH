package com.example.demo.samochod;

public class Silnik extends Komponent {
    private double maxObroty=8000;
    private double obroty;


    public Silnik(double maxObroty, double obroty, String nazwa,int cena, int waga) {
        super(nazwa,cena, waga);
        this.maxObroty=maxObroty;
        this.obroty=obroty;

    }

    public void uruchom(){

        obroty = 1000;
    }
    public void zatrzymaj(){

        obroty=0;
    }
    public void zwiekszObroty(){
        if(obroty<maxObroty){
            obroty+=100;
        }else{
            obroty=maxObroty;
            System.out.println("za wysokie obroty, zmień bieg");
        }
    }
    public void zmniejszObroty(){
        if(obroty>800){
            obroty-=100;
        }else {
            zatrzymaj();
            System.out.println("silnik zgasł, za niskie obroty");
        }
    }

}
