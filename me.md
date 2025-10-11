# GraphQL setup

```ruby
bundle add graphql
rails generate graphql:install
```

## GraphiQL setup

`gem "graphiql-rails"`

```ruby
# add to routes.rb
if Rails.env.development?
  mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
end
```

For Rails as an API, add the following to access GraphiQL IDE on browser:

Add `require "sprockets/railtie"` to your `application.rb`
Create `app/assets/config/manifest.js` file with the following content:

```javascript
//= link graphiql/rails/application.css
//= link graphiql/rails/application.js
```

Now, start the server and visit <http://localhost:3000/graphiql>

## Create a mutation

```ruby
rails generate graphql:mutation CreateBlog

rails g graphql:mutation_update blog

rails g graphql:mutation_delete blog

rails g graphql:enum role
```

## Create a object

```ruby
rails g graphql:object blog
```

## Create a user

```ruby
mutation {
  signUpMutation(input: {
    firstName: "John"
    lastName: "Doe"
    email: "john@example.com"
    username: "johndoe"
    password: "MySecure123!"
    role: "author"
  }) {
    user {
      id
      firstName
      lastName
      email
      username
      role
    }
    token
    errors
  }
}
```

## Login

```ruby
mutation {
  signInMutation(input: {
    username: "johndoe"
    password: "MySecure123!"
  }) {
    token
    error
    user {
      id
      firstName
      lastName
      email
      username
      role
    }
  }
}
```

```shell
curl -X POST http://localhost:3000/graphql \
  -H "Content-Type: application/json" \
  -d '{
    "query": "mutation { signInMutation(input: { username: \"your_username\", password: \"your_password\" }) { token error user { id username } } }"
  }'
```

## Create a blog

```ruby
mutation {
  blogCreate(input: {
    title: "My First Blog Post"
    description: "This is the content of my blog post. It can be as long as you want and contain all your thoughts and ideas."
  }) {
    blog {
      id
      title
      description
      userName
      user {
        id
        username
        firstName
        lastName
      }
    }
  }
}
```

## Get blogs

```ruby
query {
  blogs {
    id
    title
    description
    createdAt
    userName
    user {
      username
      firstName
      lastName
    }
  }
}
```
