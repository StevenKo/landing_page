LandingPage::Application.routes.draw do
  
  devise_for :users, :controllers => {
    :registrations => "registrations",
    :omniauth_callbacks => "users/omniauth_callbacks"
  } do
    get "logout" => "devise/sessions#destroy"
  end

  resources :welcome, :only => :create

  root :to => 'welcome#index'
end
