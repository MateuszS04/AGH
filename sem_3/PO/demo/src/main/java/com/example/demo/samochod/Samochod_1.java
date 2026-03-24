package com.example.demo.samochod;

public  class Samochod_1 {
    private boolean stanWlaczenia;
    private String nrRejest;
    private String model;
    private SkrzyniaBiegow skrzynia;
    private Silnik silnik;
    private Pozycja aktualnaPozycja;
    private int speed;
    private boolean active;

    public Samochod_1(SkrzyniaBiegow skrzynia, Silnik silnik,String nrRejest,String model,int speed) {
        this.skrzynia = skrzynia;
        this.silnik = silnik;
        this.nrRejest = nrRejest;
        this.model = model;
        this.speed = speed;
        this.active=false;
    }

    public void wlacz(){
        skrzynia.uruchamianie();
        silnik.uruchom();
        active=true;
    }
    public void wylacz(){
        skrzynia.wylaczanie();
        silnik.zatrzymaj();
        active=false;
    }
    public void rusz(){
        silnik.zwiekszObroty();
        skrzynia.getAktBieg();
        if(skrzynia.getAktBieg()!=1){
            System.out.println("bad gear to start");
        }
    }
    public void increaseSpeed(){
        silnik.zwiekszObroty();
        skrzynia.getAktBieg();
    }


    public String getModel(){
        return model;
    }
    public String getNrRejest(){
        return nrRejest;
    }

    public double getWaga(){
        return 0.0;
    }

    public double getAktPredkosc(){
        return 0.0;
    }
    public SkrzyniaBiegow getSkrzynia(){
        return skrzynia;
    }
    public Silnik getSilnik(){
        return silnik;
    }
    }
