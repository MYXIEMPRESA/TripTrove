/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package connectionDataBase;


import java.sql.*;
import static java.lang.System.out;
/**
 *
 * @author Usuario
 */
public class connection {
    Connection cnx= null;
    public Connection connectionAction(){
        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
            cnx = DriverManager.getConnection("jdbc:mysql://localhost:3306/triptrove?autoReconnect=true&useSSL=false", "root", "n0m3l0");
        }catch(ClassNotFoundException | SQLException error){
            out.print(error);
        }
        return cnx;
    }
}
