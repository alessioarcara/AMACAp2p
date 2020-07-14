package blend;

import javax.swing.*;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;

import jolie.runtime.JavaService;

public class JavaSwingConsole extends JavaService {

    public static void aperturaConsole() {
        JFrame f=new JFrame();//creating instance of JFrame  
          
        JButton b=new JButton("click");//creating instance of JButton  
        b.setBounds(130,100,100, 40);//x axis, y axis, width, height  
                

        f.add(b);//adding button in JFrame  
                
        f.setSize(400,500);//400 width and 500 height  
        f.setLayout(null);//using no layout managers  
        f.setVisible(true);//making the frame visible 

        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    }

}