require 'rails_helper'

RSpec.describe HomeController, type: :controller do
    describe '#index' do
        it 'responses successfully' do # 正常にレスポンスを返すこと
            get :index # getリクエストを送る
            expect(response).to be_success # レスポンスステータスをチェック 200ならグリーン
        end

        it 'returns a 200 response' do # 200レスポンスを返すこと
            get :index
            expect(response).to have_http_status "200"
        end
    end
end
