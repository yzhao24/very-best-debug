require "rails_helper"

describe "/users" do
  it "has a functional Route Controller Action View", :points => 1 do
    visit "/users"

    expect(page.status_code).to be(200)
  end
end

describe "Home page" do
  it "is the same page as the /users page", :points => 1, hint: h("copy_must_match") do
    visit "/"
    root_page = page
    
    visit "/users"
    expect(page).to eql(root_page)
  end
end

describe "/users" do
  it "displays each User record in a tr html element", :points => 3 do
    user = User.new
    user.username = "alice_#{rand(100)}"
    user.save

    user = User.new
    user.username = "bob_#{rand(100)}"
    user.save

    visit "/users"

    expect(page).to have_css("tr", minimum: 2)
  end
end

describe "/users" do
  it "displays a link to each User's details page", :points => 1 do
    user = User.new
    user.username = "alice_#{rand(100)}"
    user.save

    user = User.new
    user.username = "bob_#{rand(100)}"
    user.save
    visit "/users"

    expect(page).to have_css("a[href*='/users/']", minimum: 2)
  end
end

describe "/users" do
  it "has one form to add a new User", :points => 1 do
    visit "/users"

    expect(page).to have_css("form", minimum: 1)
  end
end

describe "/users" do
  it "has a label with the text 'Username'", :points => 1, hint: h("copy_must_match label_for_input") do
    visit "/users"

    expect(page).to have_css("label", text: "Username")
  end
end

describe "/users" do
  it "has a button with the text 'Add user'", :points => 1, hint: h("copy_must_match") do
    visit "/users"

    expect(page).to have_css("button", text: "Add user")
  end
end

describe "/users" do
  it "displays the usernames of all users", :points => 1 do
    first_user = User.new
    first_user.username = "alice_#{rand(100)}"
    first_user.save

    second_user = User.new
    second_user.username = "bob_#{rand(100)}"
    second_user.save

    visit "/users"

    expect(page).to have_content(first_user.username)
    expect(page).to have_content(second_user.username)
  end
end

describe "/users" do
  it "Add user form creates a user record when the form is submitted", :points => 2, hint: h("button_type") do
    initial_number_of_users = User.count

    visit "/users"
    fill_in("Username", with: "test_username")

    click_on "Add user"

    final_number_of_users = User.count

    expect(final_number_of_users).to eq(initial_number_of_users + 1)
  end
end

describe "/users" do
  it "Add user form saves the username when submitted", :points => 3, hint: h("label_for_input") do
    test_username = "photogram-gui-test-user"

    visit "/users"
    fill_in("Username", with: test_username)
    click_on "Add user"

    last_user = User.order(created_at: :asc).last
    expect(last_user.username).to eq(test_username)
  end
end

describe "/users" do
  it "Add user form redirects to /users/[USERNAME] page when submitted", :points => 1, hint: h("redirect_vs_render") do
    visit "/users"
    test_username = "macho_bagel"

    fill_in("Username", with: test_username)

    click_on "Add user"

    expect(page).to have_current_path("/users/#{test_username}")
  end
end

describe "/users/[username]" do
  it "has a functional Route Controller Action View", :points => 1 do
    user = User.new
    user.username = "nasty_code_smeller_#{rand(100)}"
    user.save

    visit "/users/#{user.username}"

    expect(page.status_code).to be(200)
  end
end

describe "/users/[username]" do
  it "displays the username of the user", :points => 1 do
    user = User.new
    user.username = "extreme_bagel_fan_#{rand(100)}"
    user.save

    visit "/users/#{user.username}"

    expect(page).to have_content(user.username)
  end
end

describe "/users/[username]" do
  it "has a label for 'Username', with text: 'Username'", :points => 1, hint: h("copy_must_match label_for_input") do
    user = User.new
    user.username = "alice_#{rand(100)}"
    user.save
    visit "/users/#{user.username}"

    expect(page).to have_css("label", text: "Username")
  end
end

describe "/users/[username]" do
  it "has a button with text, 'Update user'", :points => 1, hint: h("label_for_input") do
    user = User.new
    user.username = "alice_#{rand(100)}"
    user.save
    visit "/users/#{user.username}"

    expect(page).to have_css("button", text: "Update user")
  end
end

describe "/users/[username]" do
  it "has username prepopulated in an input element", :points => 1, hint: h("value_attribute") do
    user = User.new
    user.username = "dannydevito4twenty"
    user.save

    visit "/users/#{user.username}"

    expect(page).to have_css("input[value='dannydevito4twenty']")
  end
end


describe "/users/[USERNAME]" do
  it "Update user form updates username when submitted", :points => 3, hint: h("label_for_input button_type") do
    user = User.new
    user.username = "jeff_b_is_evil"
    user.save

    test_username = "new_user"

    visit "/users/#{user.username}"
    fill_in "Username", with: test_username
    click_on "Update user"

    user_as_revised = User.where({:id => user.id}).first

    expect(user_as_revised.username).to eq(test_username)
  end
end


describe "/users/[USERNAME]" do
  it "Update user form redirects to /users/[USERNAME] page", :points => 1, hint: h("embed_vs_interpolate redirect_vs_render") do
    user = User.new
    user.username = "alice_#{rand(100)}"
    user.save

    visit "/users/#{user.username}"
    click_on "Update user"

    expect(page).to have_current_path("/users/#{user.username}")
  end
end
