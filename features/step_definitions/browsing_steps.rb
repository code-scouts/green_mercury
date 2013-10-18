Given(/^I am on the "(.+)" page$/) do |page|
  page_map = {
    home: root_path,
    events: events_path,
  }
  visit page_map[page.to_sym]
end


Then(/^I should be redirected to "(.*?)"$/) do |domain|
  URI.parse(current_url).host.should == domain
end
