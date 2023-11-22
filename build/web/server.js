// server.js
const express = require('express');
const mysql = require('mysql');
const app = express();
const port = 3000;

const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'n0m3l0',
  database: 'triptrove'
});

connection.connect();

app.get('/ubicaciones', (req, res) => {
  const query = 'SELECT nombreUbicacion, longitud, latitud FROM ubicacion';

  connection.query(query, (error, results) => {
    if (error) throw error;

    res.json(results);
  });
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
