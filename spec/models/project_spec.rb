require 'rails_helper'

RSpec.describe Project, type: :model do
  # User単位では重複したプロジェク名を許可しないこと
  it 'does not allow duplicate project names per user' do
    user = User.create(
      first_name: 'user',
      last_name: 'test',
      email: 'test@gmail.com',
      password: 'password'
    )
    user.projects.create(
      name: 'test-project'
    )
    new_project = user.projects.build(
      name: 'test-project'
    )
    new_project.valid?
    expect(new_project.errors[:name]).to include("has already been taken")
  end

  # 二人のユーザーが同じ名前を使うことは許可する
  it 'allows two users to share a project name' do
    user = User.create(
      first_name: 'user',
      last_name: 'test',
      email: 'test@gmail.com',
      password: 'password'
    )
    other_user = User.create(
      first_name: 'other',
      last_name: 'user',
      email: 'other_user@gmail.com',
      password: 'password'
    )
    user.projects.create(
      name: 'Test Project'
    )
    other_project = other_user.projects.build(
      name: 'Test Project'
    )
    expect(other_project).to be_valid
  end
end