class User < ApplicationRecord
  include Pay::Billable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :trackable

  has_many :websites, dependent: :destroy

  def destroy
    self.subscription.cancel_now! if self.subscribed?
    super
  end
end
