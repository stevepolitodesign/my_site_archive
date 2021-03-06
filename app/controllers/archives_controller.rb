class ArchivesController < ApplicationController
  layout "landing", only: [:new, :create]
  include GuestUser
  include Schemable

  before_action :set_guest_user, only: :create
  before_action :set_archive, only: [:show]

  def new
    @archive = Archive.new
    set_meta_tags(
      title: "Archive Your Website For Free",
      description: "This free tool will take a screenshot, capture the source code and run a performance audit of any webpage. It also does a DNS look-up on the root domain.",
      og: {
        image: "https://mugshotbot.com/m/HBQnrzXu",
        title: "A Better Wayback Machine",
      },
      twitter: {
          card: "summary_large_image",
          title: "A Better Wayback Machine",
      }
    )
  end

  # TODO: Need to rate limit this action.
  def create

    success = verify_recaptcha(action: 'archive', minimum_score: 0.5, secret_key: Rails.application.credentials.dig(:recaptcha_v3, :secret_key))
    checkbox_success = verify_recaptcha(secret_key: Rails.application.credentials.dig(:recaptcha_v2, :secret_key)) unless success

    if success || checkbox_success
      @archive = @guest_user.archives.build(archive_params)
      if ArchivePolicy.new(set_guest_user, @archive).new?
        if @archive.save
          @website = @archive.create_website_for_report
          @archive.generate_report(@website, archive_params[:url])
          redirect_to @archive
        else
          render :new, status: :unprocessable_entity
        end
      else
        redirect_to new_user_registration_path, alert: "You've reached your daily limit. Want unlimited access? Sign up today for a 30 day free trial today!"
      end
    else
      if !success
        @show_checkbox_recaptcha = true
        @archive = Archive.new
      end
      render 'new'
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
