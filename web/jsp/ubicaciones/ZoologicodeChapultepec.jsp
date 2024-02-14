<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Zoológico de Chapultepec</title>
        <link rel="stylesheet" type="text/css" href="ubicaciones/css/zoolchapu.css">
        <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
        <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, initial-scale=1.0">
    </head>
    <body>

        <header>
            <a href="#" class="logo">TripTrove</a>
        </header>

        <div class="content">
            <div class="box">
                <img src="ubicaciones/img/zoolchapu.jpg" alt="Larger Image">
                <span>Descubre la Fauna</span>
            </div>
            <div class="box">
                <img src="ubicaciones/img/zoolchapu2.jpg" alt="Small Image 1">
                <span>Interacción Animal</span>
            </div>
            <div class="box">
                <img src="ubicaciones/img/zoolchapu1.jpg" alt="Small Image 2">
                <span>Actividades Educativas</span>
            </div>
            <div class="box">
                <img src="ubicaciones/img/zoolchapu4.jpg" alt="Small Image 3">
                <span>Diversión en Familia</span>
            </div>
        </div>

        <div class="image-text">
            <h1>Explora la Vida Salvaje en el Zoológico de Chapultepec</h1>
            <p>Sumérgete en la maravilla de la biodiversidad en el Zoológico de Chapultepec. Hogar de una amplia variedad de especies, este zoológico ofrece una experiencia educativa y emocionante para visitantes de todas las edades.</p>
            <p>Desde feroces felinos hasta adorables criaturas, el Zoológico de Chapultepec te invita a descubrir la belleza y la importancia de la vida animal. Únete a nosotros y embárcate en un viaje fascinante a través de la fauna del mundo.</p>
        </div>


        <div class="image-text1">
            <h1>¿Qué puedes hacer?</h1>
            <p>El Zoológico de Chapultepec ofrece una variedad de actividades para hacer tu visita memorable. Aquí algunas sugerencias:</p>
            <ul>
                <li>Observar a los animales en entornos que imitan sus hábitats naturales.</li>
                <li>Participar en programas interactivos para aprender sobre la conservación de la vida silvestre.</li>
                <li>Disfrutar de espectáculos y presentaciones educativas con animales.</li>
            </ul>
        </div>
        <h1>Lugar ideal para:</h1>
        <div class="content2">
            <div class="icon-description">
                <i class='bx bxs-camera'></i>
                <p>fotografías</p>
            </div>
            <div class="icon-description">
                <i class='bx bxs-graduation'></i>
                <p>educación</p>
            </div>
            <div class="icon-description">
                <i class='bx bxs-group' ></i>
                <p>diversión en grupo</p>
            </div>
            <div class="icon-description">
                <i class='bx bxs-tree'></i>
                <p>aire libre</p>
            </div>
            <div class="icon-description">
                <i class='bx bxs-coffee'></i>
                <p>cafetería</p>
            </div>

        </div>
        <script type="text/javascript">Z
            window.addEventListener("scroll", function () {
                var header = document.querySelector("header");
                header.classList.toggle("sticky", window.scrollY > 0);
            })
        </script>
    </body>
</html>