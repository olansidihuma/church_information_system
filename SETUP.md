# Setup Guide - Church Information System

## Quick Start Guide

This guide will help you set up and run the Church Information System application.

## Prerequisites

### Required Software
- **Flutter SDK** (>=3.0.0) - [Download Here](https://flutter.dev/docs/get-started/install)
- **PHP** (>=7.4) - [Download Here](https://www.php.net/downloads)
- **MySQL** (>=5.7) - [Download Here](https://dev.mysql.com/downloads/)
- **Apache/Nginx** Web Server
- **Android Studio** or **VS Code** (for development)
- **Git** (for version control)

### System Requirements
- Operating System: Windows 10/11, macOS, or Linux
- RAM: Minimum 8GB (16GB recommended)
- Storage: At least 10GB free space

## Backend Setup (PHP + MySQL)

### Step 1: Database Configuration

1. **Start MySQL Server**
   ```bash
   # On Linux/Mac
   sudo service mysql start
   
   # On Windows (using XAMPP)
   # Start XAMPP Control Panel and start MySQL
   ```

2. **Create Database**
   ```bash
   # Login to MySQL
   mysql -u root -p
   
   # Create database
   CREATE DATABASE church_information_system;
   
   # Exit MySQL
   exit;
   ```

3. **Import Database Schema**
   ```bash
   # Navigate to project directory
   cd /path/to/church_information_system
   
   # Import schema
   mysql -u root -p church_information_system < api/database.sql
   ```

### Step 2: Configure Database Connection

Edit `api/config/database.php`:

```php
private $host = "localhost";
private $db_name = "church_information_system";
private $username = "root";          // Your MySQL username
private $password = "your_password"; // Your MySQL password
```

### Step 3: Configure Web Server

#### Option A: Using XAMPP (Recommended for Windows)

1. Install XAMPP from [https://www.apachefriends.org/](https://www.apachefriends.org/)
2. Copy the `api` folder to `C:\xampp\htdocs\church_api`
3. Start Apache from XAMPP Control Panel
4. Access API at `http://localhost/church_api`

#### Option B: Using PHP Built-in Server (Development Only)

```bash
cd api
php -S localhost:8000
```

Access API at `http://localhost:8000`

#### Option C: Using Apache on Linux/Mac

1. Copy `api` folder to `/var/www/html/church_api`
2. Enable mod_rewrite:
   ```bash
   sudo a2enmod rewrite
   sudo service apache2 restart
   ```
3. Ensure `.htaccess` is enabled in Apache configuration
4. Access API at `http://localhost/church_api`

### Step 4: Test Backend API

```bash
# Test login endpoint
curl -X POST http://localhost/church_api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@church.com","password":"admin123"}'
```

Expected response:
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "token": "...",
    "user": {...}
  }
}
```

## Frontend Setup (Flutter)

### Step 1: Install Flutter Dependencies

```bash
cd /path/to/church_information_system
flutter pub get
```

### Step 2: Configure API Base URL

Edit `lib/services/api_service.dart`:

```dart
// For local development
static const String baseUrl = 'http://localhost/church_api';

// For production
// static const String baseUrl = 'https://your-domain.com/api';

// For Android Emulator (use your local IP)
// static const String baseUrl = 'http://10.0.2.2/church_api';
```

**Important Notes:**
- For Android Emulator, use `http://10.0.2.2` instead of `localhost`
- For physical devices, use your computer's local IP (e.g., `http://192.168.1.100/church_api`)
- For production, use your actual domain with HTTPS

### Step 3: Run Flutter Application

#### For Android

```bash
# Connect Android device or start emulator
flutter devices

# Run application
flutter run
```

#### For iOS (macOS only)

```bash
# Start iOS simulator or connect iPhone
flutter devices

# Run application
flutter run -d ios
```

#### For Web

```bash
flutter run -d chrome
```

## Development Workflow

### Running the Complete System

1. **Start MySQL Server**
2. **Start Web Server** (Apache/XAMPP or PHP built-in server)
3. **Run Flutter App** in your preferred IDE or terminal

### Hot Reload

Flutter supports hot reload for quick development:
- Press `r` in terminal to hot reload
- Press `R` to hot restart
- Press `q` to quit

## Testing the Application

### 1. Test Public Homepage
- Open the app without logging in
- View church schedules and information

### 2. Test Registration
- Click "Register" button
- Fill in registration form
- Submit to create account

### 3. Test Login
- Use registered credentials or default admin:
  - Email: `admin@church.com`
  - Password: `admin123`

### 4. Test Member Features
After logging in, test:
- Prayer request submission
- Baptism request submission
- Child dedication request
- Family member registration
- Chat with admin
- View calendar

## Troubleshooting

### Common Issues and Solutions

#### Issue: "Connection refused" or "Network error"

**Solution:**
1. Verify MySQL server is running
2. Check Apache/PHP server is running
3. Verify API base URL in Flutter app
4. For Android Emulator, use `http://10.0.2.2` instead of `localhost`
5. For physical device, use your computer's IP address

#### Issue: "Database connection error"

**Solution:**
1. Check MySQL credentials in `api/config/database.php`
2. Verify database exists: `SHOW DATABASES;` in MySQL
3. Ensure database user has proper permissions

#### Issue: "404 Not Found" on API endpoints

**Solution:**
1. Verify `.htaccess` file exists in `api` folder
2. Enable `mod_rewrite` in Apache
3. Check Apache `AllowOverride` is set to `All`

#### Issue: Flutter dependencies error

**Solution:**
```bash
flutter clean
flutter pub get
flutter pub upgrade
```

#### Issue: "JWT token invalid or expired"

**Solution:**
1. Logout and login again
2. Check JWT secret key is consistent in `api/utils/helpers.php`
3. Token expires after 24 hours by default

## Production Deployment

### Backend Deployment

1. **Choose a hosting provider** (e.g., DigitalOcean, AWS, Hostinger)
2. **Upload API files** to server
3. **Import database** to production MySQL
4. **Update database credentials** in `config/database.php`
5. **Change JWT secret key** in `utils/helpers.php`
6. **Enable HTTPS** (required for security)
7. **Update CORS settings** if needed

### Frontend Deployment

#### Android

```bash
# Build APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release
```

#### iOS

```bash
# Build iOS app
flutter build ios --release
```

#### Web

```bash
# Build web app
flutter build web

# Deploy to hosting (Firebase, Netlify, etc.)
```

### Important Production Changes

1. **Security:**
   - Change JWT secret key
   - Update default admin password
   - Enable HTTPS
   - Implement rate limiting
   - Add input validation

2. **Configuration:**
   - Update API base URL to production domain
   - Configure proper CORS settings
   - Set up database backups
   - Enable error logging

3. **Performance:**
   - Enable caching
   - Optimize database queries
   - Minimize API response sizes
   - Use CDN for static assets

## Next Steps

1. **Customize the Application:**
   - Update church logo and branding
   - Modify color scheme in `lib/config/theme.dart`
   - Add custom church information

2. **Extend Functionality:**
   - Add more service types
   - Implement push notifications (FCM)
   - Add admin dashboard
   - Create reports and analytics

3. **Testing:**
   - Test all features thoroughly
   - Test on multiple devices
   - Perform security audit
   - Load testing for production

## Support

For issues or questions:
1. Check the troubleshooting section
2. Review README.md for API documentation
3. Check Flutter documentation: [https://flutter.dev/docs](https://flutter.dev/docs)
4. Check PHP documentation: [https://www.php.net/docs.php](https://www.php.net/docs.php)

## License

This project is open source and available under the MIT License.
