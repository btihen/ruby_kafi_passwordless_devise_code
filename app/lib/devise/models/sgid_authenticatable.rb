require Rails.root.join('app/lib/devise/strategies/sgid_authenticatable')

module Devise
  module Models
    module SgidAuthenticatable
      extend ActiveSupport::Concern
    end
  end
end
