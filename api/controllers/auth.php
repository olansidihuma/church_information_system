<?php
/**
 * Authentication Controller
 * 
 * Handles user authentication operations
 */

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once '../config/database.php';
require_once '../utils/helpers.php';

$database = new Database();
$db = $database->getConnection();

$method = $_SERVER['REQUEST_METHOD'];

// Handle preflight requests
if ($method == 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Get request data
$data = json_decode(file_get_contents("php://input"), true);

// Route handling
$request_uri = $_SERVER['REQUEST_URI'];

if ($method == 'POST' && strpos($request_uri, '/register') !== false) {
    // REGISTER
    $required = ['name', 'email', 'password'];
    $errors = Validator::required($data, $required);
    
    if ($errors) {
        Response::error('Validation failed', 400, $errors);
    }
    
    if (!Validator::email($data['email'])) {
        Response::error('Invalid email format', 400);
    }
    
    // Check if email exists
    $query = "SELECT id FROM users WHERE email = :email";
    $stmt = $db->prepare($query);
    $stmt->bindParam(':email', $data['email']);
    $stmt->execute();
    
    if ($stmt->rowCount() > 0) {
        Response::error('Email already exists', 400);
    }
    
    // Hash password
    $hashed_password = password_hash($data['password'], PASSWORD_DEFAULT);
    
    // Insert user
    $query = "INSERT INTO users (name, email, password, phone, address, date_of_birth, gender) 
              VALUES (:name, :email, :password, :phone, :address, :date_of_birth, :gender)";
    
    $stmt = $db->prepare($query);
    $stmt->bindParam(':name', $data['name']);
    $stmt->bindParam(':email', $data['email']);
    $stmt->bindParam(':password', $hashed_password);
    $stmt->bindParam(':phone', $data['phone'] ?? null);
    $stmt->bindParam(':address', $data['address'] ?? null);
    $stmt->bindParam(':date_of_birth', $data['date_of_birth'] ?? null);
    $stmt->bindParam(':gender', $data['gender'] ?? 'male');
    
    if ($stmt->execute()) {
        $user_id = $db->lastInsertId();
        
        // Generate token
        $jwt = new JWT();
        $token = $jwt->generate([
            'user_id' => $user_id,
            'email' => $data['email'],
            'role' => 'member'
        ]);
        
        Response::success([
            'token' => $token,
            'user' => [
                'id' => $user_id,
                'name' => $data['name'],
                'email' => $data['email'],
                'role' => 'member'
            ]
        ], 'Registration successful', 201);
    } else {
        Response::error('Registration failed', 500);
    }
    
} elseif ($method == 'POST' && strpos($request_uri, '/login') !== false) {
    // LOGIN
    $required = ['email', 'password'];
    $errors = Validator::required($data, $required);
    
    if ($errors) {
        Response::error('Validation failed', 400, $errors);
    }
    
    // Get user
    $query = "SELECT id, name, email, password, role FROM users WHERE email = :email";
    $stmt = $db->prepare($query);
    $stmt->bindParam(':email', $data['email']);
    $stmt->execute();
    
    if ($stmt->rowCount() == 0) {
        Response::error('Invalid credentials', 401);
    }
    
    $user = $stmt->fetch(PDO::FETCH_ASSOC);
    
    // Verify password
    if (!password_verify($data['password'], $user['password'])) {
        Response::error('Invalid credentials', 401);
    }
    
    // Generate token
    $jwt = new JWT();
    $token = $jwt->generate([
        'user_id' => $user['id'],
        'email' => $user['email'],
        'role' => $user['role']
    ]);
    
    Response::success([
        'token' => $token,
        'user' => [
            'id' => $user['id'],
            'name' => $user['name'],
            'email' => $user['email'],
            'role' => $user['role']
        ]
    ], 'Login successful');
    
} elseif ($method == 'POST' && strpos($request_uri, '/logout') !== false) {
    // LOGOUT
    $auth = verifyAuth();
    Response::success(null, 'Logout successful');
    
} else {
    Response::error('Invalid endpoint', 404);
}
?>
