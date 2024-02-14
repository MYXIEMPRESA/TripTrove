package objetos;

public class comentario {

    private int idComentario;
    private int idUbicacion;
    private int idUsuario;
    private int puntuacion;
    private String comentario;
    private float puntuacionComentario;

    public int getIdComentario() {
        return idComentario;
    }

    public void setIdComentario(int idComentario) {
        this.idComentario = idComentario;
    }

    public int getIdUbicacion() {
        return idUbicacion;
    }

    public void setIdUbicacion(int idUbicacion) {
        this.idUbicacion = idUbicacion;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public int getPuntuacion() {
        return puntuacion;
    }

    public void setPuntuacion(int puntuacion) {
        this.puntuacion = puntuacion;
    }

    public String getComentario() {
        return comentario;
    }

    public void setComentario(String comentario) {
        this.comentario = comentario;
    }

    public float getPuntuacionComentario() {
        return puntuacionComentario;
    }

    public void setPuntuacionComentario(float puntuacionComentario) {
        this.puntuacionComentario = puntuacionComentario;
    }

}
