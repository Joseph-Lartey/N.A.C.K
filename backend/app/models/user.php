<?php
require_once __DIR__ . '/model.php';
/// Class to represent the Users database
class User extends Model
{
    protected $table = 'users';

    // Create single user
    public function createUser($firstname, $lastname, $email, $password, $dob)
    {
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
    public function findByEmail($email)
    {
        $result = $this->find("email", $email);
        return $result;
    }

    //find a user by their id
    public function findProfileById($id)
    {
        $sql = "SELECT userId, firstName, lastName, email FROM " . $this->table . " WHERE userId = :id";
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute(['id' => $id]);
        return $stmt->fetch(PDO::FETCH_ASSOC); // Fetch as associative array to avoid duplicate keys
    }
}
