class User < ApplicationRecord
  # attr_accessor :skip_password_validation
  before_validation :set_password, on: :create

  # Include default devise modules. Others available are:
  # :database_authenticatable, :recoverable, :lockable,
  # :timeoutable, :trackable and :omniauthable
  # devise :database_authenticatable, :validatable #, :rememberable
  devise :sgid_authenticatable, :validatable
         # :registerable, #, :confirmable

  def password_required?
    false
  end

  private

  def set_password
    tmp_passwd = SecureRandom.alphanumeric(20)
    self.password = tmp_passwd
    self.password_confirmation = tmp_passwd
  end
end
