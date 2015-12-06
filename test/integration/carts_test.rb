require "test_helper"

class CartsTest < ActionDispatch::IntegrationTest
  test "guest can add item to cart" do
    create_rentals(1, "Castle")
    rental = RentalType.find_by_name("Castle").rentals.first
    visit rental_path(rental)
    assert page.has_content?("Trips: 0")
    click_link "Purchase Trip"

    assert_equal new_cart_rental_path, current_path
    click_button "Place Order"

    assert page.has_content?("Trips: 1")
    assert_equal rentals_path, current_path
    assert page.has_content?("You have added Name 1 to your cart.")
  end

  test "guest can view cart" do
    visit rentals_path
    add_item_to_cart
    click_link "Trips: 1"

    assert_equal "/cart", current_path
    assert page.has_content?("Name")
    assert page.has_content?("Price: $1,001")
  end

  test "guest can delete item from cart" do
    add_item_to_cart
    removed_rental = Rental.find_by_name("Name 1")
    visit "/cart"

    click_button("Remove")

    assert_equal "/cart", current_path
    assert page.has_content?("You have removed the trip Name 1 from your cart.")
    assert page.has_content?("No items in cart.")

    click_link("Name 1")
    assert_equal rental_path(removed_rental), current_path
  end

  test "cart remains after a guest logs in" do
    add_item_to_cart
    create_and_login_user
    visit "/cart"

    assert page.has_content?("Name 1")
  end

  test "cart resets to empty when user checks out" do
    checkout_user
    visit rentals_path

    assert page.has_content?("Trips: 0")
  end
end
