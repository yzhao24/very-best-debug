require "rails_helper"

describe "/venues" do
  it "has a functional Route Controller Action View", :points => 1 do
    visit "/venues"

    expect(page.status_code).to be(200)
  end
end

describe "/venues" do
  it "has a form", :points => 1 do
    visit "/venues"

    expect(page).to have_css("form", minimum: 1)
  end
end

describe "/venues" do
  it "has a label for 'Address' with text: 'Address'", :points => 1, hint: h("copy_must_match label_for_input") do
    visit "/venues"

    expect(page).to have_css("label", text: "Address")
  end
end

describe "/venues" do
  it "has a label for 'Name' with text: 'Name'", :points => 1, hint: h("copy_must_match label_for_input") do
    visit "/venues"

    expect(page).to have_css("label", text: "Name")
  end
end

describe "/venues" do
  it "has a label for 'Neighborhood' with text: 'Neighborhood'", :points => 1, hint: h("copy_must_match label_for_input") do
    visit "/venues"

    expect(page).to have_css("label", text: "Neighborhood")
  end
end

describe "/venues" do
  it "has 3 input elements (one for address, name, & neighborhood)", :points => 1, hint: h("label_for_input") do
    visit "/venues"

    expect(page).to have_css("input", minimum: 3)
  end
end

describe "/venues" do
  it "has a button with text 'Add venue'", :points => 1, hint: h("copy_must_match") do
    visit "/venues"

    expect(page).to have_css("button", text: "Add venue")
  end
end

describe "/venues" do
  it "creates a venue when 'Add venue' form is submitted", :points => 5, hint: h("button_type") do
    initial_number_of_venues = Venue.count

    test_address = "5807 S Woodlawn Ave. Chicago, IL"
    test_name = "firstdraft Steak n' Sushi"
    test_neighborhood = "Hyde Park"
    
    test_user = User.new
    test_user.username = "username"
    test_user.save 

    visit "/venues"

    fill_in "Address", with: test_address
    fill_in "Name", with: test_name
    fill_in "Neighborhood", with: test_neighborhood

    click_on "Add venue"

    final_number_of_venues = Venue.count

    expect(final_number_of_venues).to eq(initial_number_of_venues + 1)
  end
end

describe "/venues" do
  it "saves the name when 'Add venue' form is submitted", :points => 2, hint: h("label_for_input") do

    
    test_address = "5807 S Woodlawn Ave. Chicago, IL"
    test_name = "firstdraft Steak n' Sushi"
    test_neighborhood = "Hyde Park"

    test_user = User.new
    test_user.username = "username"
    test_user.save 

    visit "/venues"


    fill_in "Address", with: test_address
    fill_in "Name", with: test_name
    fill_in "Neighborhood", with: test_neighborhood

    click_on "Add venue"

    last_venue = Venue.order(created_at: :asc).last
    expect(last_venue.name).to eq(test_name)
  end
end

describe "/venues" do
  it "saves the address when 'Add venue' form is submitted", :points => 2, hint: h("label_for_input") do

    test_address = "5807 S Woodlawn Ave. Chicago, IL"
    test_name = "firstdraft Steak n' Sushi"
    test_neighborhood = "Hyde Park"

    test_user = User.new
    test_user.username = "Galen"
    test_user.save 

    visit "/venues"


    fill_in "Address", with: test_address
    fill_in "Name", with: test_name
    fill_in "Neighborhood", with: test_neighborhood

    click_on "Add venue"

    last_venue = Venue.order(:created_at => :asc).last
    expect(last_venue.address).to eq(test_address)
  end
end

describe "/venues" do
  it "'Add venue' form redirects to /venues/[venue ID] when submitted", :points => 1, hint: h("redirect_vs_render") do


    test_address = "5807 S Woodlawn Ave. Chicago, IL"
    test_name = "firstdraft Steak n' Sushi #{Time.now}"
    test_neighborhood = "Hyde Park"

    visit "/venues"


    fill_in "Address", with: test_address
    fill_in "Name", with: test_name
    fill_in "Neighborhood", with: test_neighborhood

    click_on "Add venue"

    last_venue = Venue.order(:created_at => :asc).last

    expect(page).to have_current_path("/venues/#{last_venue.id}")
  end
