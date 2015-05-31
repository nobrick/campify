module ApplicationHelper
  def render_before_content
    concat render 'shared/flash_messages' if render_flash?
    render 'op/shared/nav_links' if render_op_links?
  end
end
