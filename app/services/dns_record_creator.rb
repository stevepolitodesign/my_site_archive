# OPTIMIZE: Consider making this a Job
class DnsRecordCreator
    def initialize(zone_file, resource)
        @zone_file      = zone_file
        @resource       = resource 
        @record_type    = @resource.class.name.split('::').last.downcase
    end

    def call
        @dns_record = @zone_file.dns_records.create(record_type: @record_type, content: set_content, priority: set_priority )
        if @dns_record.save
            OpenStruct.new({success?: true, payload: @dns_record})
        else
            OpenStruct.new({success?: false, error: @dns_record.errors })
        end
    end

    private

        def set_content
            @contet = nil
            case @record_type
            when "cname"
                @contet = @resource.name.to_s
            when "a"
                @contet = @resource.address.to_s
            when "aaaa"
                @contet = @resource.address.to_s
            when "mx"
                @contet = @resource.exchange.to_s
            when "ns"
                @contet = @resource.name.to_s
            when "txts"
                @contet = @resource.strings.to_s
            end
        end

        def set_priority
            @priority = nil
            case @record_type
            when "mx"
                @priority = @resource.preference.to_i
            end
        end
end
