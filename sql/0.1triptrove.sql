drop database if exists triptrove;
create database triptrove;
use triptrove;

CREATE TABLE rol (
    idRol int auto_increment primary key,
    nombreRol varchar(20)
);


create table usuario(
	idUsuario int auto_increment primary key, 
	usuario varchar(30),
    correo varchar(30),
    contra varchar(30),
    idRol int,
	FOREIGN KEY (idRol) REFERENCES rol(idRol)
    );


create table rutas(
	idRuta int auto_increment primary key,
    idUsuario int,
    tiempoRutaProm float(3),
    costoProm int(10),
    foreign key (idUsuario) references usuario(idUsuario)
);

create table transporte(
	idTransporte int auto_increment primary key,
    idRutas int,
    tipoTransporte varchar(10),
    foreign key (idRutas) references rutas(idRuta)
);

create table comentario(
	idComentario int primary key,
    idUsuario int,
    titulo varchar(30),
    comentario varchar(30),
    cantidadPuntuacion float(2),
    foreign key (idUsuario) references usuario(idUsuario)
);

create table caracteristicas(
	idCaracteristicas int auto_increment primary key,
    idUsuario int,
    costoFig varchar(10),
	tiempoFig varchar(10),
    foreign key (idUsuario) references usuario(idUsuario)
);

create table caracteristicaEsp(
	idCaracEsp int auto_increment primary key,
    idCaracteristicas int,
    tipoCaract varchar(30),
    foreign key (idCaracteristicas) references caracteristicas(idCaracteristicas)
);

create table ubicacion(
	idUbicacion int auto_increment primary key,
    nombreUbicacion varchar(50),
    latitud float(50),
    longitud float(50),
    costoFig varchar(50),
	tiempoFig varchar(50),
    puntuacionProm float(50),
    descripcion varchar(100)
);

create table caracteristicaEspeUbicaciones(
	idCaracEspUbic int auto_increment primary key,
    idUbicacion int,
    tipoCaract varchar(30),
    foreign key (idUbicacion) references ubicacion(idUbicacion)
);

INSERT INTO rol (nombreRol) VALUES ('Administrador'), ('ServicioTecnico'),('Usuario');

INSERT INTO ubicacion (nombreUbicacion, latitud, longitud, costoFig, tiempoFig, puntuacionProm, descripcion)
VALUES
    ('Centro Historico',19.4326, -99.1332, '$$', '2 horas', 4.5, 'Lugar lleno de historia y arquitectura.'),
    ('Museo Frida Kahlo',19.3559,-99.1629, '$$', '1.5 horas', 4.7, 'Antigua casa de la pintora Frida Kahlo.'),
    ('Zoologico de Chapultepec',19.4148,-99.1870, '$$', '3 horas', 4.2, 'Lugar perfecto para disfrutar en familia con una amplia variedad de animales.'),
    ('Papalote Museo del Nino',19.4020,-99.1815, '$$', '2 horas', 4.8, 'Museo interactivo diseñado especialmente para niños.'),
    ('Bosque de Chapultepec',19.4225,-99.1810, 'Gratis', 'Varía', 4.6, 'Enorme parque urbano con áreas verdes y lagos.'),
    ('Xochimilco',19.2584,-99.0962, '$$', '2 horas', 4.4, 'Famosos canales y trajineras para paseos en bote.'),
    ('Museo Nacional de Antropologia',19.4269,-99.1886, '$$', '3 horas', 4.9, 'Uno de los museos más importantes del mundo en su categoría.'),
    ('Museo Soumaya',19.4379,-99.2826, 'Gratis', '2 horas', 4.7, 'Impresionante museo de arte con una colección diversa.'),
    ('Parque Mexico',19.4109,-99.1743, 'Gratis', 'Varía', 4.6, 'Ideal para pasear, hacer ejercicio y disfrutar de actividades al aire libre.'),
    ('Parque Bicentenario',19.4904,-99.1707, '$', 'Varía', 4.3, 'Espacio recreativo grande con áreas verdes y atracciones para toda la familia.');

-- Insertar datos en la tabla caracterisitcaEspeUbicaciones
INSERT INTO caracteristicaEspeUbicaciones (idUbicacion, tipoCaract)
VALUES
    (1, 'cultural'),
    (1, 'historia'),
    (2, 'cultural'),
    (2, 'historia'),
    (3, 'familiar'),
    (3, 'naturaleza'),
    (4, 'familiar'),
    (4, 'naturaleza'),
    (5, 'naturaleza'),
    (5, 'parques'),
    (6, 'naturaleza'),
    (6, 'parques'),
    (7, 'museos'),
    (7, 'cultura'),
    (8, 'museos'),
    (8, 'cultura'),
    (9, 'parques'),
    (9, 'diversion'),
    (10, 'parques'),
    (10, 'diversion');

insert into usuario(usuario,correo,contra,idRol) values("administrador","administrador@gmail.com","1234",1);
insert into usuario(usuario,correo,contra,idRol) values("servicioTecnico","servicioTecnico@gmail.com","1234",2);


