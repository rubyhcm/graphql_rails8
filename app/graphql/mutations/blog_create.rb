module Mutations
  class BlogCreate < BaseMutation
    description "Creates a new blog"

    field :blog, Types::BlogType, null: false

    argument :title, String, required: true
    argument :description, String, required: true

    def resolve(title:, description:)
      # Check if user is authenticated
      raise GraphQL::ExecutionError, "You must be logged in to create a blog" unless context[:current_user]

      # Create blog for the authenticated user
      blog = Blog.new(
        title: title,
        description: description,
        user: context[:current_user]
      )

      raise GraphQL::ExecutionError.new "Error creating blog", extensions: blog.errors.to_hash unless blog.save

      { blog: blog }
    end
  end
end