end


describe "/venues/[ID]" do
  it "displays the name of the venue", :points => 1 do
    user = User.new
    user.username = "ramseys"
    user.save

    venue = Venue.new
    venue.neighborhood = "5807 S Woodlawn Ave."
    venue.name = "Burger #{rand(100)}"
    venue.address = "5807 S Woodlawn Ave."
    venue.save

    visit "/venues/#{venue.id}"

    expect(page).to have_content(venue.name)
  end
end


describe "/venues/[ID]" do
  it "displays the comments that have been made on the venue", :points => 2 do
    user = User.new
    user.username = "bagel_muncher"
    user.save

    venue = Venue.new
    venue.neighborhood = "5807 S Woodlawn Ave."
    venue.name = "Burger #{rand(100)}"
    venue.address = "5807 S Woodlawn Ave."
    venue.save

    other_venue = Venue.new
    other_venue.neighborhood = "5807 S Woodlawn Ave."
    other_venue.name = "Burger #{rand(100)}"
    other_venue.address = "5807 S Woodlawn Ave."
    other_venue.save

    first_commenter = User.new
    first_commenter.username = "first_mate"
    first_commenter.save

    first_comment = Comment.new
    first_comment.author_id = first_commenter.id
    first_comment.venue_id = venue.id
    first_comment.body = "Some comment #{rand(100)}"
    first_comment.save

    second_commenter = User.new
    second_commenter.username = "commmenter2"
    second_commenter.save

    second_comment = Comment.new
    second_comment.author_id = second_commenter.id
    second_comment.venue_id = venue.id
    second_comment.body = "Some comment #{rand(100)}"
    second_comment.save

    third_comment = Comment.new
    third_comment.author_id = second_commenter.id
    third_comment.venue_id = other_venue.id
    third_comment.body = "This Comment should not be displayed"
    third_comment.save

    visit "/venues/#{venue.id}"

    expect(page).to have_content(first_comment.body)
    expect(page).to have_content(second_comment.body)
    expect(page).to_not have_content(third_comment.body)
  end
end

describe "/venues/[ID]" do
  it "displays the usernames of the commenters of the venue", :points => 2 do
    user = User.new
    user.username = "strong_bad"
    user.save

    venue = Venue.new
    venue.neighborhood = "5807 S Woodlawn Ave."
    venue.name = "Burger #{rand(100)}"
    venue.address = "5807 S Woodlawn Ave."
    venue.save

    first_commenter = User.new
    first_commenter.username = "bob_#{rand(100)}"
    first_commenter.save

    first_comment = Comment.new
    first_comment.author_id = first_commenter.id
    first_comment.venue_id = venue.id
    first_comment.save

    second_commenter = User.new
    second_commenter.username = "carol_#{rand(100)}"
    second_commenter.save

    second_comment = Comment.new
    second_comment.author_id = second_commenter.id
    second_comment.venue_id = venue.id
    second_comment.save

    visit "/venues/#{venue.id}"

    expect(page).to have_content(first_commenter.username)
    expect(page).to have_content(second_commenter.username)
  end
end


describe "/delete_venue/[venue ID]" do
  it "removes a record from the venue table", :points => 1 do


    test_address = "5807 S Woodlawn Ave. Chicago, IL"
    test_name = "firstdraft Steak n' Sushi"
    test_neighborhood = "Hyde Park"
    
    
    venue = Venue.new
    venue.address = test_address
    venue.name = test_name
    venue.neighborhood = test_neighborhood
    venue.save

    visit "/delete_venue/#{venue.id}"

    expect(Venue.exists?(venue.id)).to be(false)
  end
end

