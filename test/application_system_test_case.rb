require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]

  def fill_out_subscription_form(
    card_number = "4242 4242 4242 4242",
    exp_date = (1.year.from_now).strftime("%m%y"),
    cvc = "123",
    postal = "01234",
    name = "John Q. Sample"
  )
    frame = find("iframe")
    within_frame(frame) do
      find_field("cardnumber", visible: :all).send_keys(card_number)
      find_field("exp-date", visible: :all).send_keys(
        (1.year.from_now).strftime("%m%y")
      )
      find_field("cvc", visible: :all).send_keys(cvc)
      find_field("postal", visible: :all).send_keys(postal)
    end
    fill_in "Name on card", with: name
  end

end
