FactoryGirl.define do
  factory :question_attachment, class: Attachment do
    association :attachable, factory: :question
    file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/support/files_to_upload', 'file_1.txt')) }
  end

  factory :answer_attachment, class: Attachment do
    association :attachable, factory: :answer
    file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/support/files_to_upload', 'file_1.txt')) }
  end
end
