require "test_helper"

class OwnerRentalsTest < ActionDispatch::IntegrationTest
  test "owner can create a rental" do
    login_owner
    click_link("Add Rental")
    assert_equal new_owners_rental_path, current_path
    assert page.has_content?("Add a New Rental")
    fill_in "Name", with: "Brick Castle"
    fill_in "Description", with: "Have a ball sleeping in the alps!"
    fill_in "Price", with: 1000
    fill_in "Rental type", with: "Castle"
    click_button "Create Rental"

    assert_equal "/owners/dashboard", current_path
    assert page.has_content?("The rental 'Brick Castle' has been created")
    assert page.has_content?("Brick Castle")
  end

  test "owner can create a rental and must have name" do
    login_owner
    click_link("Add Rental")
    assert_equal new_owners_rental_path, current_path
    assert page.has_content?("Add a New Rental")
    fill_in "Name", with: ""
    fill_in "Description", with: "Have a ball sleeping in the alps!"
    fill_in "Price", with: 1000
    fill_in "Rental type", with: "Castle"
    click_button "Create Rental"

    assert_equal new_owners_rental_path, current_path
    refute page.has_content?("The rental 'Brick Castle' has been created")
    assert page.has_content?("Name can't be blank")
  end

  test "owner can view all rentals" do
    create_rentals(2, "Castle")
    login_owner
    click_link ("View All Rentals")

    assert "/owners/rentals", current_path
    assert page.has_content?("Rentals")
    assert page.has_content?("Castle 1")
    assert page.has_content?("Castle 2")
  end

  test "owner can view a single rentals details" do
    create_rentals(1, "Castle")
    login_owner
    click_link ("View All Rentals")
    click_link ("Details")

    assert "/owners/rentals/castle_1", current_path
    assert page.has_content?("No dragons allowed.")
  end

  test "owner can edit an existing rental" do
    create_rentals(1, "Castle")
    login_owner
    click_link ("View All Rentals")
    click_button "Edit"
    assert "/owners/rentals/#{Rental.first.id}/edit", current_path

    fill_in "Name",   with: "Neuschwanstein"
    fill_in "Price",  with: 650
    fill_in "Status", with: "Active"
    click_button "Update Rental"

    assert owners_dashboard_path, current_path
    assert page.has_content?("Neuschwanstein")
    refute page.has_content?("Castle 1")
  end

  test "owner can edit an existing rental and must have name" do
    create_rentals(1, "Castle")
    login_owner
    click_link ("View All Rentals")
    click_button "Edit"
    fill_in "Name",   with: ""
    fill_in "Price",  with: 650
    fill_in "Status", with: "Active"
    click_button "Update Rental"

    assert new_owners_rental_path, current_path
    assert page.has_content?("Name can't be blank")
  end

  test "owner can delete an existing rental" do
    create_rentals(1, "Castle")
    login_owner
    click_link ("View All Rentals")

    assert owners_rentals_path, current_path
    assert page.has_content?("Castle")
    click_button "Delete"

    assert owners_rentals_path, current_path
    refute page.has_content?("Castle 1")
  end

  test "regular user cannot access new rental path" do
    create_and_login_user
    visit new_owners_rental_path

    assert page.has_content?("Back Off")
    refute page.has_content?("Add a New Rental")
  end
end