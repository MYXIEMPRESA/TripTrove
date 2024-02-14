<%@ page import="java.sql.*" %>
<%@ page import="connectionDataBase.connection" %>

<%


    Connection cnx = new connection().connectionAction();

    // Método para crear un comentario
    if (request.getParameter("action") != null && request.getParameter("action").equals("create")) {
        String usuario = (String) session.getAttribute("usuario");
        int idUbicacion = Integer.parseInt(request.getParameter("idUbicacion"));
        int puntuacion = Integer.parseInt(request.getParameter("puntuacion"));
        String comentario = request.getParameter("comentario");
        float puntuacionComentario = Float.parseFloat(request.getParameter("puntuacionComentario"));

        try {
            String insertQuery = "INSERT INTO comentario (idUbicacion, idUsuario, puntuacion, comentario, puntuacionComentario) VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement pst = cnx.prepareStatement(insertQuery)) {
                pst.setInt(1, idUbicacion);
                pst.setInt(2, Integer.parseInt(usuario));
                pst.setInt(3, puntuacion);
                pst.setString(4, comentario);
                pst.setFloat(5, puntuacionComentario);
                pst.executeUpdate();
            }
            response.sendRedirect("principal.jsp");
        } catch (SQLException e) {
            out.print(e);
        }
    }

    // Método para modificar un comentario
    if (request.getParameter("action") != null && request.getParameter("action").equals("update")) {
        int idComentario = Integer.parseInt(request.getParameter("idComentario"));
        int puntuacion = Integer.parseInt(request.getParameter("puntuacion"));
        String comentario = request.getParameter("comentario");
        float puntuacionComentario = Float.parseFloat(request.getParameter("puntuacionComentario"));

        try {
            String updateQuery = "UPDATE comentario SET puntuacion=?, comentario=?, puntuacionComentario=? WHERE idComentario=?";
            try (PreparedStatement pst = cnx.prepareStatement(updateQuery)) {
                pst.setInt(1, puntuacion);
                pst.setString(2, comentario);
                pst.setFloat(3, puntuacionComentario);
                pst.setInt(4, idComentario);
                pst.executeUpdate();
            }
            response.sendRedirect("principal.jsp");
        } catch (SQLException e) {
            out.print(e);
        }
    }

    // Método para borrar un comentario
    if (request.getParameter("action") != null && request.getParameter("action").equals("delete")) {
        int idComentario = Integer.parseInt(request.getParameter("idComentario"));
        try {
            String deleteQuery = "DELETE FROM comentario WHERE idComentario=?";
            try (PreparedStatement pst = cnx.prepareStatement(deleteQuery)) {
                pst.setInt(1, idComentario);
                pst.executeUpdate();
            }
            response.sendRedirect("principal.jsp");
        } catch (SQLException e) {
            out.print(e);
        }
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Comentarios</title>
    </head>
    <body>
        <h2 style="color: black;">Crear Comentario</h2>
        <form action="ubicaciones/comentar.jsp" method="post">
            <input type="hidden" name="action" value="create">
            <label style="color: black;">ID Ubicacion: </label>
            <input type="text" name="idUbicacion" required><br>
            <label style="color: black;">Puntuacion: </label>
            <input type="text" name="puntuacion" required><br>
            <label style="color: black;">Comentario: </label>
            <input type="text" name="comentario" required><br>
            <label style="color: black;">Puntuacion Comentario: </label>
            <input type="text" name="puntuacionComentario" required><br>
            <input type="submit" value="Crear Comentario" style="color: black;">
        </form>
        <h2 style="color: black;">Modificar Comentario</h2>
        <form action="ubicaciones/comentar.jsp" method="post">
            <input type="hidden" name="action" value="update" style="color: black;">
            <label style="color: black;">ID Comentario a Modificar: </label>
            <input type="text" name="idComentario" required style="color: black;"><br>
            <label style="color: black;">Nueva Puntuacion: </label>
            <input type="text" name="puntuacion" style="color: black;" required><br>
            <label style="color: black;">Nuevo Comentario: </label>
            <input type="text" name="comentario" required style="color: black;"><br>
            <label style="color: black;">Nueva Puntuacion Comentario: </label>
            <input type="text" name="puntuacionComentario" style="color: black;" required><br>
            <input type="submit" value="Modificar Comentario" style="color: black;">
        </form>
        <h2 style="color: black;">Borrar Comentario</h2>
        <form action="ubicaciones/comentar.jsp" method="post">
            <input type="hidden" name="action" value="delete">
            <label>ID Comentario a Borrar: </label>
            <input type="text" name="idComentario" required><br>
            <input type="submit" value="Borrar Comentario">
        </form>
    </body>
</html>
