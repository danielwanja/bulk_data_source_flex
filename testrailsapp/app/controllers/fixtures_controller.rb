require 'active_record/fixtures'

class FixturesController < ApplicationController
  
  FIXTURES_ROOT = "#{Rails.root}/test/fixtures"
  
  def reset
    ActiveRecord::Fixtures.reset_cache # FIXME: really required?
    ActiveRecord::Fixtures.create_fixtures(FIXTURES_ROOT, [:posts]) # [:authors, :comments, :essays, :posts, :todos]
    head :created 
  end

end
