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

    require_once __DIR__.'/vendor/autoload.php';
    require_once __DIR__.'/config/database.php';
    require_once __DIR__.'/app/controllers/userController.php';
    require_once __DIR__.'/app/middleware/validationMiddleware.php';

    use Dotenv\Dotenv;

    $dotenv = Dotenv::createImmutable(__DIR__);
    $dotenv->load();

    $router = new AltoRouter();
    $router->setBasePath('/N.A.C.K/backend');

    // create database and pdo
    $database = new Database();
    $pdo = $database->getPdo();

    $userController = new UserController($pdo);

    // Define a route
    $router->map('GET', '/', function() {
        // Send a 200 status code
        http_response_code(200);
        echo "OK";
    });

    // Cater for user account creation
    $router->map('POST', '/users', function() use ($userController) {
        echo 'working';
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

    $match = $router->match();
    var_dump($match);
    var_dump($router);

    if ($match && is_callable($match['target'])) {
        call_user_func_array($match['target'], $match['params']);
    } else {
        // No route was matched
        http_response_code(404);
        echo json_encode(['status' => 'error', 'message' => 'Route not found']);
    }

?>