module OmniauthMacros
  def mock_auth_hash
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      provider: 'facebook',
      uid: '111',
      info: {
        email: 'test@example.com',
        name: 'Mikhail Grigoriev',
        image: 'http://graph.facebook.com/v2.6/10157669802260123/picture'
      }
    })

    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      provider: 'twitter',
      uid: '222',
      info: {
        name: 'Mikhail Grigoriev',
        image: 'http://pbs.twimg.com/profile_images/1190419102/a_2ce7b538_normal.jpeg'
      }
    })
  end

  def mock_auth_invalid_hash
    OmniAuth.config.mock_auth[:facebook] = :credentials_are_invalid
    OmniAuth.config.mock_auth[:twitter]  = :credentials_are_invalid
  end
end
