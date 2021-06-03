module GuestUser
  extend ActiveSupport::Concern

  private

    def create_guest_user
      user = User.new(email: "#{SecureRandom.uuid}@#{SecureRandom.uuid}.com", accepted_terms: true, guest: true)
      user.skip_confirmation!
      user.save!(validate: false)
      session[:guest_user_id] = user.id
      user
    end 

    def destroy_guest_user_session
      session[:guest_user_id] = nil
    end

    def set_guest_user
      @guest_user = User.find_by(id: session[:guest_user_id]).present? ? User.find_by(id: session[:guest_user_id]) : create_guest_user
    end

end