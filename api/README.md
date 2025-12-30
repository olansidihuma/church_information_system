# Church Information System API

## PHP Native REST API with MySQL

### Setup Instructions

1. **Database Setup**
   ```bash
   mysql -u root -p < database.sql
   ```

2. **Configure Database**
   Edit `config/database.php` with your database credentials.

3. **Web Server Setup**
   - Ensure `.htaccess` is enabled
   - Enable mod_rewrite for Apache
   - Copy this directory to your web server root

4. **Test API**
   ```bash
   curl -X POST http://localhost/api/auth/login \
     -H "Content-Type: application/json" \
     -d '{"email":"admin@church.com","password":"admin123"}'
   ```

### API Endpoints

See main README.md for complete API documentation.

### Security Notes

- Change JWT secret key in `utils/helpers.php`
- Use HTTPS in production
- Implement rate limiting
- Update default admin password
