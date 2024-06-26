<?php
    /// Class to represent the Users database
    class User extends Model {
        protected $table = 'users';

        // Create single user
        public function createUser($firstname, $lastname, $email, $password, $dob, $class){
            $password_hash = password_hash($password, PASSWORD_DEFAULT);
            $data = [
                'firstName' => $firstname,
                'lastName' => $lastname,
                'username' => $firstname,
                'email' => $email,
                'password' => $password_hash,
                'dob' => DateTime::createFromFormat('d/m/Y', $dob)->format("Y-m-d"),
                'verified' => true,
            ];

            return $this->insert($data);
        }

        // Find a user by their email address
        public function findByEmail($email){
            $result = $this->find("email", $email);
            return $result;
        }

    }

?>