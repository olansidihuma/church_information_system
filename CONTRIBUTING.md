# Contributing to Church Information System

Thank you for your interest in contributing to the Church Information System! This document provides guidelines and instructions for contributing to this project.

## Code of Conduct

By participating in this project, you agree to maintain a respectful and collaborative environment.

## How to Contribute

### Reporting Bugs

Before creating bug reports, please check existing issues. When creating a bug report, include:

- **Clear title and description**
- **Steps to reproduce** the issue
- **Expected behavior**
- **Actual behavior**
- **Screenshots** if applicable
- **Environment details** (OS, Flutter version, PHP version)

### Suggesting Enhancements

Enhancement suggestions are welcome! Include:

- **Clear title and description**
- **Use case** and benefits
- **Possible implementation** approach
- **Examples** from other applications if applicable

### Pull Requests

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Development Guidelines

### Flutter Code Style

- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused
- Use GetX for state management consistently

### PHP Code Style

- Follow [PSR-12 coding standard](https://www.php-fig.org/psr/psr-12/)
- Use meaningful variable and function names
- Add PHPDoc comments for functions
- Validate all inputs
- Use prepared statements for database queries

### File Organization

```
lib/
├── config/         # App configuration (theme, constants)
├── controllers/    # GetX controllers
├── models/         # Data models
├── routes/         # Route definitions
├── screens/        # UI screens
├── services/       # API and core services
├── widgets/        # Reusable widgets
└── utils/          # Utility functions

api/
├── config/         # Database config
├── controllers/    # API endpoints
├── models/         # Data models (if needed)
└── utils/          # Helper functions
```

### Commit Message Guidelines

Use clear and descriptive commit messages:

```
feat: add prayer request notification
fix: resolve login authentication issue
docs: update API documentation
style: format code according to style guide
refactor: restructure user service
test: add tests for authentication
```

### Branch Naming

- `feature/` - New features
- `bugfix/` - Bug fixes
- `hotfix/` - Critical fixes
- `docs/` - Documentation updates
- `refactor/` - Code refactoring

Examples:
- `feature/add-push-notifications`
- `bugfix/fix-login-error`
- `docs/update-setup-guide`

## Testing

### Flutter Testing

```bash
# Run all tests
flutter test

# Run specific test
flutter test test/controllers/login_controller_test.dart

# Run with coverage
flutter test --coverage
```

### API Testing

- Test all endpoints with Postman or cURL
- Verify authentication works correctly
- Test error handling
- Check database transactions

## Documentation

- Update README.md for new features
- Update API_DOCS.md for API changes
- Update SETUP.md for configuration changes
- Add inline comments for complex code

## Feature Development Checklist

- [ ] Code follows project style guidelines
- [ ] Comments added for complex logic
- [ ] Tested on Android/iOS/Web
- [ ] API endpoints tested
- [ ] Documentation updated
- [ ] No console errors or warnings
- [ ] Pull request description is clear

## Security Guidelines

- Never commit sensitive data (API keys, passwords)
- Validate all user inputs
- Use parameterized queries
- Implement proper authentication
- Follow security best practices
- Report security vulnerabilities privately

## Questions?

Feel free to open an issue for questions or clarifications about contributing.

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
