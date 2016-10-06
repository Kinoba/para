require 'csv'

module Para
  module Exporter
    class Csv < Base
      def render
        data = CSV.generate do |csv|
          csv << headers

          resources.each do |resource|
            csv << row_for(resource)
          end
        end

        Tempfile.new([name, extension]).tap do |file|
          file.write(data)
          file.rewind
        end
      end

      private

      def extension
        '.csv'
      end

      def headers
        fields.map do |field|
          encode(model.human_attribute_name(field))
        end
      end

      def row_for(resource)
        fields.map do |field|
          encode(resource.send(field))
        end
      end

      def encode(string)
        string.presence && string.to_s.encode('UTF-8')
      end
    end
  end
end
