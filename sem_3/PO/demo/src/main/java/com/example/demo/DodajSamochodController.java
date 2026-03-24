package com.example.demo;

import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.TextField;
import javafx.stage.Stage;

import java.io.IOException;

public class DodajSamochodController {
    @FXML
    private Button Cancel;
    @FXML
    private Button confirm;
    @FXML
    private TextField nr_rej;
    @FXML
    private TextField modelText;
    @FXML
    private TextField weightText;
    @FXML
    private TextField speedText;
    @FXML
    private void onConfirmButton(){
        String model = modelText.getText();
        String nr = nr_rej.getText();
        double weight;
        int speed;
        try{
            weight=Double.parseDouble(weightText.getText());
            speed=Integer.parseInt(speedText.getText());
            model=String.valueOf(model);
            nr=String.valueOf(nr_rej);
        }catch(NumberFormatException e){
            System.out.println("Niepoprawne dane");
            return;
        }
        HelloController.addCarToList(model,nr,weight,speed);
        Stage stage = (Stage) Cancel.getScene().getWindow();
        stage.close();

    }
    @FXML
    private void onCancelButton() {
        Stage stage = (Stage) Cancel.getScene().getWindow();
        stage.close();
    }

}


