# API Documentation - Church Information System

## Base URL

```
Development: http://localhost/church_api
Production: https://your-domain.com/api
```

## Authentication

All authenticated endpoints require a JWT token in the Authorization header:

```
Authorization: Bearer <token>
```

## Response Format

### Success Response
```json
{
  "success": true,
  "message": "Success message",
  "data": {...}
}
```

### Error Response
```json
{
  "success": false,
  "message": "Error message",
  "errors": {...}
}
```

## API Endpoints

### 1. Authentication

#### Register New User

**Endpoint:** `POST /auth/register`

**Request Body:**
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123",
  "phone": "081234567890",
  "address": "Jakarta, Indonesia",
  "date_of_birth": "1990-01-01",
  "gender": "male"
}
```

**Response:** `201 Created`
```json
{
  "success": true,
  "message": "Registration successful",
  "data": {
    "token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
    "user": {
      "id": 1,
      "name": "John Doe",
      "email": "john@example.com",
      "role": "member"
    }
  }
}
```

#### Login

**Endpoint:** `POST /auth/login`

**Request Body:**
```json
{
  "email": "john@example.com",
  "password": "password123"
}
```

**Response:** `200 OK`
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
    "user": {
      "id": 1,
      "name": "John Doe",
      "email": "john@example.com",
      "role": "member"
    }
  }
}
```

#### Logout

**Endpoint:** `POST /auth/logout`

**Headers:** 
```
Authorization: Bearer <token>
```

**Response:** `200 OK`
```json
{
  "success": true,
  "message": "Logout successful",
  "data": null
}
```

---

### 2. Church Activities

#### Get All Activities

**Endpoint:** `GET /activities`

**Response:** `200 OK`
```json
{
  "success": true,
  "message": "Activities retrieved successfully",
  "data": [
    {
      "id": 1,
      "title": "Ibadah Minggu Pagi",
      "description": "Ibadah kebaktian minggu pagi",
      "activity_type": "service",
      "location": "Gedung Gereja Utama",
      "start_time": "2024-01-07 09:00:00",
      "end_time": "2024-01-07 11:00:00",
      "status": "scheduled",
      "creator_name": "Admin",
      "created_at": "2024-01-01 00:00:00"
    }
  ]
}
```

#### Get Activity Detail

**Endpoint:** `GET /activities/{id}`

**Response:** `200 OK`
```json
{
  "success": true,
  "message": "Activity retrieved successfully",
  "data": {
    "id": 1,
    "title": "Ibadah Minggu Pagi",
    "description": "Ibadah kebaktian minggu pagi",
    "activity_type": "service",
    "location": "Gedung Gereja Utama",
    "start_time": "2024-01-07 09:00:00",
    "end_time": "2024-01-07 11:00:00",
    "status": "scheduled",
    "attendance_count": 150,
    "creator_name": "Admin"
  }
}
```

#### Create Activity (Admin Only)

**Endpoint:** `POST /activities`

**Headers:**
```
Authorization: Bearer <token>
```

**Request Body:**
```json
{
  "title": "Ibadah Pemuda",
  "description": "Kebaktian khusus pemuda",
  "activity_type": "service",
  "location": "Aula Gereja",
  "start_time": "2024-01-14 17:00:00",
  "end_time": "2024-01-14 19:00:00"
}
```

**Response:** `201 Created`
```json
{
  "success": true,
  "message": "Activity created successfully",
  "data": {
    "id": 5
  }
}
```

---

### 3. Service Requests

#### Submit Prayer Request

**Endpoint:** `POST /services/prayer-request`

**Headers:**
```
Authorization: Bearer <token>
```

**Request Body:**
```json
{
  "title": "Prayer for Healing",
  "description": "Please pray for my mother's recovery",
  "is_anonymous": false
}
```

**Response:** `201 Created`
```json
{
  "success": true,
  "message": "Prayer request submitted successfully",
  "data": {
    "id": 1
  }
}
```

#### Get Prayer Requests

**Endpoint:** `GET /services/prayer-request`

**Headers:**
```
Authorization: Bearer <token>
```

**Response:** `200 OK`
```json
{
  "success": true,
  "message": "Prayer requests retrieved successfully",
  "data": [
    {
      "id": 1,
      "title": "Prayer for Healing",
      "description": "Please pray for my mother's recovery",
      "is_anonymous": false,
      "status": "pending",
      "created_at": "2024-01-05 10:00:00"
    }
  ]
}
```

#### Submit Baptism Request

**Endpoint:** `POST /services/baptism-request`

**Headers:**
```
Authorization: Bearer <token>
```

**Request Body:**
```json
{
  "candidate_name": "Sarah Johnson",
  "candidate_age": 25,
  "candidate_relationship": "self",
  "preferred_date": "2024-02-15",
  "notes": "Would prefer morning service"
}
```

**Response:** `201 Created`
```json
{
  "success": true,
  "message": "Baptism request submitted successfully",
  "data": {
    "id": 1
  }
}
```

