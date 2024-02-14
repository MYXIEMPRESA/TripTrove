package util;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import objetos.comentario;

@WebServlet("/LoadCommentsServlet")
public class LoadCommentsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int pagina = Integer.parseInt(request.getParameter("pagina"));
        int limit = 10; // Especifica el límite de comentarios por página según tus necesidades

        int offset = (pagina - 1) * limit; // Calcula el offset en base a la página actual

        ComentarioDAO comentarioDAO = new ComentarioDAO();
        List<comentario> comentarios = comentarioDAO.getComentarios(offset, limit);

        PrintWriter out = response.getWriter();


        for (comentario comentario : comentarios) {
            out.println("<div>");
            out.println("<p style=\"color: black;\">ID Comentario: " + comentario.getIdComentario() + "</p>");
            out.println("<p style=\"color: black;\">ID Ubicación: " + comentario.getIdUbicacion() + "</p>");
            out.println("<p style=\"color: black;\">ID Usuario: " + comentario.getIdUsuario() + "</p>");
            out.println("<p style=\"color: black;\">Puntuación: " + comentario.getPuntuacion() + "</p>");
            out.println("<p style=\"color: black;\">Comentario: " + comentario.getComentario() + "</p>");
            out.println("<p style=\"color: black;\">Puntuación del Comentario: " + comentario.getPuntuacionComentario() + "</p>");
            out.println("<hr>");
            out.println("</div>");
        }
    }
}