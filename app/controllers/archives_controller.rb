class ArchivesController < ApplicationController
  def new
    @archive = Archive.new
  end

  def create
    @archive = Archive.new(archive_params)
  end

  private

    def archive_params
      params.require(:archive).permit(:url)
    end
end
