require 'rails_helper'
require_relative 'api_helper'

describe 'Answers API' do
  let!(:question) { create(:question) }

  describe 'GET #index' do
    let(:url) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authenticatable'

    context 'authorized' do
      let!(:answers) { create_list(:answer, 2, question: question) }
      let!(:first_answer) { answers.first }
      let(:access_token) { create(:access_token) }

      before do
        do_request(url, { access_token: access_token.token })
      end

      it 'returns 200 status code' do
        expect(response.status).to eq 200
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(2).at_path('answers')
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(first_answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end
  end

  describe 'GET #show' do
    let!(:answer) { create(:answer, question: question) }
    let!(:comment) { create(:answer_comment, commentable: answer) }
    let!(:attachment) { create(:answer_attachment, attachable: answer) }

    let(:url) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authenticatable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before do
        do_request(url, { access_token: access_token.token })
      end

      it 'returns 200 status code' do
        expect(response.status).to eq 200
      end

      it 'returns the answer' do
        expect(response.body).to have_json_size(1)
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      %w(id body created_at user_id).each do |attr|
        it "answer's comment object contains #{attr}" do
          expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
        end
      end

      %w(id created_at).each do |attr|
        it "answer's attachment object contains #{attr}" do
          expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("answer/attachments/0/#{attr}")
        end
      end

      it "answer's attachment object contains filename" do
        expect(response.body).to be_json_eql(attachment.file.identifier.to_json).at_path("answer/attachments/0/filename")
      end

      it "answer's attachment object contains url" do
        expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("answer/attachments/0/url")
      end
    end
  end

  describe 'POST #create' do
    let(:url) { "/api/v1/questions/#{question.id}/answers" }
    let(:http_method) { :post }
    let(:options) { { answer: attributes_for(:answer), question_id: question.id } }

    it_behaves_like 'API Authenticatable'

    context 'authorized and post valid data' do
      let(:access_token) { create(:access_token) }
      let(:options) do
        {
          answer:       { body: 'New answer' },
          question_id:  question.id,
          access_token: access_token.token,
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
          answer:       { body: nil },
          question_id:  question.id,
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
