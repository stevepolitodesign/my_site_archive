module GuestUser
  extend ActiveSupport::Concern

  private

    def create_guest_user
      user = User.new(email: "#{SecureRandom.uuid}@#{SecureRandom.uuid}.com", accepted_terms: true, guest: true)
      user.save!(validate: false)
      session[:guest_user_id] = user.id
      user
    end 

    def set_guest_user
      @user = User.find_by(id: session[:guest_user_id]).present? ? User.find_by(id: session[:guest_user_id]) : create_guest_user
    end
end