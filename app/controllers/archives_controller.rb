class ArchivesController < ApplicationController
  layout "landing", only: [:new, :create]
  include GuestUser
  include Schemable

  before_action :set_guest_user, only: :create
  before_action :set_archive, only: [:show]

  def new
    @archive = Archive.new
  end

  # TODO: Need to rate limit this action.
  def create
    @archive = @guest_user.archives.build(archive_params)
    if ArchivePolicy.new(set_guest_user, @archive).new?
      if verify_recaptcha(model: @archive) && @archive.save
        @website = @archive.create_website_for_report
        @archive.generate_report(@website, archive_params[:url])
        redirect_to @archive
      else
        render :new
      end
    else
      redirect_to new_user_registration_path, alert: "You've hit your limit. Please create an account."
    end
  end

  def show
    @title          = @archive.url
    @website        = @archive.website
    @zone_file      = @website.latest_zone_file if @website.present?
    @webpage        = @website.first_webpage if @zone_file.present?
    @screenshot     = @webpage.latest_screenshot if @webpage.present?
    @html_document  = @screenshot.html_document if @screenshot.present?    
  end

  private

    def archive_params
      params.require(:archive).permit(:url)
    end

    def set_archive
      @archive = Archive.find(params[:id])
    end

end
