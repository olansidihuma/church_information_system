<?php
/**
 * Activities Controller
 * 
 * Handles church activities/services operations
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

// Get request data
$data = json_decode(file_get_contents("php://input"), true);
$request_uri = $_SERVER['REQUEST_URI'];

if ($method == 'GET' && !preg_match('/\/activities\/\d+/', $request_uri)) {
    // GET ALL ACTIVITIES
    $query = "SELECT a.*, u.name as creator_name 
              FROM activities a 
              LEFT JOIN users u ON a.created_by = u.id 
              WHERE a.status != 'cancelled'
              ORDER BY a.start_time ASC";
    
    $stmt = $db->prepare($query);
    $stmt->execute();
    
    $activities = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    Response::success($activities, 'Activities retrieved successfully');
    
} elseif ($method == 'GET' && preg_match('/\/activities\/(\d+)/', $request_uri, $matches)) {
    // GET ACTIVITY BY ID
    $activity_id = $matches[1];
    
    $query = "SELECT a.*, u.name as creator_name 
              FROM activities a 
              LEFT JOIN users u ON a.created_by = u.id 
              WHERE a.id = :id";
    
    $stmt = $db->prepare($query);
    $stmt->bindParam(':id', $activity_id);
    $stmt->execute();
    
    if ($stmt->rowCount() == 0) {
        Response::error('Activity not found', 404);
    }
    
    $activity = $stmt->fetch(PDO::FETCH_ASSOC);
    
    // Get attendance count
    $query_attendance = "SELECT COUNT(*) as count FROM activity_attendance WHERE activity_id = :id AND status = 'attending'";
    $stmt_attendance = $db->prepare($query_attendance);
    $stmt_attendance->bindParam(':id', $activity_id);
    $stmt_attendance->execute();
    $attendance = $stmt_attendance->fetch(PDO::FETCH_ASSOC);
    
    $activity['attendance_count'] = $attendance['count'];
    
    Response::success($activity, 'Activity retrieved successfully');
    
} elseif ($method == 'POST') {
    // CREATE ACTIVITY (Admin only)
    $auth = verifyAuth();
    
    $required = ['title', 'start_time'];
    $errors = Validator::required($data, $required);
    
    if ($errors) {
        Response::error('Validation failed', 400, $errors);
    }
    
    $query = "INSERT INTO activities (title, description, activity_type, location, start_time, end_time, created_by) 
              VALUES (:title, :description, :activity_type, :location, :start_time, :end_time, :created_by)";
    
    $stmt = $db->prepare($query);
    $stmt->bindParam(':title', $data['title']);
    $stmt->bindParam(':description', $data['description'] ?? null);
    $stmt->bindParam(':activity_type', $data['activity_type'] ?? 'service');
    $stmt->bindParam(':location', $data['location'] ?? null);
    $stmt->bindParam(':start_time', $data['start_time']);
    $stmt->bindParam(':end_time', $data['end_time'] ?? null);
    $stmt->bindParam(':created_by', $auth['user_id']);
    
    if ($stmt->execute()) {
        Response::success(['id' => $db->lastInsertId()], 'Activity created successfully', 201);
    } else {
        Response::error('Failed to create activity', 500);
    }
    
} else {
    Response::error('Invalid endpoint', 404);
}
?>
