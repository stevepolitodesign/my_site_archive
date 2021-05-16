class HtmlDocumentsController < ApplicationController
  before_action :set_website
  before_action :set_html_document

  def show
    authorize @website
  end

  private

    def set_website
      @website = Website.find(params[:website_id])
    end

    def set_html_document
      @html_document = HtmlDocument.find(params[:id])
    end
end
