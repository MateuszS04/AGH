package com.example.demo.samochod;

public class Sprzeglo extends Komponent {
    private boolean stanSprzegla;

    public Sprzeglo(String nazwa, int waga, int cena ){
        super(nazwa, waga, cena);
        stanSprzegla=false;
    }


    public void wcisnij(){
        stanSprzegla=true;
    }
    public void zwolnij(){
        stanSprzegla=false;
    }
    public boolean stanSprzegla(){
        return stanSprzegla;
    }
}
