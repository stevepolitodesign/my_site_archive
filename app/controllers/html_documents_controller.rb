class HtmlDocumentsController < ApplicationController
  layout :false

  before_action :set_website
  before_action :set_html_document

  def show
    authorize @website
    render plain: @html_document.source_code.html_safe
  end

  private

    def set_website
      @website = Website.find(params[:website_id])
    end

    def set_html_document
      @html_document = HtmlDocument.find(params[:id])
    end
end
