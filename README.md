# Church Information System

Aplikasi Sistem Informasi Gereja Modern berbasis Flutter dengan PHP Native API dan MySQL Database.

## Fitur Utama

### 1. Homepage (Halaman Utama Publik)
- Informasi jadwal ibadah
- Informasi kegiatan gereja (kebaktian khusus, retret, dll)

### 2. Autentikasi Pengguna
- Halaman login dan registrasi untuk anggota gereja
- Anggota dapat mendaftarkan keluarga lain

### 3. Pelayanan Digital untuk Anggota Login
- Permintaan pelayanan doa
- Permintaan pelayanan baptis
- Permintaan untuk penyerahan anak

### 4. Notifikasi
- Notifikasi otomatis 1 jam sebelum ibadah/kegiatan
- Pengguna dapat merespon notifikasi untuk mengikuti ibadah atau tidak

### 5. Fitur Chat
- Anggota dapat mengirim pesan kepada admin secara langsung

### 6. Manajemen Lokal
- Simpan login anggota menggunakan SharedPreferences
- Simpan jadwal lokal dengan alarm dan local notification

### 7. **Baca Alkitab Offline (BARU!)**
- Pembacaan Alkitab offline dengan daftar lengkap kitab
- Pelacakan progress bacaan (kitab, pasal, ayat)
- Jadwal membaca harian yang dapat dikustomisasi
- Pengingat membaca dengan notifikasi
- Penanda progress harian (berapa ayat/pasal sudah dibaca)
- Statistik bacaan (total ayat dan pasal yang telah dibaca)
- Pemilihan kitab dari Perjanjian Lama dan Perjanjian Baru

## Teknologi yang Digunakan

### Frontend (Flutter)
- **GetX**: State management dan navigasi
- **Dio**: HTTP client untuk API
- **SharedPreferences**: Penyimpanan data lokal
- **Flutter Local Notifications**: Notifikasi lokal
- **Android Alarm Manager Plus**: Pengingat ibadah
- **Flutter Chat UI**: Interface chat
- **Table Calendar**: Kalender kegiatan
- **Google Fonts**: Typography modern

### Backend (PHP Native + MySQL)
- **PHP Native**: RESTful API
- **MySQL**: Database relational
- **JWT**: Authentication token
- **PDO**: Database connection

## Struktur Proyek

```
church_information_system/
├── api/                          # PHP Backend API
│   ├── config/
│   │   └── database.php         # Database configuration
│   ├── controllers/
│   │   ├── auth.php             # Authentication endpoints
│   │   ├── activities.php       # Church activities endpoints
│   │   ├── services.php         # Service requests endpoints
│   │   ├── family.php           # Family management endpoints
│   │   └── chat.php             # Chat endpoints
│   ├── utils/
│   │   └── helpers.php          # Helper functions (JWT, Response, Validator)
│   ├── .htaccess                # API routing
│   └── database.sql             # Database schema
│
├── lib/                          # Flutter Application
│   ├── config/
│   │   └── theme.dart           # App theme configuration
│   ├── controllers/             # GetX controllers
│   ├── models/                  # Data models
│   ├── routes/
│   │   ├── app_routes.dart      # Route constants
│   │   └── app_pages.dart       # Route pages mapping
│   ├── screens/                 # UI screens
│   │   ├── auth/               # Authentication screens
│   │   ├── home/               # Home screen
│   │   ├── dashboard/          # Dashboard screen
│   │   ├── profile/            # Profile screens
│   │   ├── services/           # Service request screens
│   │   ├── activities/         # Activities screens
│   │   ├── chat/               # Chat screen
│   │   └── family/             # Family management screens
│   ├── services/
│   │   ├── api_service.dart     # API service with Dio
│   │   ├── storage_service.dart # Local storage service
│   │   └── notification_service.dart # Notification service
│   ├── widgets/                 # Reusable widgets
│   ├── utils/                   # Utility functions
│   └── main.dart                # Main entry point
│
├── assets/                       # Assets (images, icons)
├── pubspec.yaml                 # Flutter dependencies
└── README.md                    # This file
```

## Setup Instructions

### Prerequisites
- Flutter SDK (>=3.0.0)
- PHP (>=7.4)
- MySQL (>=5.7)
- Apache/Nginx web server
- Android Studio or VS Code

### Backend Setup (PHP + MySQL)

1. **Setup Database**
   ```bash
   # Create database and import schema
   mysql -u root -p < api/database.sql
   ```

2. **Configure Database Connection**
   Edit `api/config/database.php`:
   ```php
   private $host = "localhost";
   private $db_name = "church_information_system";
   private $username = "root";
   private $password = "your_password";
   ```

3. **Setup Web Server**
   - Copy `api/` folder to your web server directory (e.g., `/var/www/html/church_api/`)
   - Ensure `.htaccess` is enabled (for Apache)
   - Enable `mod_rewrite` module

4. **Test API**
   ```bash
   # Test authentication endpoint
   curl -X POST http://localhost/church_api/auth/login \
     -H "Content-Type: application/json" \
     -d '{"email":"admin@church.com","password":"admin123"}'
   ```

### Frontend Setup (Flutter)

1. **Install Dependencies**
   ```bash
   flutter pub get
   ```

2. **Configure API Base URL**
   Edit `lib/services/api_service.dart`:
   ```dart
   static const String baseUrl = 'http://your-server.com/church_api';
   ```

3. **Run Application**
   ```bash
   # For Android
   flutter run

   # For iOS
   flutter run -d ios

   # For Web
   flutter run -d chrome
   ```

## API Endpoints

### Authentication
- `POST /auth/register` - Register new user
- `POST /auth/login` - Login user
- `POST /auth/logout` - Logout user

### Activities
- `GET /activities` - Get all activities
- `GET /activities/{id}` - Get activity details
- `POST /activities` - Create new activity (Admin)

### Services
- `POST /services/prayer-request` - Submit prayer request
- `GET /services/prayer-request` - Get user's prayer requests
- `POST /services/baptism-request` - Submit baptism request
- `GET /services/baptism-request` - Get user's baptism requests
- `POST /services/child-dedication` - Submit child dedication request
- `GET /services/child-dedication` - Get user's child dedication requests

### Family
- `GET /family/members` - Get family members
- `POST /family/members` - Add family member

### Chat
- `GET /chat/messages` - Get chat messages
- `POST /chat/messages` - Send message to admin

## Default Credentials

**Admin Account:**
- Email: `admin@church.com`
- Password: `admin123`

## Development Notes

### Best Practices
- Follow Flutter best practices with modular architecture
- Split widgets for reusability
- Use GetX for state management and navigation
- Implement responsive design for multiple devices
- Add documentation to all files and functions

### Security
- Use HTTPS in production
- Change JWT secret key in `api/utils/helpers.php`
- Update default admin password
- Implement rate limiting for API endpoints
- Sanitize all user inputs

### Future Enhancements
- Admin dashboard for managing activities and requests
- Push notifications using FCM
- Image upload for chat and profiles
- Multi-language support (Indonesian/English)
- Offline mode with data synchronization
- Report generation and analytics

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is open source and available under the [MIT License](LICENSE).

## Contact

For questions or support, please contact the development team.