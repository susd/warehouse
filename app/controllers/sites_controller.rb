class SitesController < ApplicationController
  def index
    @sites = Site.order(:abbr)
  end
end