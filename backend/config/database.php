<?php
    require_once __DIR__ . '/../vendor/autoload.php';

    use Dotenv\Dotenv;
    
    $dotenv = Dotenv::createImmutable(__DIR__ . '/..'); // Assuming .env is in the project root
    $dotenv->load();

/// Database class to handle connection to database
class Database {
    private $pdo;

    public function __construct()
    {
        $config = $this->getDatabaseConfig();

        $dsn = "mysql:host={$config['host']};dbname={$config['dbname']}";
        $username = $config['username'];
        $password = $config['password'];

        try {
            $this->pdo = new PDO($dsn, $username, $password);
            $this->pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        } catch (PDOException $e) {
            throw new Exception("Database connection failed: " . $e->getMessage());
        }
    }

    private function getDatabaseConfig()
    {
        return [
            'host' => $_ENV['DB_HOST'],
            'dbname' => $_ENV['DB_DATABASE'],
            'username' => $_ENV['DB_USERNAME'],
            'password' => $_ENV['DB_PASSWORD'],
        ];
    }

    public function getPdo()
    {
        return $this->pdo;
    }
}

?>
