require "application_system_test_case"

class WebpageFlowsTest < ApplicationSystemTestCase
  def setup
    @website = websites(:one)
  end

  test "creating a webpage and associated html_document" do
    visit website_path(@website)

    fill_in "Title", with: "Title"
    click_button "Create Webpage"
  end
end