describe "/delete_venue/[venue ID]" do
  it "redirects to /venues", :points => 1, hint: h("redirect_vs_render") do


    test_address = "5807 S Woodlawn Ave. Chicago, IL"
    test_name = "firstdraft Steak n' Sushi"
    test_neighborhood = "Hyde Park"


    venue = Venue.new
    venue.address = test_address
    venue.name = test_name
    venue.neighborhood = test_neighborhood
    venue.save

    visit "/delete_venue/#{venue.id}"

    expect(page).to have_current_path("/venues")
  end
end

describe "/venues/[ID]" do
  it "has at least one form", :points => 1 do


    test_address = "5807 S Woodlawn Ave. Chicago, IL"
    test_name = "firstdraft Steak n' Sushi"
    test_neighborhood = "Hyde Park"

    user = User.new
    user.username = "BagelFace"
    user.save
    
    venue = Venue.new
    venue.address = test_address
    venue.neighborhood = test_neighborhood
    venue.name = test_name
    venue.save

    visit "/venues/#{venue.id}"

    expect(page).to have_css("form", minimum: 1)
  end
end

describe "/venues/[ID]" do
  it "has all required forms (Edit venue and New Comment)", :points => 1 do


    test_address = "5807 S Woodlawn Ave. Chicago, IL"
    test_name = "firstdraft Steak n' Sushi"
    test_neighborhood = "Hyde Park"

    venue = Venue.new
    venue.address = test_address
    venue.neighborhood = test_neighborhood
    venue.name = test_name
    venue.save

    visit "/venues/#{venue.id}"

    expect(page).to have_css("form", minimum: 2)
  end
end

describe "/venues/[ID]" do
  it "has a label with text 'Address'", :points => 1, hint: h("copy_must_match label_for_input") do
 

    test_address = "5807 S Woodlawn Ave. Chicago, IL"
    test_name = "firstdraft Steak n' Sushi"
    test_neighborhood = "Hyde Park"

    venue = Venue.new
    venue.address = test_address
    venue.name = test_name
    venue.neighborhood = test_neighborhood
    venue.save

    visit "/venues/#{venue.id}"

    expect(page).to have_css("label", text: "Address")
  end
end

describe "/venues/[ID]" do
  it "has a label with text 'Name'", :points => 1, hint: h("copy_must_match label_for_input") do


    test_address = "5807 S Woodlawn Ave. Chicago, IL"
    test_name = "firstdraft Steak n' Sushi"
    test_neighborhood = "Hyde Park"
    
    venue = Venue.new
    venue.address = test_address
    venue.name = test_name
    venue.neighborhood = test_neighborhood
    venue.save

    visit "/venues/#{venue.id}"

    expect(page).to have_css("label", text: "Name")
  end
end

describe "/venues/[ID]" do
  it "has one textarea for comment", :points => 1, hint: h("label_for_input") do


    test_address = "5807 S Woodlawn Ave. Chicago, IL"
    test_name = "firstdraft Steak n' Sushi"
    test_neighborhood = "Hyde Park"
    
    venue = Venue.new
    venue.address = test_address
    venue.neighborhood = test_neighborhood
    venue.name = test_name
    venue.save

    visit "/venues/#{venue.id}"

    expect(page).to have_css("textarea", count: 1)
  end
end

describe "/venues/[ID]" do
  it "has a button with text 'Update venue'", :points => 1, hint: h("label_for_input") do


    test_address = "5807 S Woodlawn Ave. Chicago, IL"
    test_name = "firstdraft Steak n' Sushi"
    test_neighborhood = "Hyde Park"

    user = User.new
    user.username = "BagelFace"
    user.save

    venue = Venue.new
    venue.address = test_address
    venue.name = test_name
    venue.neighborhood = test_neighborhood
    venue.save

    visit "/venues/#{venue.id}"

    expect(page).to have_css("button", text: "Update venue")
  end
end

