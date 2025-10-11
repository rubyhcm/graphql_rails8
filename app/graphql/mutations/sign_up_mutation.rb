# frozen_string_literal: true

module Mutations
  class SignUpMutation < BaseMutation
    description "Creates a new user account"

    argument :first_name, String, required: true
    argument :last_name, String, required: true
    argument :email, String, required: true
    argument :username, String, required: true
    argument :password, String, required: true
    argument :role, String, required: false

    field :user, Types::UserType, null: true
    field :token, String, null: true
    field :errors, [String], null: true

    def resolve(first_name:, last_name:, email:, username:, password:, role: "author")
      user = User.new(
        first_name: first_name,
        last_name: last_name,
        email: email,
        username: username,
        password: password,
        role: role
      )

      if user.save
        # Generate JWT token for the new user
        token = JWT.encode(
          { user_id: user.id, exp: 24.hours.from_now.to_i },
          jwt_secret,
          "HS256"
        )

        {
          user: user,
          token: token,
          errors: []
        }
      else
        {
          user: nil,
          token: nil,
          errors: user.errors.full_messages
        }
      end
    end

    private

    def jwt_secret
      Rails.application.secret_key_base
    end
  end
end
