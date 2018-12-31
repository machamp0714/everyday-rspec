require 'rails_helper'

RSpec.describe TasksController, type: :controller do
    let(:user) { FactoryBot.create(:user) }
    let(:project) { FactoryBot.create(:project, owner: user) }
    let(:task) { project.tasks.create!(name: "Test Task") }

    describe '#show' do
        it 'responds with JSON output' do
            sign_in user
            get :show, format: :json,
                params: { project_id: project.id, id: task.id }
            expect(response.content_type).to eq "application/json"
        end
    end

    describe '#create' do
        it 'adds a new task to the project' do
            new_task = { name: "New Task" }
            sign_in user
            expect {
                post :create, format: :json,
                    params: { project_id: project.id, task: new_task }
            }.to change(project.tasks, :count).by(1)
        end

        it 'requires authentication' do
            new_task = { name: "New Task" }
            expect {
                post :create, format: :json, params: {
                    project_id: project.id, task: new_task
                }
            }.to_not change(project.tasks, :count)
            expect(response).to_not be_success
        end
    end
end
