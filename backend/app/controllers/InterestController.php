<?php

require_once __DIR__ . '/../models/interest.php';
require_once __DIR__ . '/../models/UserInterest.php';

class InterestController
{
    protected $interestModel;
    protected $userInterestModel;

    public function __construct($pdo)
    {
        $this->interestModel = new Interest($pdo);
        $this->userInterestModel = new UserInterest($pdo);
    }

    // Get all interests
    public function getAllInterests()
    {
        try {
            $interests = $this->interestModel->getAllInterests();
            return ["success" => true, "data" => $interests];
        } catch (\Exception $e) {
            header('HTTP/1.1 422 Unprocessable Entity');
            return ["success" => false, "error" => $e->getMessage()];
        }
    }

    // Add a new interest
    public function createInterest($data)
    {
        try {
            $existingInterest = $this->interestModel->findInterest('interestName', $data['interestName']);
            if ($existingInterest) {
                return ["success" => false, "message" => "Interest already exists"];
            }

            $this->interestModel->insertInterest($data);
            return ["success" => true, "message" => "Interest created successfully"];
        } catch (\Exception $e) {
            header('HTTP/1.1 422 Unprocessable Entity');
            return ["success" => false, "error" => $e->getMessage()];
        }
    }

    // Get user interests
    public function getUserInterests($userId)
    {
        try {
            $interests = $this->userInterestModel->getUserInterests($userId);
            return ["success" => true, "data" => $interests];
        } catch (\Exception $e) {
            header('HTTP/1.1 422 Unprocessable Entity');
            return ["success" => false, "error" => $e->getMessage()];
        }
    }

    // Add an interest to a user
    public function addUserInterest($data)
    {
        try {
            $this->userInterestModel->insertUserInterest($data);
            return ["success" => true, "message" => "User interest added successfully"];
        } catch (\Exception $e) {
            header('HTTP/1.1 422 Unprocessable Entity');
            return ["success" => false, "error" => $e->getMessage()];
        }
    }

    // Remove an interest from a user
    public function removeUserInterest($data)
    {
        try {
            $this->userInterestModel->deleteUserInterest($data['userId'], $data['interestId']);
            return ["success" => true, "message" => "User interest removed successfully"];
        } catch (\Exception $e) {
            header('HTTP/1.1 422 Unprocessable Entity');
            return ["success" => false, "error" => $e->getMessage()];
        }
    }
}

