require 'rails_helper'

RSpec.feature "Projects", type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project,
    name: "Sample Project",
    owner: user)
  }
  
  # ユーザーは新しいプロジェクトを作成する
  scenario 'user creates a new project' do
    user = FactoryBot.create(:user)
    sign_in user
    visit root_path
    expect {
      click_link "New Project"
      fill_in "Name", with: "Test Project"
      fill_in "Description", with: "Trying out Capybara"
      click_button "Create Project"
    }.to change(user.projects, :count).by(1)

    aggregate_failures do
      expect(page).to have_content "Project was successfully created"
      expect(page).to have_content "Test Project"
      expect(page).to have_content "Owner: #{user.name}"
    end
  end

  # ユーザーがプロジェクトを編集する
  scenario 'user updates the project' do
    go_to_edit
    update "A New Sample Project"
    click_button "Update Project"
    aggregate_failures do
      expect(page).to have_content "Project was successfully updated."
      expect(page).to have_content "A New Sample Project"
    end
  end

  # ユーザーはプロジェクトを完了済みにする
  scenario 'user completes a project' do
    project = FactoryBot.create(:project, owner: user)
    sign_in user
    visit project_path(project)
    expect(page).to_not have_content "Completed"
    click_button "Complete"
    expect(project.reload.completed?).to be true
    expect(page).to have_content "Congratulations, this project is complete!"
    expect(page).to have_content "Completed"
    expect(page).to_not have_button "Complete"
  end

  scenario 'a completed project dose not exit in index' do
    completed_project = FactoryBot.create(:project,
      name: "Completed Project",
      completed: true,
      owner: user
      )
    incomplete_project = FactoryBot.create(:project,
      name: "Incomplete Project",
      completed: false,
      owner: user
      )
    sign_in user
    visit root_path
    expect(page).to_not have_content "Completed Project"
    expect(page).to have_content "Incomplete Project"
  end

  def go_to_edit
    sign_in user
    visit project_path(project)
    click_link "Edit"
  end

  def update(name)
    fill_in "Name", with: name
  end
end