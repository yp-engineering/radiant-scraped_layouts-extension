module NavigationHelpers
  
  # Extend the standard PathMatchers with your own paths
  # to be used in your features.
  # 
  # The keys and values here may be used in your standard web steps
  # Using:
  #
  #   When I go to the "scraped_layout" admin page
  # 
  # would direct the request to the path you provide in the value:
  # 
  #   admin_scraped_layout_path
  # 
  PathMatchers = {} unless defined?(PathMatchers)
  PathMatchers.merge!({
    # /scraped_layout/i => 'admin_scraped_layout_path'
  })
  
end

World(NavigationHelpers)