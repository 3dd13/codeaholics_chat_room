class SignedInController < ApplicationController
  layout "signed_in"
  before_filter :authenticate_user!
end
