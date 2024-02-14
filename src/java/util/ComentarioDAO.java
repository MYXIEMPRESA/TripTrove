package util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import connectionDataBase.connection;
import objetos.comentario;

public class ComentarioDAO {

    public List<comentario> getComentarios(int offset, int limit) {
        List<comentario> comentarios = new ArrayList<>();

        try (Connection connection = new connection().connectionAction(); PreparedStatement statement = connection.prepareStatement("SELECT * FROM comentario LIMIT ?, ?");) {
            statement.setInt(1, offset);
            statement.setInt(2, limit);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    comentario comentario = new comentario();
                    comentario.setIdComentario(resultSet.getInt("idComentario"));
                    comentario.setIdUbicacion(resultSet.getInt("idUbicacion"));
                    comentario.setIdUsuario(resultSet.getInt("idUsuario"));
                    comentario.setPuntuacion(resultSet.getInt("puntuacion"));
                    comentario.setComentario(resultSet.getString("comentario"));
                    comentario.setPuntuacionComentario(resultSet.getFloat("puntuacionComentario"));

                    comentarios.add(comentario);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return comentarios;
    }
}
