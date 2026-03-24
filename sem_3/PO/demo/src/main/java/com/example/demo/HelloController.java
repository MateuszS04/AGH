package com.example.demo;

import com.example.demo.samochod.*;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.image.Image;
import javafx.scene.text.Text;
import javafx.stage.Stage;

import javax.swing.text.html.ImageView;
import java.io.IOException;


public class HelloController {

    @FXML
    private Button StartButton;
    @FXML
    private Button StopButton;
    @FXML
    private Button UpShift;
    @FXML
    private Button DownShift;
    @FXML
    private Button press;
    @FXML
    private TextField speed;
    @FXML
    private TextField waga;
    @FXML
    private TextField model;
    @FXML
    private TextField nr_rej;
    @FXML
    private TextField silnik_nazwa;
    @FXML
    private TextField silnik_cena;
    @FXML
    private TextField silnik_waga;
    @FXML
    private TextField sprzeglo_cena;
    @FXML
    private TextField sprzeglo_waga;
    @FXML
    private TextField sprzeglo_model;
    @FXML
    private TextField skrzynia_bieg;
    @FXML
    private TextField skrzynia_cena;
    @FXML
    private TextField skrzynia_waga;
    @FXML

//    @FXML
//    public ImageView CarImageView;

    Samochod_1 samochod;



    public void initialize() {
        Car("skrzynia","silnik",100,10000,200,200,700,0,0,6,15000,200,"4",0,"KK09746");
        System.out.println("HelloController initialized");
        // Load and set the car image
        //Image carImage = new Image(getClass().getResource("/images/car.png").toExternalForm());
       // System.out.println("Image width: " + carImage.getWidth() + ", height: " + carImage.getHeight());
        //carImageView.setImage(carImage);
        //carImageView.setFitWidth(30); // Set appropriate
        //carImageView.setFitHeight(20);
        //carImageView.setTranslateX(0);
        //carImageView.setTranslateY(0);
    }
    public void Car(String nazwa_skrzyni,String nazwa_silnik,int obroty, int maxObroty, int cena_sp,int cena_si,int waga, int altualnybieg, int speed, int ilosc_biegow,int cena_skrzyni, int waga_skrzyni, String carmodel, int carspeed, String nrRejestr) {
        Sprzeglo sprzeglo = new Sprzeglo(nazwa_skrzyni, waga,cena_sp);
        Silnik silnik= new Silnik(maxObroty,obroty,nazwa_silnik,cena_si,waga);
        SkrzyniaBiegow skrzynia = new SkrzyniaBiegow(sprzeglo,ilosc_biegow,cena_skrzyni,waga_skrzyni,nazwa_skrzyni);
        samochod = new Samochod_1(skrzynia,silnik,nrRejestr,carmodel,carspeed);

        silnik_nazwa.setText(silnik.getNazwa());
        silnik_cena.setText(Double.toString(silnik.getCena()));
        silnik_waga.setText(Double.toString(silnik.getWaga()));

        sprzeglo_cena.setText(Double.toString(silnik.getCena()));
        sprzeglo_model.setText(sprzeglo.getNazwa());
        sprzeglo_waga.setText(Double.toString(sprzeglo.getWaga()));

        skrzynia_bieg.setText(Double.toString(skrzynia.getAktBieg()));
        skrzynia_cena.setText(Double.toString(skrzynia.getCena()));
        skrzynia_waga.setText(Double.toString(skrzynia.getWaga()));



    }
    public static void addCarToList(String model, String nr_rej, double weight, int speed){

    }

    public void refresh(){
        waga.setText(String.valueOf(samochod.getWaga()));
        model.setText(samochod.getModel());
        nr_rej.setText(samochod.getNrRejest());
        speed.setText(String.valueOf(samochod.getAktPredkosc()));
    }
    @FXML
    public void onStartButton(){
        samochod.wlacz();
        System.out.println("Samochód uruchomiony");
        refresh();
    }
    public void setSpeed(){
         samochod.getAktPredkosc();
         refresh();
    }
    public void onStopButton(){
        samochod.wylacz();
        System.out.println("Samochód zatrzymany");
        refresh();
    }
    public void onUpShiftButton(){
        samochod.getSkrzynia().zwiekszBieg();
        System.out.println("Wyższy bieg");
        refresh();
    }
    public void onDownShiftButton(){
        samochod.getSkrzynia().zmniejszBieg();
        System.out.println("niższy bieg");
        refresh();
    }
    public void openAddCarWindow() throws IOException {
        FXMLLoader loader = new FXMLLoader(getClass().getResource("DodajSamochod.fxml"));
        Stage stage = new Stage();
        stage.setScene(new Scene(loader.load()));
        stage.setTitle("Dodaj nowy samochód");
        stage.show();
    }

}
