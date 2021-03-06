require 'test_helper'

class PlatformAdminDashboardTest < ActionDispatch::IntegrationTest
  test "A platform admin can see pending requests to become a new owner/host" do
    create_platform_admin
    login_platform_admin

    assert page.has_content?("Pending Owner Requests")
  end

  test "A platform admin can visit a page where they can see all owners and their current statuses" do
    create_user
    create_platform_admin
    create_owners(2, "active")
    create_owners(3, "inactive")
    login_platform_admin
    click_link("Manage Owners")

    assert_equal admin_owners_path, current_path
    assert page.has_content?("Admin Owners Index")
    within(".owners") do
      assert page.has_content?("active")
      assert page.has_content?("inactive")
    end
  end

  test "A platform admin can change an owner's current status from active to inactive" do
    create_user
    create_platform_admin
    create_owners(1, "active")
    login_platform_admin
    click_link("Manage Owners")

    within(".owners") do
      assert page.has_content?("active")
      refute page.has_content?("inactive")
    end
    click_link("make-inactive")
    within(".owners") do
      assert page.has_content?("inactive")
    end
  end

  test "A platform admin can change an owner's current status from inactive to active" do
    create_user
    create_platform_admin
    create_owners(1, "inactive")
    login_platform_admin
    click_link("Manage Owners")

    within(".owners") do
      assert page.has_content?("inactive")
    end

    click_link("make-active")
    within(".owners") do
      assert page.has_content?("active")
    end
  end

  test "Guest can't view the platform admin dashboard" do
    visit "admin/dashboard"

    assert page.has_content?("Back Off")
  end

  test "User can't view the platform admin dashboard" do
    create_and_login_user
    visit "admin/dashboard"

    assert page.has_content?("Back Off")
  end

  test "Store Owner can't view the platform admin dashboard" do
    create_owners(1, "active")
    create_and_login_owner
    visit admin_dashboard_path

    assert page.has_content?("Back Off")
  end

end