describe "/venues/[ID]" do
  it "'Update venue' form has address prepopulated in an input element", :points => 1, hint: h("value_attribute") do

    test_address = "5807 S Woodlawn Ave. Chicago, IL"
    test_name = "firstdraft Steak n' Sushi"
    test_neighborhood = "Hyde Park"

    venue = Venue.new
    venue.address = test_address
    venue.name = test_name
    venue.neighborhood = test_neighborhood
    venue.save

    visit "/venues/#{venue.id}"

    expect(page).to have_css("input[value='#{test_address}']")
  end
end

describe "/venues/[ID]" do
  it "'Update venue' form has neighborhood prepopulated in an input element", :points => 1, hint: h("value_attribute") do

    test_address = "5807 S Woodlawn Ave. Chicago, IL"
    test_name = "firstdraft Steak n' Sushi"
    test_neighborhood = "Hyde Park"

    venue = Venue.new
    venue.address = test_address
    venue.name = test_name
    venue.neighborhood = test_neighborhood
    venue.save

    visit "/venues/#{venue.id}"

    expect(page).to have_css("input[value='#{test_neighborhood}']")
  end
end

describe "/venues/[ID]" do
  it "'Update venue' form has name prepopulated in an input element", :points => 1, hint: h("prepopulate_textarea") do

    test_address = "5807 S Woodlawn Ave. Chicago, IL"
    test_name = "firstdraft Steak n' Sushi"
    test_neighborhood = "Hyde Park"

    user = User.new
    user.username = "BagelFace"
    user.save
    
    venue = Venue.new
    venue.address = test_address
    venue.name = test_name
    venue.neighborhood = test_neighborhood
    venue.save

    visit "/venues/#{venue.id}"
    

    expect(page).to have_content(test_name)
  end
end

describe "/venues/[ID]" do
  it "'Update venue' form updates name when submitted", :points => 1, hint: h("label_for_input button_type") do

    test_address = "413 Home St"
    old_name = "Some test name #{Time.now.to_i}"
    test_neighborhood = "Egbert Village"


    user = User.new
    user.username = "BagelFace"
    user.save

    venue = Venue.new
    venue.address = test_address
    venue.name = old_name
    venue.neighborhood = test_neighborhood
    venue.save

    new_name = "New name #{Time.now.to_i}"

    visit "/venues/#{venue.id}"
    fill_in "Name", with: new_name
    click_on "Update venue"

    venue_as_revised = Venue.where({ :id => venue.id}).first

    expect(venue_as_revised.name).to eq(new_name)
  end
end

describe "/venues/[ID]" do
  it "'Update venue' form updates the venue's address column when submitted", :points => 1, hint: h("label_for_input button_type") do

    old_address = "101 Stinky Lane"
    test_name = "Some test name #{Time.now.to_i}"
    test_neighborhood = "Young Money"

    user = User.new
    user.username = "BagelFace"
    user.save
    
    venue = Venue.new
    venue.address = old_address
    venue.name = test_name
    venue.neighborhood = test_neighborhood
    venue.save

    new_address = "666 Satan Ave"

    visit "/venues/#{venue.id}"
    fill_in "Address", with: new_address
    click_on "Update venue"

    venue_as_revised = Venue.where({:id => venue.id }).first

    expect(venue_as_revised.address).to eq(new_address)
  end
end

describe "/venues/[ID]" do
  it "'Update venue' form redirects to the venue's details page when updating venue", :points => 1, hint: h("embed_vs_interpolate redirect_vs_render") do


    test_address = "5807 S Woodlawn Ave. Chicago, IL"
    test_name = "firstdraft Steak n' Sushi"
    test_neighborhood = "Hyde Park"
    
    venue = Venue.new
    venue.address = test_address
    venue.name = test_name
    venue.neighborhood = test_neighborhood
    venue.save

    visit "/venues/#{venue.id}"
    click_on "Update venue"

    expect(page).to have_current_path("/venues/#{venue.id}")
  end
end

