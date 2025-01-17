module ApplicationHelper
  include Pagy::Frontend

  def form_model_errors(model, attribute, css_class = "mt-2 text-sm text-red-600 dark:text-red-500")
    return unless model.errors[attribute].any?

    content_tag(:div, class: css_class, id: "#{attribute}_errors") do
      model.errors.full_messages_for(attribute).map do |message|
        content_tag(:p, message)
      end.join.html_safe
    end
  end
end
