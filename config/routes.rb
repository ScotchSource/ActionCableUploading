Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  root 'chats#index'
end
