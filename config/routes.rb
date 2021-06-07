Rails.application.routes.draw do
  root('userr#index') 

  devise_for :users, :controllers => { registrations: 'users/registrations' }

  devise_scope :user do
    get '/custom_path/sign_out' => 'devise/sessions#destroy'
  end
  
  # get 'verification/:id' => 'users#verification_mail_send', as: 'verification_mail_send' 
  # get 'verify/token=:token' => 'users#verify_mail', as: 'verify_mail' 

  resources :userr do
      member do
        get :delete
        post :add_employee_skills
        get 'delete_employee_skills/:skill_id' => 'userr#delete_employee_skills', as: 'delete_employee_skills'
      end

      resources :chatting do
        member do
          get :delete
        end
      end
    end

    namespace :api do
      namespace :v1 do
        resources :skills
        resources :login_api, only: [:create]
      end
    end


end
