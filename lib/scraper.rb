require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    student_cards = doc.css('div.student-card')
    students = []
    student_cards.each {|card|
    	students << {
    		name: card.css('h4.student-name').children.text,
    		location: card.css('p.student-location').children.text,
    		profile_url: card.css('a').attribute('href').value
    	}
    }
    students
  end

  def self.scrape_profile_page(profile_url)
  	doc = Nokogiri::HTML(open(profile_url))
  	student_hash = {}
  	doc.css('div.social-icon-container a').each {|link_element|
  		link = link_element.attribute('href').value
  		case link
  		when /twitter/
  			student_hash[:twitter] = link
  		when /github/
  			student_hash[:github] = link
  		when /linkedin/
  			student_hash[:linkedin] = link
  		else
  			student_hash[:blog] = link
  		end
  	}
  	student_hash[:profile_quote] = doc.css('div.profile-quote').text
  	student_hash[:bio] = doc.css('div.description-holder p').text
  	student_hash
  end

end