# app/graphql/mutation/blog_delete.rb
module Mutations
  class BlogDelete < BaseMutation
    description "Deletes a blog by ID"

    field :message, String, null: false

    argument :id, ID, required: true

    def resolve(id:)
      # Check authentication
      raise GraphQL::ExecutionError, "Login to access" unless context[:current_user]
      raise GraphQL::ExecutionError, "Only admins can delete the blogs" unless context[:current_user].admin?

      blog = ::Blog.find(id)
      raise GraphQL::ExecutionError.new "Error deleting blog", extensions: blog.errors.to_hash unless blog.destroy!

      { message: "Blog deleted successfully" }
    end
  end
end
