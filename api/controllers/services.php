<?php
/**
 * Services Controller
 * 
 * Handles service requests (prayer, baptism, child dedication)
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
$request_uri = $_SERVER['REQUEST_URI'];

if (strpos($request_uri, '/prayer-request') !== false) {
    // PRAYER REQUEST
    if ($method == 'POST') {
        $required = ['title', 'description'];
        $errors = Validator::required($data, $required);
        
        if ($errors) {
            Response::error('Validation failed', 400, $errors);
        }
        
        $query = "INSERT INTO prayer_requests (user_id, title, description, is_anonymous) 
                  VALUES (:user_id, :title, :description, :is_anonymous)";
        
        $stmt = $db->prepare($query);
        $stmt->bindParam(':user_id', $auth['user_id']);
        $stmt->bindParam(':title', $data['title']);
        $stmt->bindParam(':description', $data['description']);
        $is_anonymous = $data['is_anonymous'] ?? false;
        $stmt->bindParam(':is_anonymous', $is_anonymous, PDO::PARAM_BOOL);
        
        if ($stmt->execute()) {
            Response::success(['id' => $db->lastInsertId()], 'Prayer request submitted successfully', 201);
        } else {
            Response::error('Failed to submit prayer request', 500);
        }
    } elseif ($method == 'GET') {
        $query = "SELECT * FROM prayer_requests WHERE user_id = :user_id ORDER BY created_at DESC";
        $stmt = $db->prepare($query);
        $stmt->bindParam(':user_id', $auth['user_id']);
        $stmt->execute();
        
        $requests = $stmt->fetchAll(PDO::FETCH_ASSOC);
        Response::success($requests, 'Prayer requests retrieved successfully');
    }
    
} elseif (strpos($request_uri, '/baptism-request') !== false) {
    // BAPTISM REQUEST
    if ($method == 'POST') {
        $required = ['candidate_name'];
        $errors = Validator::required($data, $required);
        
        if ($errors) {
            Response::error('Validation failed', 400, $errors);
        }
        
        $query = "INSERT INTO baptism_requests (user_id, candidate_name, candidate_age, candidate_relationship, preferred_date, notes) 
                  VALUES (:user_id, :candidate_name, :candidate_age, :candidate_relationship, :preferred_date, :notes)";
        
        $stmt = $db->prepare($query);
        $stmt->bindParam(':user_id', $auth['user_id']);
        $stmt->bindParam(':candidate_name', $data['candidate_name']);
        $stmt->bindParam(':candidate_age', $data['candidate_age'] ?? null);
        $stmt->bindParam(':candidate_relationship', $data['candidate_relationship'] ?? null);
        $stmt->bindParam(':preferred_date', $data['preferred_date'] ?? null);
        $stmt->bindParam(':notes', $data['notes'] ?? null);
        
        if ($stmt->execute()) {
            Response::success(['id' => $db->lastInsertId()], 'Baptism request submitted successfully', 201);
        } else {
            Response::error('Failed to submit baptism request', 500);
        }
    } elseif ($method == 'GET') {
        $query = "SELECT * FROM baptism_requests WHERE user_id = :user_id ORDER BY created_at DESC";
        $stmt = $db->prepare($query);
        $stmt->bindParam(':user_id', $auth['user_id']);
        $stmt->execute();
        
        $requests = $stmt->fetchAll(PDO::FETCH_ASSOC);
        Response::success($requests, 'Baptism requests retrieved successfully');
    }
    
} elseif (strpos($request_uri, '/child-dedication') !== false) {
    // CHILD DEDICATION REQUEST
    if ($method == 'POST') {
        $required = ['child_name', 'child_date_of_birth', 'parent_names'];
        $errors = Validator::required($data, $required);
        
        if ($errors) {
            Response::error('Validation failed', 400, $errors);
        }
        
        $query = "INSERT INTO child_dedication_requests (user_id, child_name, child_date_of_birth, child_gender, parent_names, preferred_date, notes) 
                  VALUES (:user_id, :child_name, :child_date_of_birth, :child_gender, :parent_names, :preferred_date, :notes)";
        
        $stmt = $db->prepare($query);
        $stmt->bindParam(':user_id', $auth['user_id']);
        $stmt->bindParam(':child_name', $data['child_name']);
        $stmt->bindParam(':child_date_of_birth', $data['child_date_of_birth']);
        $stmt->bindParam(':child_gender', $data['child_gender'] ?? 'male');
        $stmt->bindParam(':parent_names', $data['parent_names']);
        $stmt->bindParam(':preferred_date', $data['preferred_date'] ?? null);
        $stmt->bindParam(':notes', $data['notes'] ?? null);
        
        if ($stmt->execute()) {
            Response::success(['id' => $db->lastInsertId()], 'Child dedication request submitted successfully', 201);
        } else {
            Response::error('Failed to submit child dedication request', 500);
        }
    } elseif ($method == 'GET') {
        $query = "SELECT * FROM child_dedication_requests WHERE user_id = :user_id ORDER BY created_at DESC";
        $stmt = $db->prepare($query);
        $stmt->bindParam(':user_id', $auth['user_id']);
        $stmt->execute();
        
        $requests = $stmt->fetchAll(PDO::FETCH_ASSOC);
        Response::success($requests, 'Child dedication requests retrieved successfully');
    }
    
} else {
    Response::error('Invalid endpoint', 404);
}
?>
