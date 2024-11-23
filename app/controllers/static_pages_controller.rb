class StaticPagesController < ApplicationController
  skip_before_action :require_login, only: %i[top term]

  def top; end

  def term; end
end
