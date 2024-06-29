<?php
    require_once __DIR__.'/model.php';
    /// Class to represent the Users database
    class User extends Model {
        protected $table = 'users';

        // Create single user
        public function createUser($firstname, $lastname, $email, $password, $dob){
            $password_hash = password_hash($password, PASSWORD_DEFAULT);
            $verified = true;
            $data = [
                'firstName' => $firstname,
                'lastName' => $lastname,
                'username' => $firstname,
                'email' => $email,
                'password' => $password_hash,
                'dob' => $dob,
                'verified' => $verified,
            ];

            return $this->insert($data);
        }

        // Find a user by their email address
        public function findByEmail($email){
            $result = $this->find("email", $email);
            return $result;
        }
        
        //find a user by their id
        public function findById($userId){
            $result = $this->find("userId", $userId);
            return $result;
        }

    }

