require 'test_helper'

class PurgeGuestAccountsJobTest < ActiveJob::TestCase
  test "should destroy guest user and associated records" do
    assert_difference ->{ Archive.count } => -1 ->{ Website.count } => -1,  ->{ Webpage.count } => -1,  ->{ Screenshot.count } => -1, ->{ HtmlDocument.count } => -1, ->{ Stat.count } => -1 do
      User.guest.not_confirmed.destroy_all
    end
  end
end
