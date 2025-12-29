<?php
/**
 * Chat Controller
 * 
 * Handles chat messaging with admin
 */

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET, POST");
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
    // GET CHAT MESSAGES
    // Get admin user id
    $query_admin = "SELECT id FROM users WHERE role = 'admin' LIMIT 1";
    $stmt_admin = $db->prepare($query_admin);
    $stmt_admin->execute();
    $admin = $stmt_admin->fetch(PDO::FETCH_ASSOC);
    
    if (!$admin) {
        Response::error('Admin not found', 404);
    }
    
    $admin_id = $admin['id'];
    
    // Get messages between user and admin
    $query = "SELECT cm.*, u.name as sender_name 
              FROM chat_messages cm
              LEFT JOIN users u ON cm.sender_id = u.id
              WHERE (cm.sender_id = :user_id AND cm.receiver_id = :admin_id)
                 OR (cm.sender_id = :admin_id AND cm.receiver_id = :user_id)
              ORDER BY cm.created_at ASC";
    
    $stmt = $db->prepare($query);
    $stmt->bindParam(':user_id', $auth['user_id']);
    $stmt->bindParam(':admin_id', $admin_id);
    $stmt->execute();
    
    $messages = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    // Mark messages as read
    $query_update = "UPDATE chat_messages SET is_read = 1 
                     WHERE receiver_id = :user_id AND sender_id = :admin_id AND is_read = 0";
    $stmt_update = $db->prepare($query_update);
    $stmt_update->bindParam(':user_id', $auth['user_id']);
    $stmt_update->bindParam(':admin_id', $admin_id);
    $stmt_update->execute();
    
    Response::success($messages, 'Messages retrieved successfully');
    
} elseif ($method == 'POST') {
    // SEND MESSAGE
    $required = ['message'];
    $errors = Validator::required($data, $required);
    
    if ($errors) {
        Response::error('Validation failed', 400, $errors);
    }
    
    // Get admin user id
    $query_admin = "SELECT id FROM users WHERE role = 'admin' LIMIT 1";
    $stmt_admin = $db->prepare($query_admin);
    $stmt_admin->execute();
    $admin = $stmt_admin->fetch(PDO::FETCH_ASSOC);
    
    if (!$admin) {
        Response::error('Admin not found', 404);
    }
    
    $query = "INSERT INTO chat_messages (sender_id, receiver_id, message, message_type) 
              VALUES (:sender_id, :receiver_id, :message, :message_type)";
    
    $stmt = $db->prepare($query);
    $stmt->bindParam(':sender_id', $auth['user_id']);
    $stmt->bindParam(':receiver_id', $admin['id']);
    $stmt->bindParam(':message', $data['message']);
    $stmt->bindParam(':message_type', $data['message_type'] ?? 'text');
    
    if ($stmt->execute()) {
        Response::success(['id' => $db->lastInsertId()], 'Message sent successfully', 201);
    } else {
        Response::error('Failed to send message', 500);
    }
    
} else {
    Response::error('Invalid method', 405);
}
?>