#### Get Baptism Requests

**Endpoint:** `GET /services/baptism-request`

**Headers:**
```
Authorization: Bearer <token>
```

**Response:** `200 OK`
```json
{
  "success": true,
  "message": "Baptism requests retrieved successfully",
  "data": [...]
}
```

#### Submit Child Dedication Request

**Endpoint:** `POST /services/child-dedication`

**Headers:**
```
Authorization: Bearer <token>
```

**Request Body:**
```json
{
  "child_name": "Emma Grace",
  "child_date_of_birth": "2023-06-15",
  "child_gender": "female",
  "parent_names": "John and Jane Doe",
  "preferred_date": "2024-03-10",
  "notes": "First child dedication"
}
```

**Response:** `201 Created`
```json
{
  "success": true,
  "message": "Child dedication request submitted successfully",
  "data": {
    "id": 1
  }
}
```

#### Get Child Dedication Requests

**Endpoint:** `GET /services/child-dedication`

**Headers:**
```
Authorization: Bearer <token>
```

**Response:** `200 OK`
```json
{
  "success": true,
  "message": "Child dedication requests retrieved successfully",
  "data": [...]
}
```

---

### 4. Family Management

#### Get Family Members

**Endpoint:** `GET /family/members`

**Headers:**
```
Authorization: Bearer <token>
```

**Response:** `200 OK`
```json
{
  "success": true,
  "message": "Family members retrieved successfully",
  "data": [
    {
      "id": 1,
      "name": "Jane Doe",
      "relationship": "wife",
      "date_of_birth": "1992-05-20",
      "gender": "female",
      "phone": "081234567891",
      "created_at": "2024-01-01 00:00:00"
    }
  ]
}
```

#### Add Family Member

**Endpoint:** `POST /family/members`

**Headers:**
```
Authorization: Bearer <token>
```

**Request Body:**
```json
{
  "name": "Jane Doe",
  "relationship": "wife",
  "date_of_birth": "1992-05-20",
  "gender": "female",
  "phone": "081234567891"
}
```

**Response:** `201 Created`
```json
{
  "success": true,
  "message": "Family member added successfully",
  "data": {
    "id": 1
  }
}
```

---

### 5. Chat

#### Get Chat Messages

**Endpoint:** `GET /chat/messages`

**Headers:**
```
Authorization: Bearer <token>
```

**Response:** `200 OK`
```json
{
  "success": true,
  "message": "Messages retrieved successfully",
  "data": [
    {
      "id": 1,
      "sender_id": 2,
      "receiver_id": 1,
      "message": "Hello, I need help with registration",
      "message_type": "text",
      "is_read": true,
      "sender_name": "John Doe",
      "created_at": "2024-01-05 10:30:00"
    }
  ]
}
```

#### Send Chat Message

**Endpoint:** `POST /chat/messages`

**Headers:**
```
Authorization: Bearer <token>
```

**Request Body:**
```json
{
  "message": "Hello, I need assistance",
  "message_type": "text"
}
```

**Response:** `201 Created`
```json
{
  "success": true,
  "message": "Message sent successfully",
  "data": {
    "id": 1
  }
}
```

---

## Error Codes

| Code | Description |
|------|-------------|
| 200  | Success |
| 201  | Created |
| 400  | Bad Request / Validation Error |
| 401  | Unauthorized / Invalid Token |
| 403  | Forbidden |
| 404  | Not Found |
| 500  | Internal Server Error |

## Rate Limiting

Currently, no rate limiting is implemented. It's recommended to implement rate limiting in production:
- 100 requests per minute per IP for public endpoints
- 500 requests per minute for authenticated endpoints

## Security Considerations

1. **Always use HTTPS in production**
2. **Implement CORS properly**
3. **Validate and sanitize all inputs**
4. **Use prepared statements (PDO)**
5. **Implement rate limiting**
6. **Regular security audits**
7. **Keep JWT secret key secure**
8. **Set appropriate token expiration**
9. **Implement password strength requirements**
10. **Add request logging**

## Testing with cURL

### Example: Login
```bash
curl -X POST http://localhost/church_api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@church.com","password":"admin123"}'
```

### Example: Get Activities (Authenticated)
```bash
curl -X GET http://localhost/church_api/activities \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

### Example: Submit Prayer Request
```bash
curl -X POST http://localhost/church_api/services/prayer-request \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -d '{"title":"Prayer Request","description":"Please pray for me","is_anonymous":false}'
```

## Testing with Postman

1. Import the API endpoints into Postman
2. Set up environment variables for base URL and token
3. Use collection runner for automated testing
4. Export and share collections with team

## Changelog

### Version 1.0.0 (Initial Release)
- Authentication endpoints
- Church activities management
- Service requests (prayer, baptism, child dedication)
- Family member management
- Chat messaging
- JWT authentication
- MySQL database integration

## Support

For API-related issues or questions, refer to the main README.md or contact the development team.
