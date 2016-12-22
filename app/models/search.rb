class Search
  def self.search(q, object='all')
    q = ThinkingSphinx::Query.escape(q) unless q.nil?

    if available_objects.include?(object)
      object.classify.constantize.search q
    else
      ThinkingSphinx.search q
    end
  end

  def self.items_for_select
    [
      %w(All all),
      %w(Questions question),
      %w(Answers answer),
      %w(Comments comment),
      %w(Author user)
    ]
  end

  private

  def self.available_objects
    %w(question answer comment user)
  end
end
