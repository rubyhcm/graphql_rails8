class User < ApplicationRecord
  PASSWORD_REGEXP = /\A
    (?=.{8,})
    (?=.*\d)
    (?=.*[a-z])
    (?=.*[A-Z])
    (?=.*[[:^alnum:]])
  /x

  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :password, format: { with: PASSWORD_REGEXP, message: "condition failed" }

  has_many :blogs, dependent: :destroy
  before_save { self.email = email.downcase }

  # remaining code
  enum :role, %w[author admin]
end
