module FileNameable
    extend ActiveSupport::Concern

    def generate_file_name(extension: "png")
        "#{url.parameterize}-#{Time.zone.now.to_s.parameterize}.#{extension}"
    end

end