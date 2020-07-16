package blend;

import java.awt.Graphics;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;
import javax.swing.JTextArea;
import java.awt.Image;

public class textAreaWithImage extends JTextArea {
    
    private Image immagine;
    
    public textAreaWithImage( int a, int b ) {
        super( a, b );

        try {
            immagine = ImageIO.read( new File("services/src/main/java/blend/logoAmaca.jpg"));
        } catch( IOException exception ) {
            exception.printStackTrace();
        }
    }

    @Override
    protected void paintComponent( Graphics g ) {
        g.drawImage( immagine, 0, 0, null );
        super.paintComponent( g );
    }
}