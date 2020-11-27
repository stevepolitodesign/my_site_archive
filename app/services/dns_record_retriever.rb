require "resolv"

class DnsRecordRetriever
    def initialize(address, record_type)
        @address            = address
        @record_type        = record_type
        @resolv_typeclass   = "Resolv::DNS::Resource::IN::#{@record_type.upcase}".constantize
    end

    def call
        resources = Resolv::DNS.new.getresources(@address, @resolv_typeclass)
    rescue NameError, ArgumentError => error
        OpenStruct.new({success?: false, error: error})
    else
        OpenStruct.new({success?: true, payload: resources})
    end
end