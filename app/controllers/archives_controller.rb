class ArchivesController < ApplicationController
  def new
    @archive = Archive.new(archive_params)
  end

  def create
  end

  private

    def archive_params
      params.require(:archive).permit(:url)
    end
end
