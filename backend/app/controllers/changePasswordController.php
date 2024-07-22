<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../models/user.php';

class ChangePasswordController
{
    private $userModel;

    public function __construct($pdo)
    {
        $this->userModel = new User($pdo);
    }

    public function changePassword($data)
    {
        if (!isset($data['email']) || !isset($data['oldPassword']) || !isset($data['newPassword'])) {
            return ['status' => 'error', 'message' => 'Invalid input'];
        }

        $email = $data['email'];
        $oldPassword = $data['oldPassword'];
        $newPassword = $data['newPassword'];

        if (!$this->isValidPassword($newPassword)) {
            return ['status' => 'error', 'message' => 'Password does not meet the criteria'];
        }

        $result = $this->userModel->changePassword($email, $oldPassword, $newPassword);

        if ($result) {
            return ['status' => 'success', 'message' => 'Password changed successfully'];
        } else {
            return ['status' => 'error', 'message' => 'Invalid current password'];
        }
    }

    private function isValidPassword($password)
    {
        $lengthValid = strlen($password) >= 8;
        $capitalLetterValid = preg_match('/[A-Z]/', $password);
        $symbolValid = preg_match('/[\W]/', $password); 

        return $lengthValid && $capitalLetterValid && $symbolValid;
    }
}
?>
