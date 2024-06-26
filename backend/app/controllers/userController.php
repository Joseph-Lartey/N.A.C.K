<?php
    require_once __DIR__.'/../models/user.php';
    // Class to cater for all user oriented actions
    class UserController {
        protected $userModel;

        public function __construct($pdo){
            $this->userModel = new User($pdo);
        }

        // Hand create user action using the user model
        public function createUser($data){
            $this->userModel->createUser(
                $data['firstname'],
                $data['lastname'],
                $data['username'],
                $data['email'],
                $data['password'],
                $data['dob'],
            );

            return ['success' => true] ;
        }
    }
?>