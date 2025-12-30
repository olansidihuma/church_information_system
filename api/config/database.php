<?php
/**
 * Database Configuration
 * 
 * Database connection settings for MySQL
 */

class Database {
    // Database credentials
    private $host = "localhost";
    private $db_name = "church_information_system";
    private $username = "root";
    private $password = "";
    public $conn;
    
    /**
     * Get database connection
     * 
     * @return PDO|null Database connection object
     */
    public function getConnection() {
        $this->conn = null;
        
        try {
            $this->conn = new PDO(
                "mysql:host=" . $this->host . ";dbname=" . $this->db_name,
                $this->username,
                $this->password
            );
            $this->conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            $this->conn->exec("set names utf8");
        } catch(PDOException $exception) {
            echo "Connection error: " . $exception->getMessage();
        }
        
        return $this->conn;
    }
}
?>
