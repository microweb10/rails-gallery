module RailsGallery
  module ViewHelper
    module TouchTouch
      def touchgal_image photo, options = {}
        content_tag :a, nil, options.merge(href: photo.path, title: photo.title)
      end
    end
  end
end
