require "application_system_test_case"

class AuthorsTest < ApplicationSystemTestCase
  setup do
    @author = authors(:one)
  end

  test "visiting the index" do
    visit authors_url
    assert_selector "h1", text: "Authors"
  end

  test "should create author" do
    visit authors_url
    click_on "New author"

    fill_in "Bio", with: @author.bio
    fill_in "Birth date", with: @author.birth_date
    fill_in "Email", with: @author.email
    fill_in "Name", with: @author.name
    fill_in "Phone number", with: @author.phone_number
    click_on "Create Author"

    assert_text "Author was successfully created"
    click_on "Back"
  end

  test "should update Author" do
    visit author_url(@author)
    click_on "Edit this author", match: :first

    fill_in "Bio", with: @author.bio
    fill_in "Birth date", with: @author.birth_date
    fill_in "Email", with: @author.email
    fill_in "Name", with: @author.name
    fill_in "Phone number", with: @author.phone_number
    click_on "Update Author"

    assert_text "Author was successfully updated"
    click_on "Back"
  end

  test "should destroy Author" do
    visit author_url(@author)
    accept_confirm { click_on "Destroy this author", match: :first }

    assert_text "Author was successfully destroyed"
  end
end
