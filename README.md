# Rails GraphQL Blog Application

A modern Rails API application with GraphQL interface for managing blogs and users. Features JWT authentication, role-based permissions, and a complete blog management system.

## 🚀 Quick Start

### Prerequisites
- Ruby 3.x
- Rails 8.x
- SQLite3 (default) or PostgreSQL
- Node.js (for GraphiQL interface)

### Installation

1. **Clone and setup**
   ```bash
   git clone <repository-url>
   cd rails-graphql
   bundle install
   ```

2. **Database setup**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

3. **Start the server**
   ```bash
   rails server
   ```

4. **Access GraphiQL IDE**
   Visit: http://localhost:3000/graphiql

## 📚 Documentation

### Core Documentation
- **[GraphQL Setup & Usage Guide](./me.md)** - Complete guide for GraphQL operations, mutations, and queries
- **[Roles & Permissions](./permissions.md)** - Detailed documentation of the authentication and authorization system

### Key Features
- 🔐 **JWT Authentication** - Secure token-based authentication
- 👥 **Role-Based Access Control** - Author and Admin roles with different permissions
- 📝 **Blog Management** - Create, read, update, and delete blog posts
- 🔍 **GraphQL API** - Modern GraphQL interface with GraphiQL IDE
- 🛡️ **Security** - Strong password requirements and permission checks

## 🏗️ Architecture

### Technology Stack
- **Backend**: Ruby on Rails 8.x (API mode)
- **API**: GraphQL with graphql-ruby gem
- **Authentication**: JWT tokens with bcrypt
- **Database**: SQLite3 (development), configurable for production
- **Development Tools**: GraphiQL IDE for API exploration

### Database Schema
- **Users**: Authentication and profile information
- **Blogs**: Blog posts with user associations
- **Roles**: Author and Admin role system

## 🔧 Configuration

### Environment Variables
```bash
# JWT Secret (uses Rails.application.secret_key_base by default)
RAILS_MASTER_KEY=your_master_key_here
```

### Database Configuration
Default: SQLite3 for development
Production: Configure in `config/database.yml`

## 🧪 Testing

```bash
# Run all tests
rails test

# Run specific test files
rails test test/models/user_test.rb
rails test test/models/blog_test.rb
```

## 🚀 Deployment

### Using Kamal (Recommended)
```bash
# Setup deployment configuration
kamal setup

# Deploy application
kamal deploy
```

### Manual Deployment
1. Configure production database
2. Set environment variables
3. Precompile assets (if needed)
4. Run migrations
5. Start application server

## 📖 API Usage Examples

### Authentication
```graphql
# Sign up
mutation {
  signUpMutation(input: {
    firstName: "John"
    lastName: "Doe"
    email: "john@example.com"
    username: "johndoe"
    password: "MySecure123!"
  }) {
    user { id username }
    token
    errors
  }
}

# Sign in
mutation {
  signInMutation(input: {
    username: "johndoe"
    password: "MySecure123!"
  }) {
    token
    error
    user { id username role }
  }
}
```

### Blog Operations
```graphql
# Create blog (requires authentication)
mutation {
  blogCreate(input: {
    title: "My First Post"
    description: "Content of the blog post..."
  }) {
    blog {
      id
      title
      description
      userName
    }
  }
}

# Get all blogs (public)
query {
  blogs {
    id
    title
    description
    createdAt
    userName
  }
}
```

## 🔐 Security Features

- **Password Requirements**: 8+ characters with mixed case, numbers, and special characters
- **JWT Tokens**: 24-hour expiration with secure signing
- **Role-Based Permissions**: Different access levels for authors and admins
- **Input Validation**: GraphQL type validation and custom validations
- **Secure Headers**: Proper authorization header handling

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

- **Documentation**: Check the linked documentation files above
- **Issues**: Create an issue in the repository
- **GraphiQL**: Use the interactive GraphiQL interface for API exploration

---

**Quick Links:**
- [GraphQL Operations Guide](./me.md)
- [Security & Permissions](./permissions.md)
- [GraphiQL Interface](http://localhost:3000/graphiql) (when server is running)
