<?php
    require_once __DIR__ . '/../../vendor/autoload.php';

    use Dotenv\Dotenv;

    $dotenv = Dotenv::createImmutable(__DIR__.'/../..');
    $dotenv->load();

    // create database and pdo
    $database = new Database();
    $pdo = $database->getPdo();

    // handle user tailored actions
    $userController = new UserController($pdo);
    
    // router to match route to function
    $router = new AltoRouter();

    $router->map('POST', '/users', function() use ($userController) {
        $data = json_decode(file_get_contents('php:://input'), true);

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




?>