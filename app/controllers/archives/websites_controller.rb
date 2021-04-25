class Archives::WebsitesController < ApplicationController
  before_action :set_website, only: [:show]

  def show
    @zone_file      = @website.latest_zone_file
    @webpage        = @website.first_webpage
    @screenshot     = @webpage.latest_screenshot if @webpage.present?
    @html_document  = @screenshot.html_document if @screenshot
  end

  private

    def set_website
      @website = Website.find(params[:id])
    end
end
