package com.example.demo.samochod;

public class SkrzyniaBiegow extends Komponent{
    private int aktualnyBieg;
    private int iloscBiegow;
    private double aktualnePrzelozenie;
    private Sprzeglo sprzeglo;

    public SkrzyniaBiegow(Sprzeglo sprzeglo, int iloscBiegow,int cena,int waga, String nazwa){
        super(nazwa,waga,cena);
        this.sprzeglo = sprzeglo;
        this.iloscBiegow = iloscBiegow;
        this.aktualnePrzelozenie = 0;
        this.aktualnyBieg =0;
    }

    public void zwiekszBieg(){
        if(aktualnyBieg>=iloscBiegow){
            System.out.println("max Bieg");
        }
        sprzeglo.wcisnij();
        aktualnyBieg++;
        aktualnePrzelozenie++;
        sprzeglo.zwolnij();
    }

    public void zmniejszBieg(){
        if(aktualnyBieg==0){
            System.out.println("the lowest gear");
        }
        sprzeglo.wcisnij();
        aktualnyBieg--;
        aktualnePrzelozenie--;
        sprzeglo.zwolnij();

    }
    public int getAktBieg(){
        return aktualnyBieg;
    }

    public double getAktPrzelozenie(){
        return aktualnePrzelozenie;
    }
   
    public void uruchamianie(){
        sprzeglo.wcisnij();
        aktualnyBieg=0;
    }

    public void wylaczanie(){
        sprzeglo.wcisnij();
        aktualnyBieg=1;
    }

}
