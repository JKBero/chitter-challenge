feature "the user can sign up for The 411" do

  before do
    test_database_setup
    sign_up_new_user
  end

  scenario "their user-handle is displayed once logged in" do
    expect(page).to have_content "What's on your mind Sips?"
  end

  scenario "an error message displays if they enter an email that already has an account" do
    click_on "Log Out"
    visit '/'
    fill_in 'name', with: 'Sips Adebayo'
    fill_in 'user-handle', with: 'Sipho'
    fill_in 'email', with: 'sipho_adebayo@test.com'
    fill_in 'password', with: 'heyo034'
    click_button "SCHWEET"

    expect(page).to have_content "This email already has an account, please try again."
  end

  scenario "an error message displays if they enter a user-handle that is already in use" do
    click_on "Log Out"
    visit '/'
    fill_in 'name', with: 'Sips Adebayo'
    fill_in 'user-handle', with: 'Sips'
    fill_in 'email', with: 'hello@test.com'
    fill_in 'password', with: 'heyo034'
    click_button "SCHWEET"

    expect(page).to have_content "This user handle is already in use, please choose another."
  end

  scenario "their name and user-handle shows against any peep they post" do
    fill_in "content", with: "Hello World!"
    click_button "DROP SCIENCE"

    expect(page).to have_content "Hello World!"
    expect(page).to have_content "Sips"
    expect(page).to have_content "Sipho Adebayo"
  end
end
