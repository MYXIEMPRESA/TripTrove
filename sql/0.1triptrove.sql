drop database if exists triptrove;
create database triptrove;
use triptrove;
create table usuario(
	idUsuario int auto_increment primary key, 
	usuario varchar(30),
    correo varchar(30),
    contra varchar(30)
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

create table caracterisitcaEspe(
	idCaracEsp int auto_increment primary key,
    idCaracteristicas int,
    tipoCaract varchar(30),
    foreign key (idCaracteristicas) references caracteristicas(idCaracteristicas)
);

create table ubicacion(
	idUbicacion int auto_increment primary key,
    nombreUbicacion varchar(10),
    longitud float(10),
    latitud float(10),
    costoFig varchar(10),
	tiempoFig varchar(10),
    puntuacionProm float(2),
    descripcion varchar(50)
);

create table caracterisitcaEspeUbicaciones(
	idCaracEspUbic int auto_increment primary key,
    idUbicacion int,
    tipoCaract varchar(30),
    foreign key (idUbicacion) references ubicacion(idUbicacion)
);

