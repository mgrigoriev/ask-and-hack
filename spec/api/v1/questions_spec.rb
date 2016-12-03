require 'rails_helper'
require_relative 'api_helper'

describe 'Questions API' do
  describe 'GET #index' do
    let(:url) { '/api/v1/questions' }

    it_behaves_like 'API Authenticatable'

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:access_token) { create(:access_token) }
      let!(:answer) { create(:answer, question: question) }

      before do
        do_request(url, { access_token: access_token.token } )
      end

      it 'returns 200 status code' do
        expect(response.status).to eq 200
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path('questions')
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("questions/0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "answer object contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'GET #list' do
    let(:url) { '/api/v1/questions/list' }

    it_behaves_like 'API Authenticatable'

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:access_token) { create(:access_token) }

      before do
        do_request(url, { access_token: access_token.token })
      end

      it 'returns 200 status code' do
        expect(response.status).to eq 200
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path('questions')
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question) }
    let!(:comment) { create(:question_comment, commentable: question) }
    let!(:attachment) { create(:question_attachment, attachable: question) }
    let(:url) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authenticatable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before do
        do_request(url, { access_token: access_token.token })
      end

      it 'returns 200 status code' do
        expect(response.status).to eq 200
      end

      it 'returns the question' do
        expect(response.body).to have_json_size(1)
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end

      %w(id body created_at user_id).each do |attr|
        it "question's comment object contains #{attr}" do
          expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("question/comments/0/#{attr}")
        end
      end

      %w(id created_at).each do |attr|
        it "question's attachment object contains #{attr}" do
          expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("question/attachments/0/#{attr}")
        end
      end

      it "question's attachment object contains filename" do
        expect(response.body).to be_json_eql(attachment.file.identifier.to_json).at_path("question/attachments/0/filename")
      end

      it "question's attachment object contains url" do
        expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("question/attachments/0/url")
      end
    end
  end

  describe 'POST #create' do
    let(:url) { "/api/v1/questions/" }
    let(:http_method) { :post }
    let(:options) { { question: attributes_for(:question) } }

    it_behaves_like 'API Authenticatable'

    context 'authorized and post valid data' do
      let(:access_token) { create(:access_token) }
      let(:options) do
        {
          question:     { title: 'New question title', body: 'New question body' },
          access_token: access_token.token
        }
      end

      before do
        do_request(url, http_method, options)
      end

      it 'returns 201 status code' do
        expect(response.status).to eq 201
      end
    end

    context 'authorized and post invalid data' do
      let(:access_token) { create(:access_token) }
      let(:options) do
        {
          question:     { title: 'Question title', body: nil },
          access_token: access_token.token,
        }
      end

      before do
        do_request(url, http_method, options)
      end

      it 'returns 422 status code' do
        expect(response.status).to eq 422
      end

      it 'returns errors' do
        expect(response.body).to have_json_size(2).at_path("errors/body")
      end

    end
  end
end
