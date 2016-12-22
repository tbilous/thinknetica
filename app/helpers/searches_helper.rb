module SearchesHelper
  def searches_elements(items)
    results = []
    items.each do |item|
      results << content_tag(:div, class: 'search-item collection-item') do
        send("#{item.class.name.underscore}_element", item)
      end
    end
    results.join.html_safe
  end

  private

  def question_element(item)
    link_to(question_path(item)) do
      content_tag(:span, 'question', class: 'chip') +
      content_tag(:span, item.created_date, class: 'chip') +
      content_tag(:h5, item.title) +
      content_tag(:p, item.body.truncate(40))
    end
  end

  def answer_element(item)
    link_to(question_path(item.question_id)) do
      content_tag(:span, 'answer', class: 'chip') +
      content_tag(:span, item.created_date, class: 'chip') +
      content_tag(:p, item.body.truncate(40))
    end
  end

  def comment_element(item)
    if item.commentable_type == 'Question'
      path = question_path(item.commentable_id)
    else
      path = question_path(item.commentable.question_id)
    end

    link_to(path) do
      content_tag(:span, 'comment', class: 'chip') +
      content_tag(:span, item.created_date, class: 'chip') +
      content_tag(:p, item.body.truncate(40))
    end
  end

  def user_element(item)
    link_to('#') do
      content_tag(:span, 'user', class: 'chip') +
      content_tag(:p, item.email) +
      content_tag(:p, item.name)
    end
  end
end