describe "/venues/[ID] — Add comment form" do
  it "has a label with text 'Author ID'", :points => 1, hint: h("copy_must_match label_for_input") do

    test_address = "5807 S Woodlawn Ave. Chicago, IL"
    test_name = "firstdraft Steak n' Sushi"
    test_neighborhood = "Hyde Park"

    venue = Venue.new
    venue.address = test_address
    venue.name = test_name
    venue.neighborhood = test_neighborhood
    venue.save

    visit "/venues/#{venue.id}"

    expect(page).to have_css("label", text: "Author ID")
  end
end

describe "/venues/[ID] — Add comment form" do
  it "has a label with text 'Comment'", :points => 1, hint: h("copy_must_match label_for_input") do

    test_address = "5807 S Woodlawn Ave. Chicago, IL"
    test_name = "firstdraft Steak n' Sushi"
    test_neighborhood = "Hyde Park"

    venue = Venue.new
    venue.address = test_address
    venue.name = test_name
    venue.neighborhood = test_neighborhood
    venue.save

    visit "/venues/#{venue.id}"

    expect(page).to have_css("label", text: "Comment")
  end
end

describe "/venues/[ID] — Add comment form" do
  it "has a textarea for the comment", :points => 1 do

    test_address = "5807 S Woodlawn Ave. Chicago, IL"
    test_name = "firstdraft Steak n' Sushi"
    test_neighborhood = "Hyde Park"

    venue = Venue.new
    venue.address = test_address
    venue.name = test_name
    venue.neighborhood = test_neighborhood
    venue.save

    visit "/venues/#{venue.id}"

    expect(page).to have_css("textarea")
  end
end

describe "/venues/[ID] — Add comment form" do
  it "has a button with text 'Add comment'", :points => 1 do


    test_address = "5807 S Woodlawn Ave. Chicago, IL"
    test_name = "firstdraft Steak n' Sushi"
    test_neighborhood = "Hyde Park"

    venue = Venue.new
    venue.address = test_address
    venue.name = test_name
    venue.neighborhood = test_neighborhood
    venue.save

    visit "/venues/#{venue.id}"

    expect(page).to have_css("button", text: "Add comment")
  end
end

describe "/venues/[ID] — Add comment form" do
  it "creates a new comment record when submitted", :points => 2 do


    test_address = "5807 S Woodlawn Ave. Chicago, IL"
    test_name = "firstdraft Steak n' Sushi"
    test_neighborhood = "Hyde Park"
    test_comment = "Some new comment #{Time.now.to_i}"
    
    first_other_user = User.new
    first_other_user.username = "bob_#{Time.now.to_i}"
    first_other_user.save

    venue = Venue.new
    venue.address = test_address
    venue.name = test_name
    venue.neighborhood = test_neighborhood
    venue.save

    second_other_user = User.new
    second_other_user.username = "carol_#{Time.now.to_i}"
    second_other_user.save

    visit "/venues/#{venue.id}"

    fill_in "Comment", with: test_comment
    fill_in "Author ID", with: second_other_user.id

    click_on "Add comment"

    new_comment = Comment.where({:author_id => second_other_user.id, :body => test_comment}).first

    expect(new_comment).to_not be_nil
  end
end

describe "/venues/[ID] — Add comment form" do
  it "redirects to /venues/[ID] when creating new comment", :points => 1 do

    test_address = "5807 S Woodlawn Ave. Chicago, IL"
    test_name = "firstdraft Steak n' Sushi"
    test_neighborhood = "Hyde Park"
    test_comment = "Some new comment #{Time.now.to_i}"

    first_other_user = User.new
    first_other_user.username = "bob_#{Time.now.to_i}"
    first_other_user.save

    venue = Venue.new
    venue.address = test_address
    venue.name = test_name
    venue.neighborhood = test_neighborhood
    venue.save
    

    visit "/venues/#{venue.id}"
    fill_in "Comment", with: test_comment
    fill_in "Author ID", with: first_other_user.id

    click_on "Add comment"

    expect(page).to have_current_path("/venues/#{venue.id}")
  end
end
