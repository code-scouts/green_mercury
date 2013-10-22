module MentorApplicationHelper 
  def hear_about 
    { "google" => "Google",
      "website" => "codescouts.org Website",
      "facebook" => "Facebook",
      "friend" => "From a friend",
      "twitter" => "Twitter"
    }
  end 

  def time_commitment 
    { "bit" => "A bit of time, when I can",
      "month" => "A few hours a month",
      "week" => "A few hours a week"
    }
  end

  def shirt_sizes
    ["Women's XS", 
     "Women's Small",
     "Women's Medium", 
     "Women's Large", 
     "Women's XL", 
     "Women's XXL", 
     "Men's XS", 
     "Men's Small", 
     "Men's Medium", 
     "Men's Large", 
     "Men's XL", 
     "Men's XXL"]
  end 

  def interest_level_questions
    {
      mentor_one_on_one: "As a mentor to Code Scouts members, 1-on-1",
      mentor_group: "As a mentor to Code Scouts members, in a group setting",
      mentor_online: "As a mentor to Code Scouts members online (email and forums)",
      volunteer_events: "As a volunteer at Code Scouts events",
      volunteer_teams: "As a volunteer with Code Scouts program teams, in-person",
      volunteer_solo: "As a volunteer for Code Scouts doing something solo",
      volunteer_technical: "As a volunteer for Code Scouts doing programming or technical stuff",
      volunteer_online: "As a volunteer for Code Scouts online only (writing, reseach, etc.)"
    }
  end

  def interest_levels
    ['Very interested', 'Somewhat interested', 'Not interested']
  end
end