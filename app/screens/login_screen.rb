class LoginScreen < Formotion::FormController
  include ProMotion::ScreenModule

  title "edX Login"

  SETTINGS_HASH = {
    title: "Login",
    persist_as: :account_settings,
    sections: [{
      rows: [{
        title: "User Name",
        type: :string,
        placeholder: "name",
        key: :username,
        auto_correction: :no,
        auto_capitalization: :none
      }, {
        title: "Password",
        type: :string,
        placeholder: "password",
        key: :password,
        secure: true
      }]
    }, {
      rows: [{
        title: "Login",
        type: :submit,
      }]
    }]
  }

  def init
    form = Formotion::Form.persist(SETTINGS_HASH)
    form.on_submit do
      self.login
    end
    initWithForm(form)
  end

  def login
    App::Persistence['username'] = form.render[:username]
    App::Persistence['password'] = form.render[:password]

    Profile.test_login do |result|
      if result == true then
        close
      else
        App.alert("Login failed")
        App::Persistence['username'] = nil
        App::Persistence['password'] = nil
      end
    end
  end


end
