module Paid
  class APIResource < APIClass
    attribute :id
    attribute :object

    api_instance_method :refresh, :get, :constructor => :self

    def path(base=self.class.path)
      unless id
        raise InvalidRequestError.new("Could not determine which URL to request: #{self.class} instance has an invalid ID: #{id.inspect}", 'id')
      end
      "#{base}/#{id}"
    end

  end
end
