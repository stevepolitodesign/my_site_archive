require "resolv"

class DnsRecordCreator
    def initialize(zone_file, record_type)
        @zone_file  = zone_file
        @website    = @zone_file.website
    end

    def call
        # TODO: I need to call this once per record_type per result record_type
    end
end
