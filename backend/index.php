<?php

    echo "working";
    require_once "./config/database.php";

    try {
        $database = new Database();
        echo "working";
    } catch (PDOException $e) {
        throw new Exception("Database connection failed: " . $e->getMessage());
    }



?>