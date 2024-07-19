<?php

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;

require_once __DIR__ . '/../models/user.php';
// require '/xampp/htdocs/N.A.C.K/backend/vendor/autoload.php';
require_once __DIR__ . '/../../vendor/autoload.php';

use Dotenv\Dotenv;

$dotenv = Dotenv::createImmutable(__DIR__ . '/../../');
$dotenv->load();

class ForgetPasswordController
{
    private $userModel;

    public function __construct($pdo)
    {
        $this->userModel = new User($pdo);
    }

    public function resetPassword($data)
    {
        $email = $data['email'];
        $user = $this->userModel->findByEmail($email);
        if ($user) {
            $newPassword = $this->generateSecurePassword();
            if ($this->userModel->resetPassword($email, $newPassword)) {
                $mailResult = $this->sendPasswordResetEmail($email, $newPassword);
                if ($mailResult === 'Message has been sent') {
                    return ['success' => true, 'message' => 'Password reset. Check your email for the new password.'];
                } else {
                    return ['success' => false, 'message' => $mailResult];
                }
            } else {
                return ['success' => false, 'message' => 'Failed to reset password.'];
            }
        } else {
            return ['success' => false, 'message' => 'Email not found.'];
        }
    }

    private function generateSecurePassword()
    {
        $length = 8;
        $uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        $lowercase = 'abcdefghijklmnopqrstuvwxyz';
        $digits = '0123456789';
        $symbols = '!@#$%^&*()';
        
        $allCharacters = $uppercase . $lowercase . $digits . $symbols;

        $password = array();
        $password[] = $uppercase[rand(0, strlen($uppercase) - 1)];
        $password[] = $lowercase[rand(0, strlen($lowercase) - 1)];
        $password[] = $digits[rand(0, strlen($digits) - 1)];
        $password[] = $symbols[rand(0, strlen($symbols) - 1)];

        for ($i = 4; $i < $length; $i++) {
            $password[] = $allCharacters[rand(0, strlen($allCharacters) - 1)];
        }

        // Shuffle the password to ensure randomness
        shuffle($password);

        return implode('', $password);
    }

    private function sendPasswordResetEmail($email, $newPassword)
    {
        $mail = new PHPMailer;
        $mail->isSMTP();
        $mail->Host = $_ENV["MAIL_HOST"];  
        $mail->SMTPAuth = true;
        $mail->Username = $_ENV["MAIL_USERNAME"];  
        $mail->Password = $_ENV["MAIL_PASSWORD"]; 
        $mail->SMTPSecure = $_ENV["MAIL_SMTPSECURE"];
        $mail->Port = $_ENV["MAIL_PORT"];

        $mail->setFrom('no-reply@example.com', 'nack');
        $mail->addAddress($email);

        $mail->isHTML(true);
        $mail->Subject = 'Password Reset Request';
        $mail->Body    = "Your new password is: $newPassword";
        $mail->AltBody = "Your new password is: $newPassword";

        if(!$mail->send()) {
            return 'Mailer Error: ' . $mail->ErrorInfo;
        } else {
            return 'Message has been sent';
        }
    }
}
?>
