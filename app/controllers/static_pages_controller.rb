class StaticPagesController < ApplicationController
  skip_before_action :require_login, only: %i[top term policy]

  def top; end

  def term; end

  def policy; end
end
