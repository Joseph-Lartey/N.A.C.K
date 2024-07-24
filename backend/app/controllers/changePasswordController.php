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
        if (!isset($data['userId']) || !isset($data['oldPassword']) || !isset($data['newPassword']) || !isset($data['confirmPassword'])) {
            return ['status' => 'error', 'message' => 'Invalid input'];
        }

        $userId = (int)$data['userId'];
        $oldPassword = $data['oldPassword'];
        $newPassword = $data['newPassword'];
        $confirmPassword = $data['confirmPassword'];

        if ($newPassword !== $confirmPassword) {
            return ['status' => 'error', 'message' => 'Passwords do not match'];
        }

        if (!$this->isValidPassword($newPassword)) {
            return ['status' => 'error', 'message' => 'Password does not meet the criteria'];
        }

        $result = $this->userModel->changePassword($userId, $oldPassword, $newPassword);

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
