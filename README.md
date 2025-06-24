# Portfolia - Personal Portfolio Management

A Rails application for managing personal investment accounts, balances, and holdings with user authentication and OAuth2 support.

## Features

- **User Authentication**: Secure login with password hashing and OAuth2 tokens
- **Account Management**: Create and manage investment accounts with different types
- **Balance Tracking**: Historical balance tracking with CAD conversion rates
- **CSV Import**: Bulk import accounts and balances from CSV files
- **Charts**: Visual representation of account performance using Chartkick
- **Multi-currency Support**: Support for different currencies with FX rate conversion

## Development Environment

### Prerequisites

- Ruby 3.4.4
- Rails 7.1
- PostgreSQL
- Node.js (for Tailwind CSS)

### Setup

1. **Clone and install dependencies:**

   ```bash
   git clone <repository-url>
   cd portfolia
   bundle install
   ```

2. **Database setup:**

   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

3. **Start the development server:**

   ```bash
   bin/dev
   ```

   This starts both the Rails server and Tailwind CSS watcher.

### Running the server

```bash
# Development mode with Tailwind CSS
bin/dev

# Or separately
rails server
bin/tailwindcss --watch
```

### Database creation and initialization

```bash
# Create database
rails db:create

# Run migrations
rails db:migrate

# Seed with initial data
rails db:seed

# Reset database (development only)
rails db:reset
```

## Authentication

### Creating a new user

#### Via Rails Console

```ruby
# Create a user with secure password
user = User.create!(
  email: 'user@example.com',
  password: 'secure_password',
  password_confirmation: 'secure_password'
)
```

#### Via Web Interface

1. Navigate to `/login`
2. Use the login form with your credentials
3. New users can be created via Rails console or seeded data

### OAuth2 Authentication

The application uses Doorkeeper for OAuth2 authentication with password grant flow:

- **Grant Type**: Password Grant
- **Token Expiration**: 2 hours (configurable)
- **Client Authentication**: Skipped for password grant

#### API Authentication

```bash
# Get access token
curl -X POST http://localhost:3000/oauth/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=password&username=user@example.com&password=secure_password"

# Use token for API requests
curl -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  http://localhost:3000/accounts
```

### Creating an OAuth Application

OAuth applications are automatically created for the web interface. For custom applications:

```ruby
# Via Rails console
app = Doorkeeper::Application.create!(
  name: 'My App',
  redirect_uri: 'urn:ietf:wg:oauth:2.0:oob',
  scopes: ''
)
```

## Database Schema

### Core Models

- **User**: Authentication and user management
- **Account**: Investment accounts with types (chequing, savings, investment, etc.)
- **AccountBalance**: Historical balance records with FX rates
- **Holding**: Individual securities held in accounts

### Key Relationships

- Users have many accounts (with cascade delete)
- Accounts belong to users (scoped access)
- Accounts have many balances and holdings
- Account names are unique per user

## Testing

### Running the test suite

```bash
# Run all tests
bundle exec rspec

# Run specific test files
bundle exec rspec spec/models/account_spec.rb

# Run with coverage
COVERAGE=true bundle exec rspec
```

### Test Structure

- **Model specs**: Validations, associations, and business logic
- **Controller specs**: Authentication and authorization
- **Request specs**: API endpoints and user flows
- **View specs**: UI components and forms

## Codebase

### Services

- **AccountCsvImporter**: Handles bulk import of accounts and balances from CSV files
  - Scoped to authenticated user
  - Validates required fields and data integrity
  - Supports multiple currencies and FX rates

### Architecture

#### Authentication Flow

1. **Web Interface**: Session-based authentication with OAuth token generation
2. **API Access**: OAuth2 token-based authentication
3. **User Scoping**: All data access is scoped to authenticated user

#### Security Features

- Password hashing with bcrypt
- OAuth2 token management
- User-scoped data access
- CSRF protection
- Strong parameters for all forms

#### Data Import

- CSV import with validation
- User-scoped account creation
- Error handling and reporting
- Support for historical balance data

### UI / UX

#### Styling

- **Tailwind CSS**: Utility-first CSS framework
- **Responsive Design**: Mobile-friendly interface
- **Modern Components**: Clean, professional appearance

#### Key Pages

- **Login**: Secure authentication form
- **Accounts Index**: Overview of all user accounts with total balance
- **Account Show**: Detailed view with balance history and charts
- **Account New/Edit**: Forms for account management
- **Import**: CSV file upload interface

#### Charts

- **Chartkick + Chart.js**: Interactive line charts
- **Historical Data**: Balance and book value over time
- **Date Handling**: Proper timezone and date formatting

## API Endpoints

### Authentication

- `POST /oauth/token` - Get access token
- `POST /sessions` - Login (web)
- `DELETE /sessions` - Logout

### Accounts

- `GET /accounts` - List user's accounts
- `GET /accounts/:id` - Show account details
- `POST /accounts` - Create new account
- `GET /accounts/new` - New account form

### Import

- `GET /imports` - Import interface
- `POST /imports` - Process CSV import

## Configuration

### Environment Variables

- Database configuration in `config/database.yml`
- OAuth settings in `config/initializers/doorkeeper.rb`
- Asset compilation in `config/application.rb`

### Tailwind CSS

- Configuration in `config/tailwind.config.js`
- Custom styles in `app/assets/stylesheets/application.tailwind.css`

## Deployment

### Production Considerations

- Set up proper database credentials
- Configure OAuth application settings
- Set up SSL certificates
- Configure asset compilation
- Set up proper logging and monitoring

### Docker Support

- Dockerfile included for containerized deployment
- Multi-stage build for optimized production images

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes with tests
4. Ensure all tests pass
5. Submit a pull request

## License

This project is licensed under the terms specified in the LICENSE file.
