class FrontPageController < ApplicationController

	def home
    @months = [['Month', '']]
    @day    = [['Day','']]
    @year   = [['Year','']]

    (1..12).each {|m| @months << [Date::ABBR_MONTHNAMES[m], m]}
    (1..31).each {|d| @day << [d]}
    
    (Time.now.year - 110..Time.now.year).to_a.reverse.each{|y| @year << [y]}
    @users = User.new  
  end

  def help
  end

  def about
  end

  def contact
  end
  
end
