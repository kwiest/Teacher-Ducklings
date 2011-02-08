atom_feed do |feed|
  feed.title("Teacher Ducklings")
  feed.updated((@posts.first.created_at))

  @posts.each do |post|
    feed.entry(post) do |entry|
      entry.title(post.title)
      entry.content(post.body, :type => "html")
      
      entry.author do |author|
        author.name(post.user.full_name)
      end
    end
  end
end
