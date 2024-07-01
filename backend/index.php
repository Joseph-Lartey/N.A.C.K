<?php

// header('Access-Control-Allow-Origin: ' . $_SERVER['HTTP_ORIGIN']);
header('Access-Control-Allow-Methods: GET, PUT, POST, DELETE, PATCH, OPTIONS');
header('Access-Control-Max-Age: 1000');
header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With');
header('content-Type: application/json');
// require_once __DIR__.'/vendor/autoload.php';

// // Load environment variables from .env file
// $dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
// $dotenv->load();

// $router = new AltoRouter();
// $router->setBasePath('/N.A.C.K/backend');

// // Include your route definitions from app/routes/api.php
// require __DIR__ . '/app/routes/api.php';

// // Define a route
// // $router->map('GET', '/', function() {
// //     // Send a 200 status code
// //     http_response_code(200);
// //     echo "OK";
// // });

require_once __DIR__ . '/vendor/autoload.php';
require_once __DIR__ . '/config/database.php';
require_once __DIR__ . '/app/controllers/userController.php';
require_once __DIR__ . '/app/middleware/validationMiddleware.php';

use Dotenv\Dotenv;

$dotenv = Dotenv::createImmutable(__DIR__);
$dotenv->load();

$router = new AltoRouter();
$router->setBasePath('/N.A.C.K/backend');

// create database and pdo
$database = new Database();
$pdo = $database->getPdo();

$userController = new UserController($pdo);

// Routes
// Below I will define all the different end points that the user can send requests to

// Cater for user account creation
$router->map('POST', '/users', function () use ($userController) {

    $data = json_decode(file_get_contents('php://input'), true);

    // validate data
    ValidationMiddleWare::handle($data, [
        'firstname' => 'string',
        'lastname' => 'string',
        'username' => 'string',
        'email' => 'email',
        'password' => 'password',
        'confirm_password' => 'confirm_password',
        'dob' => 'string',
    ]);

    echo json_encode($userController->createUser($data));
});

// Cater for user login
$router->map('POST', '/users/login', function () use ($userController) {

    $data = json_decode(file_get_contents('php://input'), true);

    // validate data
    ValidationMiddleWare::handle($data, [
        'email' => 'string',
        'password' => 'password',
    ]);

    echo json_encode($userController->login($data));
});

// Catering for fetching user details by userId
$router->map('GET', '/users/[*:userId]', function ($userId) use ($userController) {
    ValidationMiddleWare::handle(['userId' => $userId], ['userId' => 'userId']);
    echo json_encode($userController->getUserById($userId));
});

// Cater for fetching all users
$router->map('GET', '/users', function() use ($userController) {
        
    echo json_encode($userController->getAllUsers());
});



$match = $router->match();

if ($match && is_callable($match['target'])) {
    call_user_func_array($match['target'], $match['params']);
} else {
    // No route was matched
    http_response_code(404);
    echo json_encode(['status' => 'error', 'message' => 'Route not found']);
}
