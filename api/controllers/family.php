<?php
/**
 * Family Controller
 * 
 * Handles family member management
 */

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
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

// Verify authentication
$auth = verifyAuth();

$data = json_decode(file_get_contents("php://input"), true);

if ($method == 'GET') {
    // GET FAMILY MEMBERS
    $query = "SELECT * FROM family_members WHERE user_id = :user_id ORDER BY created_at DESC";
    $stmt = $db->prepare($query);
    $stmt->bindParam(':user_id', $auth['user_id']);
    $stmt->execute();
    
    $members = $stmt->fetchAll(PDO::FETCH_ASSOC);
    Response::success($members, 'Family members retrieved successfully');
    
} elseif ($method == 'POST') {
    // ADD FAMILY MEMBER
    $required = ['name', 'relationship'];
    $errors = Validator::required($data, $required);
    
    if ($errors) {
        Response::error('Validation failed', 400, $errors);
    }
    
    $query = "INSERT INTO family_members (user_id, name, relationship, date_of_birth, gender, phone) 
              VALUES (:user_id, :name, :relationship, :date_of_birth, :gender, :phone)";
    
    $stmt = $db->prepare($query);
    $stmt->bindParam(':user_id', $auth['user_id']);
    $stmt->bindParam(':name', $data['name']);
    $stmt->bindParam(':relationship', $data['relationship']);
    $stmt->bindParam(':date_of_birth', $data['date_of_birth'] ?? null);
    $stmt->bindParam(':gender', $data['gender'] ?? 'male');
    $stmt->bindParam(':phone', $data['phone'] ?? null);
    
    if ($stmt->execute()) {
        Response::success(['id' => $db->lastInsertId()], 'Family member added successfully', 201);
    } else {
        Response::error('Failed to add family member', 500);
    }
    
} else {
    Response::error('Invalid method', 405);
}
?>
