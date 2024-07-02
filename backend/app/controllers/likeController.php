<?php

require_once __DIR__ . '/../models/likes.php';
require_once __DIR__. '/../models/matches.php';

class LikeController
{
    protected $likeModel;
    protected $matchModel;

    public function __construct($pdo)
    {
        $this->likeModel = new Like($pdo);
        $this->matchModel = new Matches($pdo);
    }

    // handle the current user liking another user
    public function likeUser($data)
    {
        try {
            $isLiked = $this->likeModel->isLiked($data);

            if (!$isLiked)
            {
                $this->likeModel->insertLike($data);
                return ["success" => true, "message" => "Like has been inserted"];

            } else {
                $matchData = [
                    "userId_1" => $data["userId"],
                    "userId_2" => $data["liked_userId"]
                ];

                // Upgrade like relationship to match relationship
                $this->likeModel->deleteLike($data);
                $this->matchModel->insertMatch($matchData);

                return ["success" => true, "message" => "Match has been created"];
            }
        } catch (\Exception $e) {
            header('HTTP/1.1 422 Unprocessable Entity');
            $errors = ["success" => false, "error" => $e->getMessage()];
            return $errors;
        }
    }

    // Get the ids of all users who are matched with the current user
    public function getMatches($id)
    {
        $user_matches = $this->matchModel->getMatches($id);

        return ["success" => true, "data" => $user_matches];
    }
}

?>