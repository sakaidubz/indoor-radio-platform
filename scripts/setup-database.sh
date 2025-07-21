#!/bin/bash

# Indoor Radio Platform - Database Setup Script

echo "🎧 Indoor Radio Platform - Database Setup"
echo "=========================================="

# Check if PostgreSQL is installed
if ! command -v psql &> /dev/null; then
    echo "❌ PostgreSQL is not installed. Please install PostgreSQL first."
    echo "   macOS: brew install postgresql"
    echo "   Ubuntu: sudo apt-get install postgresql postgresql-contrib"
    exit 1
fi

# Check if PostgreSQL service is running
if ! pg_isready &> /dev/null; then
    echo "❌ PostgreSQL service is not running."
    echo "   macOS: brew services start postgresql"
    echo "   Ubuntu: sudo systemctl start postgresql"
    exit 1
fi

echo "✅ PostgreSQL is installed and running"

# Database configuration
DB_NAME="indoor_radio_db"
DB_USER="indoor_radio"
DB_PASSWORD="indoor_radio_password"

echo ""
echo "Creating database and user..."

# Create user and database
psql postgres << EOF
-- Create user if not exists
DO \$\$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = '$DB_USER') THEN
        CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';
    END IF;
END
\$\$;

-- Create database if not exists
SELECT 'CREATE DATABASE $DB_NAME OWNER $DB_USER'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '$DB_NAME')\gexec

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;
ALTER USER $DB_USER CREATEDB;

\q
EOF

if [ $? -eq 0 ]; then
    echo "✅ Database '$DB_NAME' and user '$DB_USER' created successfully"
else
    echo "❌ Failed to create database or user"
    exit 1
fi

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo ""
    echo "Creating .env file..."
    cat > .env << EOF
# Environment
ENVIRONMENT=development

# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_USER=$DB_USER
DB_PASSWORD=$DB_PASSWORD
DB_NAME=$DB_NAME
DB_SSL_MODE=disable

# JWT Configuration
JWT_SECRET=your_jwt_secret_key_change_this_in_production

# AWS Configuration (for future use)
AWS_REGION=ap-northeast-1
AWS_S3_BUCKET=indoor-radio-assets

# External API Configuration (add your keys when ready)
X_API_KEY=
X_API_SECRET=
INSTAGRAM_ACCESS_TOKEN=
SOUNDCLOUD_CLIENT_ID=

# Server Configuration
PORT=8080
EOF
    echo "✅ .env file created with database configuration"
else
    echo "⚠️  .env file already exists, skipping creation"
fi

echo ""
echo "🎉 Database setup completed!"
echo ""
echo "Next steps:"
echo "1. Review and update .env file if needed"
echo "2. Run: go run cmd/server/main.go"
echo "3. The application will automatically create tables on first run"
echo ""
echo "Database connection details:"
echo "  Host: localhost"
echo "  Port: 5432"
echo "  Database: $DB_NAME"
echo "  User: $DB_USER"
echo "  Password: $DB_PASSWORD"
