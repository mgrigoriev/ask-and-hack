shared_examples_for 'Attachment deletable element' do
  scenario 'User deletes file attached to his post', js: true do
    within '.attachments' do
      click_on '[x]'
    end
    expect(page).to_not have_link 'file_1.txt', href: '/uploads/attachment/file/1/file_1.txt'
  end

  scenario "User tries to delete file attached to other user's answer", js: true do
    sign_out
    sign_in(stranger)
    visit path

    within '.attachments' do
      expect(page).to_not have_link '[x]'
    end
  end
end
