class ArchivesController < ApplicationController
  include GuestUser

  before_action :set_guest_user, only: :create

  def new
    @archive = Archive.new
  end

  # TODO: Need to rate limit this action.
  def create
    # TODO: Need to build Website first
    @archive = @guest_user.archives.build(archive_params)
    if @archive.save
      @website = @archive.generate_report
      redirect_to archive_website_path(@archive, @website)
    else
      render :new
    end
  end

  def show
  end

  private

    def archive_params
      params.require(:archive).permit(:url)
    end

end
