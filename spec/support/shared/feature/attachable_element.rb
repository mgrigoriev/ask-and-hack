shared_examples_for 'Attachable element' do
  scenario 'User adds file while creating a post', js: true do

    sign_in(user)
    visit path

    fill_in("#{field_title}", with: 'Post title') if field_title
    fill_in("#{field_body}", with: 'Post body') if field_body

    within all('.nested-fields').first do
      attach_file 'File', "#{Rails.root}/spec/support/files_to_upload/file_1.txt"
    end

    click_on 'add file'

    within all('.nested-fields').last do
      attach_file 'File', "#{Rails.root}/spec/support/files_to_upload/file_2.txt"
    end

    click_on "#{submit}"

    within "#{selector}" do
      expect(page).to have_link 'file_1.txt', href: '/uploads/attachment/file/1/file_1.txt'
      expect(page).to have_link 'file_2.txt', href: '/uploads/attachment/file/2/file_2.txt'
    end
  end
end
