class ArchivesController < ApplicationController
  before_action :set_guest_user, only: :create

  def new
    @archive = Archive.new
  end

  def create
    @archive          = Archive.new(archive_params)
    @archive.user_id  = @user.id
    if @archive.valid?
      @archive.generate_report
    else
      render :new
    end
  end

  private

    def archive_params
      params.require(:archive).permit(:url)
    end

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
