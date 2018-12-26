require 'rails_helper'

RSpec.describe Project, type: :model do
  before do
    @user = User.create(
      first_name: 'user',
      last_name: 'test',
      email: 'test@gmail.com',
      password: 'password'
    )
    @other_user = User.create(
      first_name: 'other',
      last_name: 'user',
      email: 'other_user@gmail.com',
      password: 'password'
    )
    @project = @user.projects.create(name: 'Test Project')
  end
  it 'is valid with a name' do
    expect(@project).to be_valid
  end

  it 'is invalid without a name' do
    project = @user.projects.create(name: nil)
    project.valid?
    expect(project.errors[:name]).to include("can't be blank")
  end
  # User単位では重複したプロジェク名を許可しないこと
  it 'does not allow duplicate project names per user' do
    new_project = @user.projects.build(
      name: 'Test Project'
    )
    new_project.valid?
    expect(new_project.errors[:name]).to include("has already been taken")
  end

  # 二人のユーザーが同じ名前を使うことは許可する
  it 'allows two users to share a project name' do
    other_project = @other_user.projects.build(
      name: 'Test Project'
    )
    expect(other_project).to be_valid
  end
end