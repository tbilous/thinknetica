FactoryGirl.define do
  factory :question_attachment, class: 'Attachment' do
    file { Rack::Test::UploadedFile.new(File.join("#{Rails.root}/spec/support/for_upload/file1.txt")) }
    attachable_type 'Question'
  end

  factory :answer_attachment, class: 'Attachment' do
    file { Rack::Test::UploadedFile.new(File.join("#{Rails.root}/spec/support/for_upload/file1.txt")) }
    attachable_type 'Answer'
  end
end