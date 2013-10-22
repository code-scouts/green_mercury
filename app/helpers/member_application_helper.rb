module MemberApplicationHelper 
  def why_you_want_to_join 
    { "hobby" => "This is an interesting hobby.",
      "current_career" => "I want to gain skills to advance my current career.",
      "new_career" => "I  want to start a new career.",
      "side_job" => "I want to do software development as a side job.",
      "new_business" => "I want to gain skills that will help in running a small business."
    }
  end 

  def confidence_level_questions
    {
      confidence_technical_skills: "I am confident in my ability to learn technical skills.",
      basic_programming_knowledge: "I know how to do some basic programming.",
      comfortable_learning: "I am comfortable learning how to code."
    }
  end

  def confidence_levels
    [1, 2, 3, 4, 5]
  end

  def time_commitment_member
    {
      "fewer than 2" => "Few than 2 hours",
      "2 to 5" => "2 - 5 hours",
      "6 to 19" => "6 - 19 hours",
      "20 to 30" => "20 - 30 hours",
      "at least 30" => "At least 30 hours",
      "unknown" => "I don't know"
    }
  end
end