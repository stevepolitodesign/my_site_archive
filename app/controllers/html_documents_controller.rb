class HtmlDocumentsController < ApplicationController
    # TODO: Authenticate subscription 
    before_action :set_html_ducument, only: [:show]

    def show
    end

    private

        def set_html_ducument
            @html_ducument = HtmlDocument.find(params[:id])
        end
end
