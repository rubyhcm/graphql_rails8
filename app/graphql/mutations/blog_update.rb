# app/graphql/mutation/blog_update.rb
module Mutations
  class BlogUpdate < BaseMutation
    description "Updates a blog by id"

    field :blog, Types::BlogType, null: false

    argument :id, ID, required: true
    argument :title, String, required: false
    argument :description, String, required: false

    def resolve(id:, title:, description:)
      blog = ::Blog.find(id)
      raise GraphQL::ExecutionError.new "Error updating blog", extensions: blog.errors.to_hash unless blog.update(title:, description:)

      { blog: blog }
    end
  end
end
