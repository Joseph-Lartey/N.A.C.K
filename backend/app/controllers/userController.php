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
            
            try {

                $this->userModel->createUser(
                    $data['firstname'],
                    $data['lastname'],
                    $data['email'],
                    $data['password'],
                    $data['dob'],
                );
    
                return ['success' => true] ;

            } catch(PDOException $pe) {
                if ($pe->getCode() == 23000){
                    $errors = ["success" => false, "error" => "Email already exists in system"];
                    return $errors;
                }
            }
            catch (\Exception $e) {
                $errors = ["success" => false,"error" => $e->getMessage()];
                return $errors;
            }
        }
    }
?>