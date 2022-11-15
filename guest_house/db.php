<?php
define('DB_SERVER', 'localhost');
define('DB_USERNAME', 'root');
define('DB_PASSWORD', '');
define('DB_DATABASE', 'guest_house');

// attempt to connect to mysql database
$db = new mysqli(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_DATABASE);

// Check connection
if ($db === false) {
    die("ERROR: Could not connect. " . $db->connect_error);
}
?>