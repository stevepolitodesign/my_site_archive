class ImageAttacher
    def initialize(record, file, attachable)
        @record     = record
        @file       = file
        @attachable = attachable
    end

    def call
        @record.send(@attachable).attach(io: File.open(@file), filename: @file.split("/").last)
        if @record.save
            OpenStruct.new({success?:true, payload: @record})
        else
            OpenStruct.new({success?:false, errors: @record.errors.full_messages.to_sentence})
        end
    end

end