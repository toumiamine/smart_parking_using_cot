package smart.parking.cot.services;

import com.itextpdf.io.font.constants.StandardFonts;
import com.itextpdf.kernel.font.PdfFont;
import com.itextpdf.kernel.font.PdfFontFactory;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfPage;
import com.itextpdf.kernel.pdf.PdfReader;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.kernel.pdf.canvas.PdfCanvas;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.text.NumberFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;


@WebServlet( "/pdfexport" )
public class PDFExport extends HttpServlet {

    private static final long serialVersionUID = 7609134248482865644L;


    @Override
    protected void doGet( HttpServletRequest request, HttpServletResponse response )
            throws ServletException, IOException {

        int idCommand = 0;
        try {
            idCommand = Integer.parseInt( request.getParameter( "idCommand" ) );
        } catch (Exception exception ) {
            // Nothing to do
        }
        String [] lines = {
               "Hello",
                "Hi"
        };

        String masterPath = request.getServletContext().getRealPath( "/WEB-INF/template.pdf" );
        response.setContentType( "application/pdf" );

        try ( PdfReader reader = new PdfReader( masterPath );
              PdfWriter writer = new PdfWriter( response.getOutputStream() );
              PdfDocument document = new PdfDocument( reader, writer ) ) {

            PdfPage page = document.getPage( 1 );
            PdfCanvas canvas = new PdfCanvas( page );
            PdfFont helveticaFont = PdfFontFactory.createFont(StandardFonts.HELVETICA);
            PdfFont helveticaBoldFont = PdfFontFactory.createFont(StandardFonts.HELVETICA_BOLD);

            canvas.setFontAndSize( helveticaFont, 8 );

            canvas.beginText();

            canvas.setTextMatrix(492F, 701.5F);
            canvas.showText("WX123GAX" );

            DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");
            LocalDateTime now = LocalDateTime.now();
            canvas.setTextMatrix(462F, 682F);
            canvas.showText(dtf.format(now));

            canvas.setFontAndSize( helveticaBoldFont, 12 );
            canvas.setTextMatrix(72.5F, 597F);
            canvas.showText("Mohamed Becha Kaanichouu" );

            canvas.setFontAndSize( helveticaFont, 9 );
            canvas.setTextMatrix( 79, 533 );
            canvas.showText("Reservation");

            canvas.setTextMatrix( 160, 533 );
            canvas.showText(dtf.format(now));

            canvas.setTextMatrix( 300, 533 );
            canvas.showText(dtf.format(now));

            canvas.setTextMatrix( 398, 533 );
            canvas.showText("116 TND");

            canvas.setTextMatrix( 490, 498 );
            canvas.showText("30 TND");

            canvas.setFontAndSize( helveticaBoldFont, 9 );
            canvas.setTextMatrix( 490, 462 );
            canvas.showText("146 TND");

            canvas.endText();

        }

    }

}
