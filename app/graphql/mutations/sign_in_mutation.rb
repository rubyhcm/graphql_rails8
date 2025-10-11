# frozen_string_literal: true

module Mutations
  class SignInMutation < BaseMutation
    argument :username, String, required: true
    argument :password, String, required: true

    field :token, String, null: true
    field :error, String, null: true
    field :user, Types::UserType, null: true

    def resolve(username:, password:)
      raise GraphQL::ExecutionError, "User already signed in" if context[:current_user]

      # Find user by username and authenticate
      user = User.find_by(username: username)&.authenticate(password)

      return { error: "Username or Password is incorrect", token: nil, user: nil } unless user

      # Generate JWT token
      begin
        token = JWT.encode(
          { user_id: user.id, exp: 24.hours.from_now.to_i },
          jwt_secret,
          "HS256"
        )

        {
          token: token,
          error: nil,
          user: user
        }
      rescue StandardError
        {
          error: "Failed to generate token",
          token: nil,
          user: nil
        }
      end
    end

    private

    def jwt_secret
      Rails.application.secret_key_base
    end
  end
end
