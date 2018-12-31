require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
    describe '#index' do
        # 認証済みユーザーとして
        context 'as an authenticated user' do
            before do
                @user = FactoryBot.create(:user)
            end
            # 正常にレスポンスを返すこと
            it 'responses successfully' do
                sign_in @user
                get :index
                aggregate_failures do
                    expect(response).to be_success
                    expect(response).to have_http_status "200"
                end
            end
        end

        # ゲストとして
        context 'as a guest' do
            # 302レスポンスを返すこと
            it 'returns a 302 response' do
                get :index
                expect(response).to have_http_status "302"
            end

            # サインイン画面にリダイレクトすること
            it 'redirects to the sign_in page' do
                get :index
                expect(response).to redirect_to "/users/sign_in"
            end
        end
    end

    describe '#show' do
        # 認可されたユーザーとして
        context 'as an authorized user' do
            before do
                @user = FactoryBot.create(:user)
                @project = FactoryBot.create(:project, owner: @user)
            end

            # 正常にレスポンスを返すこと
            it 'responses successfully' do
                sign_in @user
                get :show, params: { id: @project.id }
                expect(response).to be_success
            end
        end

        # 認可されていないユーザーとして
        context 'as an unauthorized user' do
            before do
                @user = FactoryBot.create(:user)
                @other_user = FactoryBot.create(:user)
                @project = FactoryBot.create(:project, owner: @other_user)
            end
            # ダッシュボードにリダイレクトする
            it 'redirects to the dashboard' do
                sign_in @user
                get :show, params: { id: @project.id }
                expect(response).to redirect_to root_path
            end
        end
    end

    describe '#create' do
        # 認証済みのユーザーとして
        context 'as an authenticated user' do
            before do
                @user = FactoryBot.create(:user)
            end
            context 'with valid attributes' do
                it 'adds a project' do
                    project_params = FactoryBot.attributes_for(:project)
                    sign_in @user
                    expect {
                        post :create, params: { project: project_params }
                    }.to change(@user.projects, :count).by(1)
                end
            end
            context 'with invalid attributes' do
                it 'dose not add a project' do
                    project_params = FactoryBot.attributes_for(:project, :invalid)
                    sign_in @user
                    expect {
                        post :create, params: { project: project_params }
                    }.not_to change(@user.projects, :count)
                end
            end
        end
        # ゲストユーザーとして
        context 'as a guest' do
            it 'returns a 302 response' do
                project_params = FactoryBot.attributes_for(:project)
                post :create, params: { project: project_params }
                expect(response).to have_http_status "302"
            end
            it 'redirects to the sign_in page' do
                project_params = FactoryBot.attributes_for(:project)
                post :create, params: { project: project_params }
                expect(response).to redirect_to "/users/sign_in"
            end
        end
    end

    describe '#update' do
        context 'as an authorize user' do
            before do
                @user = FactoryBot.create(:user)
                @project = FactoryBot.create(:project, owner: @user)
            end
            it 'updates a project' do
                project_params = FactoryBot.attributes_for(:project,
                    name: "New Project Name"
                    )
                sign_in @user
                patch :update, params: { id: @project.id, project: project_params }
                expect(@project.reload.name).to eq "New Project Name"
            end
        end

        context 'as an unauthorized user' do
            before do
                @user = FactoryBot.create(:user)
                other_user = FactoryBot.create(:user)
                @project = FactoryBot.create(:project, name: "Old Project Name", owner: other_user)
            end
            # プロジェクトを更新できないこと
            it 'dose not update a project' do
                sign_in @user
                project_params = FactoryBot.attributes_for(:project, name: "New Project Name")
                patch :update, params: { id: @project.id, project: project_params }
                expect(@project.reload.name).to eq "Old Project Name"
            end
            it 'redirects to the dashboard' do
                project_params = FactoryBot.attributes_for(:project)
                sign_in @user
                patch :update, params: { id: @project.id, project: project_params }
                expect(response).to redirect_to root_path
            end
        end

        context 'as a guest' do
            before do
                @project = FactoryBot.create(:project)
                @project_params = FactoryBot.attributes_for(:project)
            end
            it 'responses a 302 response' do
                patch :update, params: { id: @project.id, project: @project_params }
                expect(response).to have_http_status "302"
            end
            it 'redirects to the sign_in page' do
                patch :update, params: { id: @project.id, project: @project_params }
                expect(response).to redirect_to "/users/sign_in"
            end
        end
    end

    describe '#destroy' do
        context 'as an authorized user' do
            before do
                @user = FactoryBot.create(:user)
                @project = FactoryBot.create(:project, owner: @user)
            end
            it 'deletes a project' do
                sign_in @user
                expect {
                    delete :destroy, params: { id: @project.id }
                }.to change(@user.projects, :count).by(-1)
            end
        end
        context 'as an unauthorized user' do
            before do
                @user = FactoryBot.create(:user)
                other_user = FactoryBot.create(:user)
                @project = FactoryBot.create(:project, owner: other_user)
            end
            it 'dose not delete a project' do
                sign_in @user
                expect {
                    delete :destroy, params: { id: @project.id }
                }.to_not change(Project, :count)
            end
            it 'redirects to the dashboard' do
                sign_in @user
                delete :destroy, params: { id: @project.id }
                expect(response).to redirect_to root_path
            end
        end
        context 'as a guest' do
            before do
                @project = FactoryBot.create(:project)
            end
            it 'responses a 302 reponse' do
                delete :destroy, params: { id: @project.id }
                expect(response).to have_http_status "302"
            end
            it 'redirects to the sign_in page' do
                delete :destroy, params: { id: @project.id }
                expect(response).to redirect_to "/users/sign_in"
            end
            it 'dose not delete a project' do
                expect {
                    delete :destroy, params: { id: @project.id }
                }.not_to change(Project, :count)
            end
        end
    end
end