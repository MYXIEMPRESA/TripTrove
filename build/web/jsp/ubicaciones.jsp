<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Zoológico de Chapultepec</title>
        <link rel="stylesheet" type="text/css" href="css/zoolchapu.css">
        <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
        <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, initial-scale=1.0">
    </head>
    <body>
        <% String nombreUbicacion = request.getParameter("id");%>

        <jsp:include page="/ubicaciones/BosquedeChapultepec.html" />

        <jsp:include page="comentarios.jsp" />

    </body>
</html>
