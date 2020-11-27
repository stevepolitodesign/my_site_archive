class TmpFileRemover
    def initialize(file)
        @file = file
    end

    def call
        deleted_file = File.delete(@file)
        OpenStruct.new({ success?: true, payload: deleted_file })
    rescue Errno::ENOENT
        OpenStruct.new({ success?: false, error: Errno::ENOENT })
    end
end