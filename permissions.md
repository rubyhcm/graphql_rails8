# 🔐 Roles and Permissions Documentation

## Overview
This Rails GraphQL application implements a role-based access control (RBAC) system using JWT authentication. The system supports different user roles with specific permissions for various operations.

## 👥 User Roles

### 1. **Author** (Default Role)
- **Description**: Regular users who can create and manage their own content
- **Default Role**: Yes (assigned automatically during registration)
- **Capabilities**: Content creation, profile management

### 2. **Admin**
- **Description**: Administrative users with elevated privileges
- **Default Role**: No (must be explicitly assigned)
- **Capabilities**: All author permissions + administrative functions

## 🔑 Authentication System

### JWT Token-Based Authentication
- **Token Type**: JSON Web Token (JWT)
- **Algorithm**: HS256
- **Secret**: `Rails.application.secret_key_base`
- **Expiration**: 24 hours from issuance
- **Header Format**: `Authorization: Bearer <token>`

### Token Payload Structure
```json
{
  "user_id": 123,
  "exp": 1728734400
}
```

## 📋 Detailed Permissions Matrix

| Operation | Public | Author | Admin | Notes |
|-----------|--------|--------|-------|-------|
| **Authentication** |
| Sign Up | ✅ | ✅ | ✅ | Anyone can register |
| Sign In | ✅ | ✅ | ✅ | Anyone can login |
| Get Current User | ❌ | ✅ | ✅ | Requires authentication |
| **Blog Operations** |
| View All Blogs | ✅ | ✅ | ✅ | Public read access |
| View Single Blog | ✅ | ✅ | ✅ | Public read access |
| Create Blog | ❌ | ✅ | ✅ | Must be authenticated |
| Update Blog | ❌ | ⚠️ | ⚠️ | Owner only (not implemented) |
| Delete Blog | ❌ | ❌ | ✅ | Admin only |
| **User Management** |
| View User Profile | ❌ | ✅ | ✅ | Own profile or admin |
| Update User Profile | ❌ | ⚠️ | ⚠️ | Not implemented |
| Delete User | ❌ | ❌ | ⚠️ | Not implemented |

**Legend:**
- ✅ Allowed
- ❌ Denied
- ⚠️ Partially implemented or needs enhancement

## 🛡️ Security Implementation

### Password Requirements
```ruby
PASSWORD_REGEXP = /\A
  (?=.{8,})          # At least 8 characters
  (?=.*\d)           # At least one digit
  (?=.*[a-z])        # At least one lowercase letter
  (?=.*[A-Z])        # At least one uppercase letter
  (?=.*[[:^alnum:]]) # At least one special character
/x
```

### Authentication Checks
1. **Token Validation**: JWT signature and expiration verification
2. **User Existence**: Verify user still exists in database
3. **Role Verification**: Check user role for protected operations

## 📝 GraphQL Operations by Permission Level

### Public Operations (No Authentication Required)
```graphql
# Sign up for new account
mutation {
  signUpMutation(input: { ... }) { ... }
}

# Sign in to existing account
mutation {
  signInMutation(input: { ... }) { ... }
}

# View all blogs
query {
  blogs { ... }
}

# View specific blog
query {
  blog(id: "1") { ... }
}
```

### Authenticated User Operations (Author + Admin)
```graphql
# Get current user info
query {
  currentUser { ... }
}

# Create new blog post
mutation {
  blogCreate(input: { ... }) { ... }
}
```

### Admin-Only Operations
```graphql
# Delete any blog post
mutation {
  blogDelete(input: { id: "1" }) { ... }
}
```

## 🔧 Implementation Details

### Role Enum Definition
```ruby
# app/graphql/types/role_type.rb
module Types
  class RoleType < Types::BaseEnum
    value "author"
    value "admin"
  end
end
```

### User Model Role Configuration
```ruby
# app/models/user.rb
class User < ApplicationRecord
  enum :role, %w[author admin]
  # This creates methods: author?, admin?, role_author?, role_admin?
end
```

### Permission Check Examples
```ruby
# Authentication check
raise GraphQL::ExecutionError, "Login required" unless context[:current_user]

# Admin role check
raise GraphQL::ExecutionError, "Admin access required" unless context[:current_user].admin?

# Author role check (if needed)
raise GraphQL::ExecutionError, "Author access required" unless context[:current_user].author?
```

## 🚨 Security Considerations

### Current Security Measures
1. **JWT Token Expiration**: 24-hour token lifetime
2. **Password Complexity**: Strong password requirements
3. **Role-Based Access**: Different permissions per role
4. **Input Validation**: GraphQL type validation
5. **Error Handling**: Secure error messages

### Security Gaps & Recommendations
1. **Blog Ownership**: Authors can't edit/delete their own blogs
2. **User Management**: No user profile update functionality
3. **Rate Limiting**: No API rate limiting implemented
4. **Audit Logging**: No activity logging for admin actions
5. **Password Reset**: No password reset functionality

## 🔄 Future Enhancements

### Recommended Improvements
1. **Blog Ownership Permissions**
   - Authors should edit/delete their own blogs
   - Implement ownership checks

2. **Enhanced User Management**
   - User profile updates
   - Admin user management interface
   - User deactivation/suspension

3. **Additional Security Features**
   - Password reset functionality
   - Two-factor authentication
   - Session management
   - API rate limiting

4. **Audit & Monitoring**
   - Activity logging
   - Admin action tracking
   - Security event monitoring

## 📚 Usage Examples

### Creating Admin User
```ruby
# In Rails console
user = User.create!(
  first_name: "Admin",
  last_name: "User",
  email: "admin@example.com",
  username: "admin",
  password: "AdminPass123!",
  role: "admin"
)
```

### Testing Permissions
```bash
# Test with GraphiQL at http://localhost:3000/graphiql
# 1. Sign in to get token
# 2. Add Authorization header: {"Authorization": "Bearer <token>"}
# 3. Try different operations based on your role
```
