package com.example.demo.samochod;

public class Komponent {
    private String nazwa;
    private double waga;
    private double cena;
    public Komponent(String nazwa, int waga, int cena) {
        this.nazwa = nazwa;
        this.waga = waga;
        this.cena = cena;
    }

    public String getNazwa(){
        return nazwa;
    }

    public double getWaga(){
        return waga;
    }
    
    public double getCena(){
        return cena;
    }

}
