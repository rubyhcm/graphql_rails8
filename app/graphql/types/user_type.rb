# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    description "A user in the system"

    field :id, ID, null: false
    field :first_name, String, null: true
    field :last_name, String, null: true
    field :email, String, null: false
    field :username, String, null: true
    field :role, Types::RoleType, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    
    # Association fields
    field :blogs, [Types::BlogType], null: true
    
    def blogs
      object.blogs
    end
  end
end
