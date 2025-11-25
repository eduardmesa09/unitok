<?php
// config.php
// Configuración de conexión a la base de datos con PDO

$DB_HOST = 'localhost';
$DB_NAME = 'unitok';
$DB_USER = 'userUnitok';
$DB_PASS = '1999Salaza*';

$dsn = "mysql:host=$DB_HOST;dbname=$DB_NAME;charset=utf8mb4";

$options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION, // excepciones
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES   => false,
];

try {
    $pdo = new PDO($dsn, $DB_USER, $DB_PASS, $options);
} catch (PDOException $e) {
    die('Error de conexión a la base de datos: ' . $e->getMessage());
}

// Para la demo simulamos un usuario "logueado":
$USUARIO_DEMO_ID = 12;
