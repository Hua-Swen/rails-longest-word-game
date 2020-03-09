require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  # test "visiting the index" do
  #   visit games_url
  #
  #   assert_selector "h1", text: "Game"
  # end
  test "Going to /new gives a new random grid" do
    visit new_url
    assert test: "New game"
    assert_selector "li", count: 10
  end

  test "Giving a random word should return not in grid" do
    visit new_url
    fill_in "answer", with: "test"
    click_on "Play"
    assert_text "Sorry"
  end

end
