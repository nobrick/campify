module Uni::Users::RegistrationsHelper
  def tab_link_to(name, identifier, options = {})
    options.merge!({ 'aria-controls' => identifier, 'data-toggle' => 'tab', 'role' => 'tab' })
    link_to name, "##{identifier}", options
  end
end
