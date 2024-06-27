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

        // Handle user login action using the user model
        public function login($data){
            try {

                $db_details = $this->userModel->findByEmail($data['email']);

                if($db_details == false){ // throw exception if email is wrong
                    throw new InvalidArgumentException("Wrong email.");
                }

                $login_password = $data['password'];
                $db_password = $db_details['password'];

                if(password_verify($login_password, $db_password)){ // throw exception if password is wrong
                    return ["success" => true, "id" => $db_details['userId']];
                } else {
                    throw new InvalidArgumentException("Wrong password.");
                }

            } catch (InvalidArgumentException $e){ // Handle wrong password and email from user
                return [
                    "success" => false,
                    "error" => $e->getMessage()
                ];
            } catch (Exception $e){
                return [
                    "success" => false,
                    "error" => $e->getMessage(),
                ];
            }
        }
    }
?>