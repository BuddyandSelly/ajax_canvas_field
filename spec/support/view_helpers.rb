# frozen_string_literal: true

module ViewHelpers
  # A view context of a real controller, so content_tag, image_tag and the
  # partial lookup of the engine all behave as they do in an application.
  def view
    @view ||= begin
      controller = CanvasController.new
      controller.request = ActionDispatch::TestRequest.create
      controller.view_context
    end
  end
end
