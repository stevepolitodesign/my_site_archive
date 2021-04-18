class ArchivesController < ApplicationController
  include GuestUser

  before_action :set_guest_user, only: :create

  def new
    @archive = Archive.new
  end

  # TODO: Need to rate limit this action.
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

end
