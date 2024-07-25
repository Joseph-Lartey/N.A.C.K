<?php

/// Middleware to cater for validation of user data when login in
class ValidationMiddleWare
{
    // handle validation
    public static function handle($data, $rules)
    {

        // store errors encountered from validation
        $errors = [];

        foreach ($rules as $field => $rule) {
            if (!isset($data[$field])) {
                $errors[$field] = "$field is required";
            } else {
                $value = $data[$field];
                switch ($rule) {
                    case 'email':
                        // confirmt that the email format is valid
                        if (!filter_var($value, FILTER_VALIDATE_EMAIL)) {
                            $errors[$field] = "Invalid email format";
                        }
                        break;

                    case 'string':
                        if (!is_string($value)) {
                            $errors[$field] = "$field must be a string";
                        }
                        break;

                    case 'confirm_password':
                        // confirm that the passwords match
                        if (!isset($data[$field]) || $value !== $data['password']) {
                            $errors[$field] = "passwords do not match";
                        }
                        break;
                    case 'password':
                        // confirm that the password is the appropriate length
                        if (strlen($value) < 8) {
                            $errors[$field] = "$field must be at least 8 characters";
                        }
                        break;

                    case 'integer':
                        if(!filter_var($value, FILTER_VALIDATE_INT)){
                            $errors[$field] = "$field should be an integer";
                        }
                        break;
                }
            }
        }

        if (!empty($errors)) {
            header('HTTP/1.1 422 Unprocessable Entity');
            echo json_encode(['success' => false, 'errors' => $errors]);
            exit();
        }
    }

    // handle image validation
    public static function handleImage($file){

        $allowedTypes = ["image/jpeg", "image/jpg", "image/png", "image/gif"];

        if(!in_array($file['type'], $allowedTypes)){
            header('HTTP/1.1 422 Unprocessable Entity');
            echo json_encode(['success' => false, 'errors' => "Disallowed image type"]);
            exit();
        }
    }
}
